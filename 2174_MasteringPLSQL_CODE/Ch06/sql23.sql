Create or replace trigger loginCheckTrg after logon on database
declare
   m_count number;
begin
   select count(*)
   into   m_count
   from   v$session
   where  audsid=sys_context('userenv','sessionid')
   and    program like '%MSQRY32.EXE%';
   if m_count > 0 then
      raise_application_error(-20000,'Please try again later');
   end if;
end;
/