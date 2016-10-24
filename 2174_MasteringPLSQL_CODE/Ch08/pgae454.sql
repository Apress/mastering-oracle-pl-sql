conn scott/tiger
create or replace procedure MY_PROC
  as
  v_local_var varchar2(30) := 'This is a secret string';
  begin
          -- here is the source code.  it is
          -- beneficial if users can’t see the source code.
   null;  -- this is the sensitive part
  end;
/
grant execute on my_proc to blake;

conn blake/blake
exec scott.my_proc
col text format a65
select text from all_source where name='MY_PROC' order by line;

conn scott/tiger
drop procedure my_proc;
