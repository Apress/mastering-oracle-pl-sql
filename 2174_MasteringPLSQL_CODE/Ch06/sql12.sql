-- After Row Autonomous Trigger 
-- Reads from the triggered table
create or replace trigger check_free_space_on_train
after update of reservation_no
on train_rides
for each row
declare
free_seats number;
PRAGMA AUTONOMOUS_TRANSACTION;
begin
   
      select  count(*)
      into    free_seats
      from    train_rides
      where   reservation_no is null and
                   train_no  =  :new.train_no and
                   travel_date = :new.travel_date;

      if free_seats < 50
         then add_a_coach(:new.train_no,:new.travel_date);
      end if;

      commit;
end;
