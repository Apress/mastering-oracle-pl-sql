create table usage_log
(user_id  varchar2(30),
 audsid   varchar2(30),
 log_on   date,
 log_off  date,
 cpu_used number);
 
-- database login trigger
create or replace trigger usage_start
after logon on database
begin
 insert into system.usage_log
 (user_id,audid,log_on,log_off,cpu_used)
  values (sys_context('userenv','session_user'),
          sys_context('userenv','sessionid'),
          sysdate, null, null);
end;
/

-- database logoff trigger
create or replace trigger usage_stop
before logoff on database
begin
  update system.usage_log
  set    log_off = sysdate,
         cpu_used = (select value
                     from   v$mystat s,v$statname n
                     where  s.statistic# = n.statistic# and
                            n.name like 'CPU used by this session')
  where  sys_context('USERENV', 'SESSIONID') = audid and
         sys_context('userenv','session_user') = user_id and
         log_off is null;
end;
/