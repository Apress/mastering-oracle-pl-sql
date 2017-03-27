create audit_trail_1
(change_id number,
 command_type varchar2(1), 
 table_name varchar2(30),
 user_name  varchar2(30),
 change_date date);

create table audit_trail_2
(change_id       number,
 column_name     varchar2(30),
 actual_data_new sys.anydata,
 actual_data_old sys.anydata);
