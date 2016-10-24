create or replace procedure upload_doc
as
begin
    htp.htmlOpen;
    htp.bodyOpen;
    htp.formOpen(curl     => 'my_doc_listing', 
                 cmethod  => 'POST', 
                 cenctype => 'multipart/form-data'); 
    -- No procedure provided in toolkit for file 
    htp.p('<input type="file" name="p_name">');      htp.formSubmit; 
    htp.formClose; 
    htp.anchor('my_doc_listing','Document listing');
    htp.bodyClose;
    htp.htmlClose;
end;
/
