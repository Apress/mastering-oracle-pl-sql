exec owainit;
begin
    owa_util.mime_header('text/html', FALSE);
    owa_cookie.send('NAME','Brutus.Buckeye',sysdate+1);
    owa_util.http_header_close;
    htp.p('Hello world');
end;
/
