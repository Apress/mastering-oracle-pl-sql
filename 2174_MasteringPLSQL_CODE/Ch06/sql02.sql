-- create full set of triggers on dept and emp tables

-- Create a Before Statement trigger
create or replace trigger deptbs
  before insert or update or delete
   on dept
   begin
      dbms_output.put_line('before statement (dept)');
   end;
/
-- Create a Before Statement trigger
create or replace trigger empbs
  before insert or update or delete
   on emp
   begin
      dbms_output.put_line('before statement (emp)');
   end;
/

-- Create a Before Row Trigger
  create or replace trigger emp_br
    before insert or update or delete
    on emp
    for each row
    begin
       dbms_output.put_line('...before row (emp)');
    end;
/

-- Create an After Row Trigger
create or replace trigger emp_ar
    after insert or update or delete
    on emp
    for each row
    begin
       dbms_output.put_line('...after row (emp)');
    end;
/
-- Create a Before Row Trigger
  create or replace trigger dept_br
    before insert or update or delete
    on dept
    for each row
    begin
       dbms_output.put_line('...before row (dept)');
    end;
/

-- Create an After Row Trigger
create or replace trigger dept_ar
    after insert or update or delete
    on dept
    for each row
    begin
       dbms_output.put_line('...after row (dept)');
    end;
/



-- Create an After Statement Trigger
 create or replace trigger empas
    after insert or update or delete
    on emp
    begin
       dbms_output.put_line('after statement (emp)');
    end;
/
-- Create an After Statement Trigger
 create or replace trigger deptas
    after insert or update or delete
    on dept
    begin
       dbms_output.put_line('after statement (dept)');
    end;
/

