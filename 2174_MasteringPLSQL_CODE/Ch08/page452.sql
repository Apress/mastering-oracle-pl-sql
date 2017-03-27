connect sys/oracle as sysdba

create or replace trigger user_logon_module_check
  after logon on database
DECLARE
  l_module v$session.module%type;
BEGIN
  select upper(module) into l_module from v$session b
    where b.audsid = userenv('sessionid');
  IF ( l_module = 'EXCEL.EXE' OR
       l_module = 'MSQRY32.EXE') THEN
    raise_application_error(-20001,'Unauthorized Application');
 END IF;
END;
/
