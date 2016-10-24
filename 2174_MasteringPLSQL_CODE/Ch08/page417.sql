conn system/manager
set serveroutput on
declare
  l_module varchar2(48);
begin
  select b.module into l_module
    from v$session b
  where b.audsid = sys_context('userenv','sessionid');
  dbms_output.put_line('Current Program is ' || l_module);
end;
/

create or replace function get_my_program
  return varchar2
as
  l_module varchar2(48);
begin
  select b.module into l_module
    from v$session b
  where b.audsid = sys_context('userenv','sessionid');
  return l_module;
end;
/
drop function get_my_program;
show errors
