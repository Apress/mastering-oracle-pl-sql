create or replace procedure owainit
as
    l_cgivar_name owa.vc_arr;
    l_cgivar_val  owa.vc_arr;
begin
    htp.init;
    l_cgivar_name(1) := 'REQUEST_PROTOCOL';
    l_cgivar_val(1)  := 'HTTP';
    owa.init_cgi_env(
        num_params => 1,
        param_name => l_cgivar_name,
        param_val  => l_cgivar_val );
end;
/
