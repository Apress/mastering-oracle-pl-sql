CREATE TABLE DEPT$AUDIT (
DEPTNO       NUMBER, 
DNAME        VARCHAR2(14 byte), 
LOC          VARCHAR2(13 byte), 
CHANGE_TYPE  VARCHAR2(1 byte),
CHANGED_BY   VARCHAR2(30 byte), 
CHANGED_TIME DATE);

CREATE OR REPLACE TRIGGER auditDEPTAR AFTER
INSERT
OR UPDATE
OR DELETE ON DEPT FOR EACH ROW 
declare
my DEPT$audit%ROWTYPE;
begin 
if inserting then my.change_type := 'I';
elsif updating then my.change_type :='U';
else my.change_type := 'D';
end if;

my.changed_by := user;
my.changed_time := sysdate;

case my.change_type
when 'I' then
   my.DEPTNO := :new.DEPTNO;
   my.DNAME := :new.DNAME;
   my.LOC := :new.LOC;
else
   my.DEPTNO := :old.DEPTNO;
   my.DNAME := :old.DNAME;
   my.LOC := :old.LOC;
end case;

insert into DEPT$audit values my;
end;
/

    