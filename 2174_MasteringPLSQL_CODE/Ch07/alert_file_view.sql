-- View that displays the alert file's error messages 
create or replace view alert_log_errors
as
select *
  from (
select *
  from (
select lineno,
       msg_line,
       thedate,
       max( case when ora_error like 'ORA-%'
                 then rtrim(substr(ora_error,1,instr(ora_error,' ')-1),':')
                 else null
             end ) over (partition by thedate) ora_error
  from (
select lineno,
       msg_line,
       max(thedate) over (order by lineno) thedate,
       lead(msg_line) over (order by lineno) ora_error
  from (
select rownum lineno,
       substr( msg_line, 1, 132 ) msg_line,
       case when msg_line like '___ ___ __ __:__:__ ____'
            then to_date( msg_line, 'Dy Mon DD hh24:mi:ss yyyy' )
            else null
       end thedate
  from alert_file_ext
       )
       )
       )
       )
 where ora_error is not null
 order by thedate
