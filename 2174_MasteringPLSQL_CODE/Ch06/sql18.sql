-- Display values stored in a sys.anydata column
create or replace
function disp_any(data IN SYS.AnyData)
return varchar2 IS
   str VARCHAR2(4000);
   return_value varchar2(4000);
   chr CHAR(255);
   num NUMBER;
   dat DATE;
   res number;
begin
   if data is null then
      return_value := null;
   else
      case data.gettypename
         when 'SYS.VARCHAR2' then
            res := data.GETVARCHAR2(str);
            return_value := str;
         when 'SYS.CHAR' then
            res := data.GETCHAR(chr);
            return_value := chr;
         when 'SYS.NUMBER' THEN
            res := data.GETNUMBER(num);
            return_value := num;
         when 'SYS.DATE' THEN
            res := data.GETDATE(dat);
            return_value := dat;
         else
            return_value := data.gettypename()||' ????';
      end case;
   end if;
   return return_value;
end;
/
