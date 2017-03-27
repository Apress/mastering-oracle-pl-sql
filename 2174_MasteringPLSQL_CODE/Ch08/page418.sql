conn system/manager
-- show roles
select * from session_roles;
-- show roles in a procedure
create or replace procedure show_privs
as
begin
  dbms_output.put_line('ROLES:');
  for rec in (select * from session_roles)
  loop
    dbms_output.put_line(rec.role);
  end loop;
end;
/
set serveroutput on
exec show_privs
drop procedure show_privs;
