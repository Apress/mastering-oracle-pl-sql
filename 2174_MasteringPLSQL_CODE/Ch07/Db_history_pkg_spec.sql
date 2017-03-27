create or replace
package history
is
/**
* ========================================================================<
* Project:         Database monitoring
* Description:     Contains procedures that collect history of the database
* DB impact:       minimal
* Commit inside:   no
* Rollback inside: no
* ------------------------------------------------------------------------
*/
procedure databaseSize (p_instance_name_in in varchar2);
procedure databaseSessions (p_instance_name_in in varchar2);
procedure resourceLimit (p_instance_name_in in varchar2);
end;
/