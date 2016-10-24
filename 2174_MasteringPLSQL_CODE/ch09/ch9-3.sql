-- Example 1
begin
    htp.tableOpen;
    htp.tableRowOpen;
    htp.tableHeader( cvalue => 'TheHeader', calign => 'left' );
    htp.tableRowClose;
    htp.tableRowOpen;
    htp.tableData( cvalue => 'DataVal' );
    htp.tableRowClose;
    htp.tableClose;
end;
/
exec owa_util.showpage;

-- Example 2
declare
    l_str varchar2(32000);
begin
    l_str := '<TABLE>';
    l_str := l_str || '<TR>';
    l_str := l_str || '<TH ALIGN="left">TheHeader</TH>';
    l_str := l_str || '</TR>';
    l_str := l_str || '<TR>';
    l_str := l_str || '<TD>DataVal</TD>';
    l_str := l_str || '</TR>';
    l_str := l_str || '</TABLE>';
    htp.p( l_str );
end;
/
exec owa_util.showpage;

-- Example 3
begin
    htp.p('<TABLE><TR><TH ALIGN="left">TheHeader</TH></TR>');
    htp.p('<TR><TD>DataVal</TD></TR></TABLE>');
end;
/
exec owa_util.showpage;
