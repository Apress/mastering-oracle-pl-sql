create table old_source_header
(username varchar2(30),
 change_id number,
 change_date date);


create table old_source_detail
(change_id number,
 owner varchar2(30),
 name varchar2(30),
 type varchar2(12),
 line number,
 text varchar2(4000));

create sequence source_seq;


-- Save the code before any changes are made to it
create or replace trigger save_old_code
before create on database
begin
   if ora_dict_obj_type in 
      ( 'PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION' )  then

            insert  into old_source_header
                    (username,change_id,change_date)
            values  (ora_login_user,source_seq.nextval,sysdate);

            insert into old_source_detail
            select source_seq.currval,dba_source.*
            from   dba_source
            where  owner = ora_dict_obj_owner and
                   name = ora_dict_obj_name and
                   type = ora_dict_obj_type;
   end if;
end;
/
