create or replace
procedure AlterUser (usernameIn in varchar2) is
begin
   execute immediate ( 'alter user ' ||usernameIn|| 
' default tablespace users');
end;
/
create or replace
trigger SystemAlterUser
 after create on database
 declare
 jobno number;
 begin
 if ora_dict_obj_type = 'USER' then
    dbms_job.submit(job => jobno, what => 'alteruser('''||ora_dict_obj_name||''');');
 end if;
 end;
/
