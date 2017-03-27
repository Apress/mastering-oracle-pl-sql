connect system/manager
create user alpha identified by a;
create user beta identified by b;

conn scott/tiger
create or replace package alpha_package
as
  PROCEDURE P1;
  PROCEDURE P2;
  PROCEDURE P3;
  FUNCTION F1 return number;
  FUNCTION F2 return number;
end;
/
grant execute on alpha_package to alpha;

create or replace package beta_package
as
  PROCEDURE P3;
  PROCEDURE P4;
  PROCEDURE P5;
  FUNCTION F1 return number;
  FUNCTION F3 return number;
end;
/
grant execute on beta_package to beta;

create or replace package body beta_package
as
  PROCEDURE P3
  as 
    begin
      ALPHA_PACKAGE.P3;
    end;
    
  FUNCTION F1 return number
  as
    begin
      return ALPHA_PACKAGE.F1;
    end;
  
  PROCEDURE P4
  as 
    begin
      null;
    end;
  
  PROCEDURE P5
  as 
    begin
      null;
    end;
  
  FUNCTION F3 return number
  as
    begin
      return 1;
    end;
end;
/

create or replace package body alpha_package
as
  PROCEDURE P1
  as 
    begin
      null;
    end;
    
  PROCEDURE P2
  as 
    begin
      null;
    end;
  
  PROCEDURE P3
  as 
    begin
      null;
    end;
  
  FUNCTION F1 return number
  as
    begin
      return 1;
    end;
  
  FUNCTION F2 return number
  as
    begin
      return 1;
    end;
end;
/

-- clean up on page436.sql
