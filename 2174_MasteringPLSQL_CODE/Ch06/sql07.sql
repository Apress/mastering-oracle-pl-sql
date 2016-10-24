-- Create a view that displays average salary by department
    create view dept_sal
    as
    select dname,round(avg(sal),2) avgSalary
    from   emp,dept
    where  emp.deptno = dept.deptno
   group by dname
/

-- Instead of trigger to update emp and dept table
-- when updating the dept_sal view
    create or replace trigger dept_sal_trg
    instead of update on dept_sal
    begin
    if (nvl(:new.avgsalary,-1) <> nvl(:old.avgsalary,-1)) then
       update emp
       set    sal = (:new.avgsalary/:old.avgsalary) * sal
       where deptno = (select deptno
                       from   dept
                       where  dname = :new:old.dname);
    end if; 
       update dept
       set    dname = :new.dname
       where  dname = :old.dname;
  end;
/
