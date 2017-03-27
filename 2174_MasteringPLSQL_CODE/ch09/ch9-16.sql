create or replace procedure investment_modify
as
    l_count number := 0;
begin
    htp.htmlOpen;
    htp.bodyOpen;
    --
    -- Open an HTML form which will POST to our main reporting procedure
    --
    htp.formOpen( curl => 'investment_rpt', cmethod => 'POST' );

    htp.tableOpen;
    --
    -- Generate a text field and label for each column in the table
    --
    htp.tableRowOpen;
    htp.tableData( calign => 'RIGHT', cvalue => 'Ticker:');
    htp.tableData( calign => 'LEFT',  
                    cvalue => htf.formText( cname => 'p_ticker' ));
    htp.tableRowClose;

    htp.tableRowOpen;
    htp.tableData( calign => 'RIGHT', cvalue => 'Name:');
    htp.tableData( calign => 'LEFT',  cvalue => htf.formText( cname => 'p_name' ));
    htp.tableRowClose;

    htp.tableRowOpen;
    htp.tableData( calign => 'RIGHT', cvalue => 'Type:');
    htp.tableData( calign => 'LEFT',  cvalue => htf.formText( cname => 'p_type' ));
    htp.tableRowClose;

    --
    -- Generate and HTML form submission button
    --
    htp.tableRowOpen;
    htp.tableData( calign      => 'RIGHT',
                   cattributes => 'colspan="2"',
                   cvalue      => htf.formSubmit(cvalue => 'Submit' ));
    htp.tableRowClose;

    htp.formClose;
    htp.bodyClose;
    htp.htmlClose;
end;
/
