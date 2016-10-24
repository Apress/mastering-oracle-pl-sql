drop table debugTab
/

create table debugTab(
  userid           varchar2(30),
  dir              varchar2(32),
  filename         varchar2(1024),
  modules          varchar2(4000),
  show_date        varchar2(3),
  date_format      varchar2(255),
  name_length      number,
  show_session_id  varchar2(3),
  --
  -- Constraints
  --
  constraint debugtab_pk 
    primary key ( userid, filename ),
  constraint debugtab_show_date_ck 
    check ( show_date in ( 'YES', 'NO' ) ),
  constraint debugtab_show_session_id_ck 
    check ( show_session_id in ( 'YES', 'NO' ) )
)
/

create or replace
trigger biu_fer_debugtab
before insert or update on debugtab for each row
begin

  :new.modules := upper( :new.modules );
  :new.show_date := upper( :new.show_date );
  :new.show_session_id := upper( :new.show_session_id );
  :new.userid := upper( :new.userid );

  declare
    l_date varchar2(100);
  begin
    l_date := to_char( sysdate, :new.date_format );
  exception
    when others then
      raise_application_error( 
        -20001, 
        'Invalid date format "' ||
        :new.date_format || '"' );
  end;

  declare
    l_handle utl_file.file_type;
    --l_file varchar2(32767);
    --l_location varchar2(23767);
  begin
    --l_file := substr( :new.filename,
                      --instr( replace( :new.filename, '\', '/' ),
                                                     --'/', -1 )+1 );
    --l_location := substr( :new.filename,
                          --1,
                          --instr( replace( :new.filename, '\', '/' ),
                                                         --'/', -1 )-1 );
    l_handle := utl_file.fopen(
                  location => :new.dir,
                  filename => :new.filename,
                  open_mode => 'a',
                  max_linesize => 32767 );
    utl_file.fclose( l_handle );
  exception
    when others then
      raise_application_error(
        -20001,
        'Cannot open debug dir/file ' ||
        :new.dir || '/' ||
        :new.filename );
  end;

end;
/


