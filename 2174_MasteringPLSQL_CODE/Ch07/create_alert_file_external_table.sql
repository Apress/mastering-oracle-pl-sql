Create or replace directory alert_dir
as 'c:\oracle\admin\rep9\bdump';

CREATE TABLE "ALERT_FILE_EXT"
 (    "MSG_LINE" VARCHAR2(1000)
 )
 ORGANIZATION EXTERNAL
  ( TYPE ORACLE_LOADER
    DEFAULT DIRECTORY "ALERT_DIR"
    ACCESS PARAMETERS
    ( RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
  nobadfile nologfile nodiscardfile
  skip 0
  READSIZE 1048576
  FIELDS LDRTRIM
  REJECT ROWS WITH ALL NULL FIELDS
  (
    MSG_LINE (1:1000) CHAR(1000)
  )
    )
    LOCATION
     ( 'alert_rep9.log'
     )
  )
 REJECT LIMIT UNLIMITED
/
