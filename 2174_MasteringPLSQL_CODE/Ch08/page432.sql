conn scott/tiger
CREATE OR REPLACE package sample_package
as
  pv_this_is_public varchar2(6) := 'Hello';
  function a_function return varchar2;
  procedure a_procedure;
end;
/

describe sample_package

col text format a70
select text from user_source 
  where name = 'SAMPLE_PACKAGE';
drop package sample_package;
