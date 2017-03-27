conn scott/tiger
create table user_info
(
username varchar2(30) constraint user_info_pk primary key,
image_url varchar2(2000)
)
/
insert into user_info values
('SCOTT','http://imageserver.company.com/img/scott.gif');
insert into user_info values
('BLAKE','http://imageserver.company.com/img/blake.gif');
commit;

CREATE OR REPLACE TRIGGER user_img_update_check
BEFORE UPDATE OF image_url
ON user_info
FOR EACH ROW
DECLARE
BEGIN
IF (sys_context('USERENV','SESSION_USER') != :new.username)
then
raise_application_error(-20001,'Unauthorized update!');
END IF;
END;
/

update user_info
  set image_url = 'http://funnypictures.com/img/tomCrusie.jpg'
  where username = 'SCOTT';
commit;
  