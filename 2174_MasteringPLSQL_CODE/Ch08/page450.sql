conn system/manager

begin
  DBMS_FGA.ADD_POLICY(object_schema   => 'SCOTT',
                      object_name     => 'EMP',
                      policy_name     => 'EMP_TRIG_AUD',
                      audit_condition => '1=1',
                      audit_column    => NULL,
                      handler_schema  => NULL,
                      handler_module  => NULL,
                      enable          => TRUE,
                      statement_types => 'SELECT,INSERT,UPDATE,DELETE');
 end;
 /
 