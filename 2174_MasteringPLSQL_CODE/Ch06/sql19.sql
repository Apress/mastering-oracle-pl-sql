create table work_orders
(woid number,
 recipient varchar2(80),
 email_jobno number);

create or replace trigger
worknotbr before insert
on work_orders for each row
declare
jobno number;
begin
   dbms_job.submit(job  => jobno, what => 'email( job );');
   :new.email_jobNo:= jobno;
end;
/
procedure email (job in number)
is
lv_recipient work_orders.recipient%type;
begin 
          select recipient
          into   lv_recipient	  
          from   work_orders
	    where  email_jobNo = job;

	  send_email(lv_recipient);
end;
/



