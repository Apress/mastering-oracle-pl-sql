-- test as blake (recreated for this example)
connect blake/blake
-- show data
select ename, empno, sal from SCOTT.EMP where ename = USER;
-- show direct updates don't work
update SCOTT.emp set sal = sal * 1.1;
-- show procedure invocation works
execute SCOTT.update_sal(p_empno => 7698, p_sal => 3000)
-- show data
select ename, empno, sal from SCOTT.EMP where ename = USER;

conn scott/tiger
drop procedure update_sal;
