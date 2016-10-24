connect blake/blake
-- create template EMP table
create table EMP as select * from SCOTT.EMP where 1=2;
CREATE OR REPLACE PROCEDURE update_sal
(
p_empno in number,
p_sal in number
)
authid current_user
AS
BEGIN
update EMP set sal = p_sal where empno = p_empno;
 END;
 /
 
drop procedure update_sal;
