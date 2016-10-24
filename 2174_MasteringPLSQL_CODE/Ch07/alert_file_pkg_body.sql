CREATE OR REPLACE  PACKAGE BODY "ALERT_FILE"  is
-- extracts error messages from the alert file
-- renames the alert file
-- extracts all messages from the alert file
-- calls notification package to send emails

procedure rename_alert_file (l_instance_name in varchar2)
as
-- It assumes that the alert log is named alert_INSTANCE.log
-- and renames it to alert_INSTANCEDay.log
alert_file_does_not_exist EXCEPTION;
PRAGMA exception_init(alert_file_does_not_exist, -29283);
begin
-- rename the alert file
   utl_file.frename (
      src_location => 'ALERT_DIR',
      src_filename => 'alert_'||l_instance_name||'.log',
      dest_location => 'ALERT_DIR',
      dest_filename => 'alert_'||l_instance_name||
                          to_char(sysdate - 1,'Dy')||'.log',
      overwrite    =>  true);

exception
	when alert_file_does_not_exist then
         null;
end;



procedure read_alert_file (error_msg_arry out notification.msgs,
                           linecount out integer)
as
-- reads the alert file
-- Save any error messages in an associative array

cursor c1 is
      select msg_line
      from   alert_file_ext;

l_buffer    varchar2(1000);
l_msg_text  varchar2(32767);
error_count binary_integer :=0;
begin
-- open the cursor
   open c1;

-- read ahead (probably the date line)
   fetch c1 into l_buffer;

   while c1%FOUND loop
--     save the date line
       l_msg_text := l_buffer;

--     read the first msg body line
       fetch c1 into l_buffer;
       while (l_buffer not like '___ ___ __ __:__:__ ____'  and c1%FOUND) loop
            l_msg_text := l_msg_text||chr(10)||l_buffer;
            fetch c1 into l_buffer;
            end loop;

--     check for error
       if (instr(l_msg_text,'ORA-') > 0) then
            error_count := error_count + 1;
            error_msg_arry(error_count) := l_msg_text;
       end if;

       end loop;
   linecount := c1%ROWCOUNT;
   close c1;
end;


procedure update_skip_count(p_count in number default 0,
                  reset boolean default false)
as
-- update access parameters of external table
i number;
j number;
adj number := p_count;
begin
   for x in (select replace(access_parameters,chr(10)) param
             from   user_external_tables
             where  table_name = 'ALERT_FILE_EXT') loop

       i := owa_pattern.amatch(x.param,1,'.*skip',i);
       j := owa_pattern.amatch(x.param,1,'.*skip \d*');

--  to reset the count (to zero)
       if reset then
		adj := -1 * to_number(substr(x.param,i,j-i));
       end if;

       execute immediate 'alter table alert_file_ext access parameters ('||
	 substr(x.param,1,i)||
       (to_number(substr(x.param,i,j-i))+ adj)||
       substr(x.param,j)||')';

       end loop;
end;


procedure review_alert_file ( p_instance_name_in in varchar2)
is
alert_msg_arry notification.msgs;
begin                                             
    select msg_line                                                                                     
    bulk collect                                                                                        
    into alert_msg_arry                                                                                 
    from alert_file_ext;                                                                                

    notification.notify(instance_name_in => p_instance_name_in,
                         msgs_in => alert_msg_arry,
                         subject_in => 'Review Alert File',
                         email_p => true,
                         db_p => false);                                                       
end;                                                                                                


procedure monitor_alert_file
as
error_msg_arry notification.msgs;
lcount integer;
l_instance_name varchar2(16);
exists_p boolean;
flength number;
bsize number;
alert_file_does_not_exist exception;
PRAGMA EXCEPTION_INIT(alert_file_does_not_exist, -29913);

begin
-- check location of alert file
    select instance_name
    into   l_instance_name
    from   v$parameter,v$instance,dba_directories
    where  directory_name = 'ALERT_DIR' and
           name='background_dump_dest' and
           value = directory_path;

--  monitor the alert file and save errors
    read_alert_file(error_msg_arry,lcount);

--  update the external tables's access parameters
    update_skip_count(lcount);

--  send any any error messages
    if error_msg_arry.last > 0 then
          notification.notify(instance_name_in => l_instance_name,
                         msgs_in => error_msg_arry,
                         subject_in => 'ALERT FILE',
                         email_p => true,
                         db_p => false);
    end if;

--  rollover the alert file based on time and filesize
    if to_char(sysdate,'hh24')= '06' and
        to_char(sysdate,'mi') < '20' then
          utl_file.fgetattr (
              location => 'ALERT_DIR',
              filename => 'alert_'||l_instance_name||'.log',
              fexists  => exists_p,
              file_length => flength,
              block_size  => bsize);

          if flength > 3000 then             
             update_skip_count(reset=>true);
             review_alert_file(l_instance_name);
             rename_alert_file(l_instance_name);
          end if;
    end if;


exception
   when alert_file_does_not_exist then
      null;
   when no_data_found then
		raise_application_error(-20000,'ALERT_DIR is not current');
   when others then
      raise_application_error(-20000,dbms_utility.format_error_stack);
end;
end;