create or replace procedure my_doc_listing( p_name in varchar2 default null )
as
begin
    htp.htmlOpen;
    htp.bodyOpen;
    if p_name is not null then
        htp.bold('Document ' || p_name || ' successfully uploaded!');
    end if;
    htp.tableOpen;
    htp.tableRowOpen;
    htp.tableHeader('Name');
    htp.tableHeader('Size');
    htp.tableRowClose;
    --
    for c1 in (select id, name, doc_size
                 from mydocs
                order by name) loop
        htp.tableRowOpen;
        htp.tableData( c1.name );
        htp.tableData( c1.doc_size );
        htp.tableRowClose;
    end loop;
    --
    htp.tableClose;
    htp.anchor('upload_doc','Upload a new document');
    htp.bodyClose;
    htp.htmlClose;
end;
/
