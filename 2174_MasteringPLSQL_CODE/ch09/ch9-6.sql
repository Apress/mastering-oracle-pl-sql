exec owainit;

exec log_it;

column ip_address   format a15
column user_agent   format a10 word_wrapped
column script_name  format a10 word_wrapped
column path_info    format a10 word_wrapped
column http_referer format a10 word_wrapped
set linesize 120
select * from web_log;
