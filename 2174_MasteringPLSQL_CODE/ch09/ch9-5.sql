create table web_log(
    log_date     date,
    ip_address   varchar2(255),
    user_agent   varchar2(4000),
    script_name  varchar2(4000),
    path_info    varchar2(4000),
    http_referer varchar2(4000))
/

create or replace procedure log_it
as
begin
    insert into web_log(
        log_date,
        ip_address,
        user_agent,
        script_name,
        path_info,
        http_referer )
    values(
        sysdate,
        owa_util.get_cgi_env( 'REMOTE_ADDR' ),
        owa_util.get_cgi_env( 'HTTP_USER_AGENT' ),
        owa_util.get_cgi_env( 'SCRIPT_NAME' ),
        owa_util.get_cgi_env( 'PATH_INFO' ),
        owa_util.get_cgi_env( 'HTTP_REFERER' ) );
end;
/


