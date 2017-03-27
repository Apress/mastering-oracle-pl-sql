create table our_user_errors
(error_date date,
 username varchar2(30),
 error_msg varchar2(2000),
 error_sql varchar2(2000));

-- Save information about all errors 	
create or replace trigger log_errors
   after servererror on database
declare
   sql_text ora_name_list_t;
   msg varchar2(2000) := null;
   stmt varchar2(2000):= null;
begin
   for i in 1 .. ora_server_error_depth loop
      msg := msg||ora_server_error_msg(i);
   end loop;
   for i in 1..ora_sql_txt(sql_text) loop
      stmt := stmt||sql_text(i);
   end loop;
   insert into our_user_errors
   (error_date,username,error_msg,error_sql)
   values (sysdate,ora_login_user,msg,stmt);
end;
/
