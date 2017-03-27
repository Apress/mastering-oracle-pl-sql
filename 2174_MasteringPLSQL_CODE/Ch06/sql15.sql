-- Accepts a table name and creates a simple auditing trigger
-- A shadow table (called <tname>$audit) has to exist already
CREATE OR REPLACE  PROCEDURE GENERATETRIGGER 
    generateTrigger(p_tableName in varchar2)
authid current_user
as
b varchar2(4000);
cursor c1 is
select column_name
from   user_tab_columns
where  table_name = p_tableName
order by column_id;

procedure appendx (destination in out varchar2,
                   string_in varchar2)
is
begin
destination := destination||string_in||chr(10);
end;

begin
-- build the create trigger command
   appendx(b,'create or replace trigger '||p_tableName||'ar');
   appendx(b,'after update or insert or delete on '||p_tableName||' ');
   appendx(b,'for each row');
   appendx(b,'declare');
   appendx(b,'my '||p_tableName||'$audit%ROWTYPE;');
   appendx(b,'begin ');
   appendx(b,'if inserting then my.change_type := ''I'';');
   appendx(b,'elsif updating then my.change_type :=''U'';');
   appendx(b,'else my.change_type := ''D'';');
   appendx(b,'end if;');
   appendx(b,'my.changed_by := user;');
   appendx(b,'my.changed_time := sysdate;');
   appendx(b,'case my.change_type');
   appendx(b,'when ''I'' then');

   for x in c1 loop
     appendx(b,'my.'||x.column_name||' := :new.'||x.column_name||';');
   end loop;
   appendx(b,'else');

   for x in c1 loop
      appendx(b,'my.'||x.column_name||' := :old.'||x.column_name||';');
   end loop;
   appendx(b,'end case;');

   appendx(b,'insert into '||p_tableName||'$audit values my;');
   appendx(b,'end;');

-- create the trigger
   execute immediate b;

end;
/