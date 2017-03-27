conn system/manager
create or replace function get_my_program
return varchar2
authid current_user
as
  l_module varchar2(48);
  l_query varchar2(500);
begin
  l_query := 'select b.module ' ||
             'from v$session b ' ||
             'where b.audsid = sys_context(''userenv'',''sessionid'')';
   execute immediate l_query into l_module;
   return l_module;
end;
/
select get_my_program from dual;
drop function get_my_program;
