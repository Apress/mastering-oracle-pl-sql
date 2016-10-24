select name as "Trigger",
       table_name as "Base Table",
       referenced_name as "References TableName"
from   user_dependencies,user_triggers
where  type='TRIGGER' and
       referenced_type = 'TABLE' and
       table_name != referenced_name and
       name = trigger_name
order by 1;
