CREATE OR REPLACE  PACKAGE "ALERT_FILE"  is
/**
* ========================================================================<br/>
* Project:         Alert file<br/>
* Description:     Monitor and manage the alert file<br/>
* DB impact:       reads exernal table<br/>
* Commit inside:   no<br/>
* Rollback inside: no<br/>
* ------------------------------------------------------------------------<br/>
*/
      procedure monitor_alert_file;
end;
/