conn blake/blake
update scott.emp set sal = 0
  where sal >
    (select sal from scott.emp
       where ename = 'BLAKE');
-- cover trail
rollback;

conn scott/tiger
create table aud_emp_tab (
  username varchar2(30),
  action      varchar2(6),
  column_name varchar2(255),
  empno       number(4),
  old_value   number,
  new_value   number,
  action_date date
  )
/

CREATE OR REPLACE TRIGGER aud_emp
   BEFORE UPDATE OF SAL
   ON EMP
   FOR EACH ROW

DECLARE
PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
  INSERT into aud_emp_tab 
    values (sys_context('USERENV','SESSION_USER'), 
            'UPDATE', 
            'SAL',
            :old.empno,
            :old.sal, 
            :new.sal, 
            SYSDATE );
  COMMIT;
END;
/
grant update(sal) on emp to blake;
conn blake/blake
update SCOTT.EMP set sal = 5000 where empno=7698;
-- cover trail
rollback;

conn scott/tiger
col username format a8
col column_name format a12
select username, empno, old_value, new_value, 
  to_char(action_date, 'Mon-DD-YYYY HH24:MI:SS') Time 
  from aud_emp_tab;
