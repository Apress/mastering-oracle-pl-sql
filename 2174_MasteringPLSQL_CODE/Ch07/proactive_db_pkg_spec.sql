create or replace
package proactive
is
/**
* ========================================================================
* Project:         Database monitoring
* Description:     This is the package for procedures the proactivly
*                  monitor the database. If there is a problem then we can
*                  email a notification and or save message in database
* DB impact:       minimal
* Commit inside:   no
* Rollback inside: no
* ------------------------------------------------------------------------
*/ 
procedure checkStatusOfLastBackup (p_instance_name_in in varchar2);
procedure checkArchiveDestination (p_instance_name_in in varchar2);
procedure checkFreeSpace (p_instance_name_in in varchar2);
end;
/