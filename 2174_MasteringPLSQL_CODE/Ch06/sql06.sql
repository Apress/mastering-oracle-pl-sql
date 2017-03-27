create table work_orders
  (wo_id number);

create sequence wo_seq;

create or replace trigger trg_wo_id
before insert
on work_orders
for each row
when (new.wo_id is null)
begin
   select wo_seq.nextval
   into   :new.wo_id
   from dual;
end;
/
