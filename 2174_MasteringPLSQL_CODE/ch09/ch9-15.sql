create or replace procedure investment_rpt
as
    l_count number := 0;
begin
    htp.htmlOpen;
    htp.bodyOpen;
    htp.tableOpen;
    htp.tableRowOpen;
    htp.tableHeader('Ticker');
    htp.tableHeader('Name');
    htp.tableHeader('Type');
    htp.tableRowClose;
    --
-- Display information about each row in the my_investments table
--
    for c1 in (select ticker, name, type
                 from my_investments
                order by ticker) loop
        htp.tableRowOpen;
        htp.tableData( c1.ticker );
        htp.tableData( c1.name );
        htp.tableData( c1.type );
        htp.tableRowClose;
        l_count := l_count + 1;
    end loop;
    --
    htp.tableClose;
    htp.p( l_count || ' rows found');
    htp.bodyClose;
    htp.htmlClose;
end;
/
