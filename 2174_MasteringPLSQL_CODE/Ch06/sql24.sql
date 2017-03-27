CREATE OR REPLACE TRIGGER change_schema
AFTER logon ON DATABASE
begin
 execute immediate('alter session set current_schema=app_master');
end;
/