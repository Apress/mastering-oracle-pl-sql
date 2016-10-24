create or replace trigger save_the_database_from_alex
after logon on alex.schema
begin
   if to_char(current_timestamp,'hh24') between 08 and 18 and
      to_char(current_timestamp,'d') between 2 and 5 then
           raise_application_error(-20000,
             'Do you realize that this is a production database?');
   end if;
end;
/
