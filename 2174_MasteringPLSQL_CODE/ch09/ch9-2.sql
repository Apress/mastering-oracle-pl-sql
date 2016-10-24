set serveroutput on
exec owainit;

begin
     htp.p('Ohio State');
     htp.p('Buckeyes');
 end;
/

exec owa_util.showpage;
