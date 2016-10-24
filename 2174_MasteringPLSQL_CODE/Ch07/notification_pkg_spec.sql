CREATE OR REPLACE  PACKAGE "NOTIFICATION"  is
/**
* ========================================================================<br/>
* Project:         Database monitoring<br/>
* Description:     Send email message andor save message in database<br/>
* DB impact:       minimal<br/>
* Commit inside:   the save_in_db procedure commits<br/>
* Rollback inside: no<br/>
* ------------------------------------------------------------------------<br/>
*/

   type msgs is table of varchar2(4000) index by binary_integer;
   type recipients is table of varchar2(255);

   procedure notify (instance_name_in in varchar2, msgs_in in msgs,
                     subject_in in varchar2 default null,
                     result_in in number default null,
                     email_p in boolean, db_p in boolean,
                     recip recipients default null);
end;
/