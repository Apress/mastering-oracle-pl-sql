conn system/manager
set serveroutput on
declare 
l_aud_str varchar2(256);
begin
  l_aud_str := 'select db_user, client_id, ' ||
    'userhost, substr(sql_text,1,50) SQL, '||
    'timestamp day, to_char(timestamp,''HH24:MI:SS'') time ' ||
    'from sys.dba_fga_audit_trail ' ||
    'where object_schema = ''SCOTT'' and ' ||
    'object_name = ''EMP''';
  print_table(l_aud_str);
end;
/
