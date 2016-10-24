CREATE OR REPLACE  PACKAGE BODY "NOTIFICATION"  as

procedure send_email (instance_name_in varchar2, msgs_in msgs,
                      subject_in varchar2,
                      recip recipients) is

sender constant varchar2(60) := 'dba1@foo.com';

smtp_server constant varchar2(255)  := 'SERVER100';
local_domain constant varchar2(255) := 'foo.com';

lvDate varchar2(30) := to_char(sysdate,'mm/dd/yyyy hh24:mi');
lvBody varchar2(32000);
c utl_smtp.connection;

recipient_list varchar2(1000) := sender;
-- local procedure to reduce redundancy
procedure write_header (name in varchar2, header in varchar2)
is
   begin
      utl_smtp.write_data(c, name || ': ' || header || utl_tcp.CRLF);
   end;

begin

   for i in 1 .. recip.count loop
	recipient_list = ','||recip(i);
   end loop;

   -- Open SMTP connection
   c := utl_smtp.open_connection(smtp_server);

   -- Perform initial handshaking with the SMTP server after connecting
   utl_smtp.helo(c, local_domain );
   -- Initiate a mail transacation
   utl_smtp.mail(c, sender);
   -- Specify the recipients
   utl_smtp.rcpt(c, sender);
   for i in 1 .. recip.count loop
	utl_smtp.rcpt(c, recip(i));
   end loop;
   -- Send the data command to the SMTP server
   utl_smtp.open_data(c);
   -- Write the header part of the email body
   write_header('Date',lvDate);
   write_header('From',sender);
   write_header('Subject',instance_name_in||' '||subject_in);
   write_header('To',recipient_list);
   write_header('Content-Type', 'text/html;');

   -- format the message body in HTML
   lvbody := '<html><head><style type="text/css">
              BODY, P, li, {font-family: courier-new,courier; font-size : 8pt;}
               </style></head><body><p>';

   -- the body of the email consists of the input message array
   for i in 1.. msgs_in.last loop
	 lvbody := lvbody||'<br>'||
            replace(msgs_in(i),chr(10),'<br>');
   end loop;

   lvbody := lvbody||'</body></html>';
   -- write less than 1000 characters at a time
   for x in 1 .. (length(lvbody)/800 + 1) loop
      utl_smtp.write_data(c, utl_tcp.CRLF ||
            substr(lvBody,(x-1)*800 +1,800));
    end loop;

   -- end the email message
   utl_smtp.close_data(c);
   
   -- disconnect from the smtp server
   utl_smtp.quit(c);

exception
  when others then
      utl_smtp.quit(c);
      raise;
end;

procedure save_in_db(instance_in varchar2, msgs_in msgs,
                     subject_in varchar2, result_in number) is
-- this program saves messages to a database table
-- it assumes that each message passed in begins with a string
-- that evaluates to a date in a specific format
run_time date;
begin
   forall i in 1.. msgs_in.last
      
      insert into alerts (event_date, instance_name,
              event_type, result, result_text)
      values (to_date(substr(msgs_in(i),1,24),
         'Dy Mon dd hh24:mi:ss yyyy'),
          instance_in,subject_in,
          result_in,msgs_in(i));
  
end;


procedure notify  (instance_name_in in varchar2, msgs_in in msgs,
    		       subject_in in varchar2 default null,
                   result_in in number default null,
	             email_p in boolean, db_p in boolean,
                   recip recipients default null) is
begin
-- send email
if email_p = true then
    send_email (instance_name_in, msgs_in,
                subject_in, recip);
end if;

if db_p = true then
    save_in_db (  instance_name_in, msgs_in,
                  subject_in, result_in);
end if;
end;

end;
/