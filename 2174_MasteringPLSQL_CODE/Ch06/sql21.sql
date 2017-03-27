create or replace trigger prevent_drop
before drop on alex.schema
begin
   raise_application_error(-20000,'Invalid command: DROP ');
end;
/
