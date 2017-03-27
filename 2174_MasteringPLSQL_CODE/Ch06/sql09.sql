CREATE OR REPLACE  PACKAGE TRAIN_RIDE_PACKAGE  is
   procedure set_initial_state;
   procedure save_train_no (trainid number,dateid date);
   procedure check_free_space_on_train;
end;
/

CREATE OR REPLACE  PACKAGE BODY TRAIN_RIDE_PACKAGE 
is
-- This package body creates the procedures that the
-- triggers will execute

   type train_table is table of date index by pls_integer;

   position train_table;
   empty    train_table;


procedure set_initial_state is
-- initialize the associative array
begin
   position := empty;
end;

procedure save_train_no (trainid number, dateid date) is
-- save the trainId and travelDate
begin
   position(trainid) := dateid;
end;

procedure check_free_space_on_train
is
-- retrieve the trainId and travelDate
-- and query the train_ride table
-- Add a coach when necessary
trainid_in number;
free_seats number;

begin
   trainid_in := position.FIRST;
   while trainid_in is not null loop

      select  count(*)
      into    free_seats
      from    train_rides
      where   reservation_no is null and
                   train_no  =  trainid_in and
                   travel_date = position(trainid_in);

      if free_seats < 50
         then add_a_coach(trainid_in,position(trainid_in));
      end if;

      position.delete(trainid_in);
      trainid_in := position.next(trainid_in);
   end loop;
end;

end;
/
