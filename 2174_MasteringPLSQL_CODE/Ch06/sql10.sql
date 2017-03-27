CREATE OR REPLACE TRIGGER TRG_TR_AR AFTER
UPDATE ON TRAIN_RIDES FOR EACH ROW begin
   train_ride_package.save_train_no
      (:new.train_no,:new.travel_date);
end;
/

CREATE OR REPLACE TRIGGER TRG_TR_AS AFTER
UPDATE ON TRAIN_RIDES begin
   train_ride_package.check_free_space_on_train;
end;
/

CREATE OR REPLACE TRIGGER TRG_TR_BS BEFORE
UPDATE ON TRAIN_RIDES begin
   train_ride_package.set_initial_state;
end;
/