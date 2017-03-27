Procedure checkStatusOfLastBackup (p_instance_name_in in varchar2)
is
-- Check that there was an RMAN full database online backup
-- sometime within the last day (threshold = 1)
notes notification.msgs;
THRESHOLD number(4,2) := 1;
Begin
   -- build a message containing the date of the last full RMAN backup
   select   to_char(sysdate,'Dy Mon dd hh24:mi:ss yyyy')||chr(10)||
           'Most recent full backup was '||
            extract(day from (systimestamp - completion_time))|| ' Days and '||
            extract(hour from (systimestamp - completion_time))|| ' hours ago.'
bulk collect into notes
from        v$backup_set a
where       completion_time=
              (select max(completion_time)
               from v$backup_set
               where nvl(incremental_level,10) =
                     nvl(a.incremental_level,10) and
                     backup_type = a.backup_type) and
            backup_type='D' and
            incremental_level is null and
            sysdate - completion_time > THRESHOLD;

-- If there is a message to send, then send it.
if notes.last > 0 then
    notification.notify(instance_name_in => p_instance_name_in,
                         msgs_in => notes,
                         subject_in => 'BACKUPS',
                         email_p => false,
                         db_p => true);            
end if;
end;


-- Check free space in archive destination
procedure checkArchiveDestination (p_instance_name_in in varchar2)
is 
-- check the space used in the archive1 destination
-- (threshold 80%)                                                                                              
THRESHOLD number(4,2):= 80.0;
notes notification.msgs;
begin 
-- build a message identifying the destination(s) that is atleast 80% full
select    to_char(sysdate,'Dy Mon dd hh24:mi:ss yyyy')||chr(10)||
          'Archive: '||dest_name||' '||destination||
          ' is '||
          to_char(round(1 - (quota_size-quota_used)/(quota_size),4)*100 )||
          '% full.'
bulk collect into notes
from      v$archive_dest
where     round(1 - (quota_size-quota_used)/(quota_size),4)*100 > THRESHOLD
          and schedule = 'ACTIVE';

-- if the previous query found any rows, the messages will be contained  
-- in the notes array. If the array is not empty send an email
if notes.last > 0 then
   notification.notify(instance_name_in => p_instance_name_in,
                         msgs_in => notes,
                         subject_in => 'ARCHIVE',
                         email_p => true,
                         db_p => true);  
end if;          
end;

procedure checkFreeSpace (p_instance_name_in in varchar2)
is
                                                                                                 
-- Check spaced used by tablespaces 
THRESHOLD number(4,2):= 80.0;
notes notification.msgs;
begin
-- build a message after checking the free space and the used
-- space if the used space is greater than the threshold
    select  to_char(sysdate,'Dy Mon dd hh24:mi:ss yyyy')||chr(10)||
        'Tablespace '||a.tablespace_name||
        ' is '||
        to_char(round(1 - (free+potential)/(allocated+potential),4)*100)||
        '% full.'
bulk collect into notes
from 
  (select   tablespace_name,sum(bytes) free
   from     dba_free_space
   group by tablespace_name) f,
  (select   tablespace_name,sum(bytes) allocated,
            sum(maxbytes) potential
   from     dba_data_files
   group by tablespace_name) a
where a.tablespace_name = f.tablespace_name (+) and 
      round(1 - (free+potential)/(allocated+potential),4)*100
      > THRESHOLD;

-- If there are any rows retrieved by the above query then
-- send a notification
if notes.last > 0 then
   notification.notify(instance_name_in => p_instance_name_in,
                         msgs_in => notes,
                         subject_in => 'STORAGE',
                         email_p => false,
                         db_p => true);            
end if;
end;	
end;
/