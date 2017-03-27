conn scott/tiger
create or replace procedure show_privs
  authid current_user  
  as
  begin
    dbms_output.put_line('ROLES:');
    for rec in (select * from session_roles)
    loop
      dbms_output.put_line(rec.role);
    end loop;
  end;
  /
execute show_privs
drop procedure show_privs;
