conn system/manager
create user blake identified by blake
  default tablespace users temporary tablespace temp;
grant create session, create procedure, 
  create table, unlimited tablespace to blake;

conn scott/tiger
CREATE PROCEDURE update_sal (p_empno in number, 
                             p_sal in number)
AS
BEGIN
  /*
   * Could have done data and/or security checking: 
   * Examples:
   *   p_sal > sal;
   *   updating during "normal" operating hours;
   *   user executing procedure is updating just 
   *      their salary;
   */
  update EMP set sal = p_sal where empno = p_empno;
END;
/

grant execute on update_sal to blake;
-- let user see the data
grant select on EMP to blake;
