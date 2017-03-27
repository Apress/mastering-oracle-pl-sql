CREATE OR REPLACE  PROCEDURE ADD_A_COACH (id in number, dt
    in date)
as
begin
   insert into train_rides
   (train_no,travel_date,coach_no,seat_no)
    select train_no,trunc(sysdate),coach_no + 1,rownum
    from    train_rides
    where   rownum < 101
    and     train_no = 1;
end;
/