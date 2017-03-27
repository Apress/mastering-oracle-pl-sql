conn sys/oracle as sysdba
create or replace trigger set_client_id
after logon on database
DECLARE
  l_module v$session.module%type;
BEGIN
  select upper(module) into l_module
    from v$session b
    where b.audsid = userenv('sessionid');
  dbms_session.set_identifier(sys_context('userenv','ip_address')
                              ||':' ||
                              nvl(l_module,'No Module Specified'));
 END;
 /