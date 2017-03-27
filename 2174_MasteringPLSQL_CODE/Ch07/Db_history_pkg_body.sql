-- Get the size of the database by summing the size of all the db objects
procedure databaseSize (p_instance_name_in in varchar2)
is
                                                                                               
notes notification.msgs;

begin
-- Get the size of the database (Mb) text message
select to_char(sysdate,'Dy Mon dd hh24:mi:ss yyyy')||chr(10)||
       'DB Size(Mb) '||
       to_char(round(sum(bytes)/(1024*1024),2)) 
bulk   collect into notes
from   dba_segments;
 
-- Extract the size from the above message and save it as the result_in
notification.notify(instance_name_in => p_instance_name_in,
                       msgs_in => notes,
                       subject_in => 'GROWTH',
                       result_in => substr(notes(1),37),
                       email_p => false,
                       db_p => true);            
end;


-- Get the number of user sessions logged in right now 
procedure databaseSessions (p_instance_name_in in varchar2)
is
                                                                                               
notes notification.msgs;

begin 
-- Get the number of sessions
select to_char(sysdate,'Dy Mon dd hh24:mi:ss yyyy')||chr(10)||
       'Sessions '||count(*) 
bulk   collect into notes
from   v$session
where  type = 'USER';

-- extract the number of sessions from the above text and save as result_in
notification.notify(instance_name_in => p_instance_name_in,
                       msgs_in => notes,
                       subject_in => 'SESSIONS',
                       result_in => substr(notes(1),34),
                       email_p => false,
                       db_p => true);            

end;


procedure resourceLimit (p_instance_name_in in varchar2)
is
                                                                       
notes notification.msgs;

begin 
select to_char(sysdate,'Dy Mon dd hh24:mi:ss yyyy')||chr(10)||
       rpad(resource_name,30)||' Max: '||lpad(max_utilization,10)
bulk collect into notes
from v$resource_limit
where trim(limit_value) != 'UNLIMITED';

-- save the elapsed time as result_in
notification.notify(instance_name_in => p_instance_name_in,
                       msgs_in => notes,
                       subject_in => 'RESOURCE _LIMIT',
			     result_in => -1,
                       email_p => false,
                       db_p => true);            
end;

end;
/
