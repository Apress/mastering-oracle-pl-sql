create or replace
PROCEDURE dml_handler(in_any IN SYS.ANYDATA) IS
   lcr          SYS.LCR$_ROW_RECORD;
   rc           PLS_INTEGER;
   oldlist      SYS.LCR$_ROW_LIST;
   newlist      SYS.LCR$_ROW_LIST;
   command      varchar2(32);
   tname        varchar2(30);
   v_scn        number;
   v_user       varchar2(30);
   v_date       date;
   v_change_id  number;
   newdata      sys.AnyData;

BEGIN
 
   -- Access the LCR
   rc      := in_any.GETOBJECT(lcr);
   command := lcr.GET_COMMAND_TYPE();
   tname   := lcr.GET_OBJECT_NAME;
   v_scn   := lcr.GET_SCN;
   oldlist := lcr.GET_VALUES('old');
   newlist := lcr.get_values('new');

-- lookup the info that we associated with this scn
-- and insert into audit_trail_1
   insert into audit_trail_1
   (change_id, command_type, table_name, user_name,change_date)
   select data_audit_seq.nextval,substr(command,1,1),
          tname,scn_user,scn_date
   from   audit_temp
   where  scn = v_scn;
   
-- write audit_trail_2
   IF command = 'DELETE' then
      FOR i IN 1..oldlist.COUNT LOOP
         insert into audit_trail_2
         (change_id, column_name,actual_data_old)
         values (data_audit_seq.currval,
                 oldlist(i).column_name,oldlist(i).data);
      END LOOP;
   ELSIF command = 'INSERT' then
      FOR i IN 1..newlist.COUNT LOOP
         insert  into audit_trail_2
         (change_id, column_name,actual_data_new)
        values (data_audit_seq.currval,
                 newlist(i).column_name,newlist(i).data);
      END LOOP;
   ELSIF command = 'UPDATE' then
      FOR i IN 1..oldlist.COUNT LOOP
         newdata := lcr.get_value('new',oldlist(i).column_name);
    if newdata is null then
            newdata := oldlist(i).data;
    end if;
    insert into audit_trail_2
         (change_id, column_name,actual_data_new,actual_data_old)
        values (data_audit_seq.currval,
                 oldlist(i).column_name,newdata,oldlist(i).data);
   END LOOP;
END IF;

END;
/