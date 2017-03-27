create or replace procedure get_file( p_id in number )
as
begin
    for c1 in (select mime_type, blob_content, name
                 from mydocs
                where id = p_id) loop
        --
        -- Setup the HTTP headers
        -- 
        owa_util.mime_header( c1.mime_type, FALSE );
        htp.p('Content-length: ' || dbms_lob.getlength( c1.blob_content ));
        htp.p('Content-Disposition: inline ' );
        owa_util.http_header_close;
        -- Then give mod_plsql the BLOB content
        wpg_docload.download_file( c1.blob_content );
        --
        exit;
    end loop;
end;
/
