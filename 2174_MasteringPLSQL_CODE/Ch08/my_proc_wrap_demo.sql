create or replace procedure MY_PROC
  as
  v_local_var varchar2(30) := 'This is a secret string';
  begin
          -- here is the source code.  it is
          -- beneficial if users can’t see the source code.
   null;  -- this is the sensitive part
  end;
/
