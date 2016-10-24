conn scott/tiger
-- trigger raises errors for session user SCOTT
update user_info
  set image_url = 'http://funnypictures.com/img/chewbacca.lg.jpg'
  where username = 'BLAKE';

-- support procedure for notifications by email
create or replace
PROCEDURE send_mail (
      p_to        IN   VARCHAR2,
      p_from      IN   VARCHAR2 default 'DB Alert',
      p_cc        IN   VARCHAR2 DEFAULT NULL,
      p_bcc       IN   VARCHAR2 DEFAULT NULL,
      p_subject   IN   VARCHAR2 default 'DB Notification',
      p_message   IN   VARCHAR2
   )
   IS
      v_mailhost    VARCHAR2(30)        := '^2';
      v_mail_conn   utl_smtp.connection;
   BEGIN
      v_mail_conn := utl_smtp.open_connection (v_mailhost, 25);
      utl_smtp.helo (v_mail_conn, v_mailhost);
      utl_smtp.mail (v_mail_conn, p_from);
      utl_smtp.rcpt (v_mail_conn, p_to);
      utl_smtp.data (
         v_mail_conn,
         'bcc: ' ||
         p_bcc ||
         utl_tcp.crlf ||
         'Subject: ' ||
         p_subject ||
         utl_tcp.crlf ||
         'To: ' ||
         p_to ||
         utl_tcp.crlf ||
         'cc: ' ||
         p_cc ||
         utl_tcp.crlf ||
         p_message
      );
      utl_smtp.quit (v_mail_conn);
   EXCEPTION
      WHEN utl_smtp.transient_error OR utl_smtp.permanent_error
      THEN
         utl_smtp.quit (v_mail_conn);
         raise_application_error (
            -20000,
            'Failed to send mail due to the following error: ' || SQLERRM
         );
      WHEN OTHERS
      THEN
         utl_smtp.quit (v_mail_conn);
         raise_application_error (
            -20000,
            'Failed to send mail due to the following error: ' || SQLERRM
         );
   END;
/

CREATE OR REPLACE TRIGGER user_img_update_check
BEFORE UPDATE OF image_url
ON user_info
FOR EACH ROW
DECLARE
  v_notification_msg varchar2(1000);
BEGIN
  IF (sys_context('USERENV','SESSION_USER') != :new.username)
  then
    v_notification_msg := 'Unauthorized update to image URL from ' ||
                           sys_context('USERENV','SESSION_USER') ||
                           ' on ' || :new.username;
    send_mail(p_to=>'securityAdmin.yourCompany.com',
              p_message=>v_notification_msg);
    raise_application_error(-20001,'Unauthorized update!');
  END IF;
END;
/

drop table user_info;
