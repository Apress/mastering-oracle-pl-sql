conn system/manager
begin
  DBMS_FGA.ADD_POLICY(object_schema => 'SCOTT',
                    object_name=>'EMP', 
                    policy_name => 'EMP_INS_UPD', 
                    audit_condition => '1=1', 
                    audit_column =>'SAL', 
                    handler_schema => NULL, 
                    handler_module => NULL, 
                    enable => TRUE, 
                    statement_types=> 'INSERT,UPDATE');
end;
/

conn blake/blake
update SCOTT.EMP set sal = 5000 where empno=7698;
-- cover trail
rollback;

conn system/manager
col db_user format a6
col schema format a6
col object format a4
col SQL_TEXT format a50

select db_user, statement_type action,
  object_schema schema, object_name object,
  to_char(timestamp, 'Mon-DD-YYYY HH24:MI:SS') Time,
  SQL_TEXT
  FROM sys.dba_fga_audit_trail;
  
drop table scott.aud_emp_tab;
