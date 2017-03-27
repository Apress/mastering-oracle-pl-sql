alter table dept
add
(last_update date,
 last_user varchar2(30));

CREATE OR REPLACE TRIGGER deptBR
     before update or insert
     ON dept
     FOR EACH ROW
     DECLARE
     begin
        :new.last_update := sysdate;
        :new.last_user := user;
    end;
/