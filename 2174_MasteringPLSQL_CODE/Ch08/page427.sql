conn system/manager
create role emp_update;
grant update on SCOTT.EMP to emp_update;
grant emp_update to blake;

conn blake/blake
CREATE or replace PROCEDURE update_sal (p_empno in number, p_sal in number)
  authid current_user
  AS
  BEGIN
    update SCOTT.EMP set sal = p_sal where empno = p_empno;
  END;
  /
sho errors
CREATE OR REPLACE procedure update_sal 
(
p_empno in number, 
p_sal in number
)
authid current_user
as
begin
  execute immediate 'update SCOTT.EMP set ' ||
                    'sal = :x ' ||
                    'where empno = :y' using p_sal, p_empno;
end;
/

exec update_sal (7698,5000);
select ename, empno, sal from SCOTT.EMP where ename = USER;
drop procedure update_sal;
