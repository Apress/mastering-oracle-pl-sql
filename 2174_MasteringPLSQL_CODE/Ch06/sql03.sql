create or replace type outputLines as table of varchar2(4000);
/

-- Function to display trigger text by line number
-- Counts the chr(10) linefeed character
create or replace function
TriggerText (p_owner in varchar2, p_trigger in varchar2) return outputLines
authid current_user
pipelined
as
    body long;
    j number; -- position of linefeed character
    begin
        select trigger_body
        into   body
        from   all_triggers
        where  trigger_name = p_trigger and
               owner = p_owner; 
  
        body := body || chr(10);
        while ( body is not null ) loop
            j := instr( body, chr(10) );
            pipe row ( substr( body, 1, j-1 ) );
            body := substr( body, j+1 );
        end loop;
    return;
   end;
/
