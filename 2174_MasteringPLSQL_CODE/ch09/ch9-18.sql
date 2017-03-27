set define off
create or replace procedure investment_rpt(
    p_ticker  in varchar2 default null,
    p_name    in varchar2 default null,
    p_type    in varchar2 default null,
    p_action  in varchar2 default 'DISPLAY' )
as
    l_count number := 0;
begin
    if p_action = 'INSERT' then
        insert into my_investments( ticker, name, type )
        values( p_ticker, p_name, p_type );
        commit;
    elsif p_action = 'UPDATE' then
        update my_investments
           set name = p_name,
               type = p_type
         where ticker = p_ticker;
        commit;
    end if;

    htp.htmlOpen;
    htp.bodyOpen;
    htp.tableOpen;
    htp.tableRowOpen;
    htp.tableHeader('Ticker');
    htp.tableHeader('Name');
    htp.tableHeader('Type');
    htp.tableRowClose;
    --
    for c1 in (select ticker, name, type
                 from my_investments
                order by ticker) loop
        htp.tableRowOpen;
        htp.tableData( 
            htf.anchor( 
              curl => 'investment_modify?p_action=UPDATE&p_ticker=' || c1.ticker,
              ctext => c1.ticker) );
        htp.tableData( c1.name );
        htp.tableData( c1.type );
        htp.tableRowClose;
        l_count := l_count + 1;
    end loop;
    --
    htp.tableClose;
    htp.p( l_count || ' rows found'); 
    htp.br;
    htp.anchor( curl => 'investment_modify?p_action=INSERT', 
                ctext => 'Create New' );
    htp.bodyClose;
    htp.htmlClose;
end;
/

create or replace procedure investment_modify(
    p_ticker  in varchar2 default null,
    p_action  in varchar2 default 'INSERT' )
as
    l_count number := 0;  
    l_row   my_investments%rowtype;
begin
    --
    -- If the action is update, query the values to be
    -- updated from the table
    --
    if p_action = 'UPDATE' then 
        select * into l_row
          from my_investments
         where ticker = p_ticker;
    end if;
    htp.htmlOpen;
    htp.bodyOpen;

    --
    -- Open an HTML form which will POST to our main reporting procedure
    --
    htp.formOpen( curl => 'investment_rpt', cmethod => 'POST' );
    
    -- 
    -- Include a hidden field to indicate our action when POSTed
    --
    htp.formHidden ( cname=> 'p_action', cvalue=> p_action );

    htp.tableOpen;
    --
    -- Generate a text field and label for each column in the table
    --
    htp.tableRowOpen;
    htp.tableData( calign => 'RIGHT', cvalue => 'Ticker:');
    htp.tableData( 
        calign => 'LEFT',  
        cvalue => htf.formText( cname => 'p_ticker', 
                                cvalue => l_row.ticker ));
    htp.tableRowClose;

    htp.tableRowOpen;
    htp.tableData( calign => 'RIGHT', cvalue => 'Name:');
    htp.tableData( 
        calign => 'LEFT',  
        cvalue => htf.formText( cname => 'p_name', cvalue => l_row.name ));
    htp.tableRowClose;

    htp.tableRowOpen;
    htp.tableData( calign => 'RIGHT', cvalue => 'Type:');
    htp.tableData( 
        calign => 'LEFT',  
        cvalue => htf.formText( cname => 'p_type', cvalue => l_row.type ));
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
