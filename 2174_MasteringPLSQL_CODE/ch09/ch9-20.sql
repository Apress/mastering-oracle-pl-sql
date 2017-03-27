drop procedure temp_from_zip
/
create or replace function temp_from_zip( p_zip in varchar2)
return varchar2
as 
    l_soap_envelope varchar2(4000);
    l_http_request  utl_http.req;
    l_http_response utl_http.resp;
    l_piece         utl_http.html_pieces;
    l_response      varchar2(4000);
    l_xml           xmltype;
begin
    --
    -- Create a SOAP envelope containing the supplied ZIP parameter
    --
    l_soap_envelope := '<?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <SOAP-ENV:Envelope 
            xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"  
            xmlns:tns="http://www.xmethods.net/sd/TemperatureService.wsdl" 
            xmlns:xsd="http://www.w3.org/1999/XMLSchema" 
            xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/" 
            xmlns:xsi="http://www.w3.org/1999/XMLSchema-instance" 
            xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/">
            <SOAP-ENV:Body>
<mns:getTemp xmlns:mns="urn:xmethods-Temperature" 
 SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
                    <zipcode xsi:type="xsd:string">';
    l_soap_envelope := l_soap_envelope || p_zip;
    l_soap_envelope := l_soap_envelope || '</zipcode></mns:getTemp>
                        </SOAP-ENV:Body>
                        </SOAP-ENV:Envelope>';
    
    --
    -- Start a new request to the target SOAP server, and POSTing our request
    --
    l_http_request := utl_http.begin_request( 
        url => 'http://services.xmethods.net:80/soap/servlet/rpcrouter',
        method => 'POST' );
    utl_http.set_header(l_http_request, 'Content-Type', 'text/xml');
    utl_http.set_header(l_http_request, 'Content-Length', length(l_soap_envelope));
    utl_http.set_header(l_http_request, 'SOAPAction', 'getTempRequest');

    --
    -- Write the envelope as part of the request
    --
    utl_http.write_text(l_http_request, l_soap_envelope);

    --
    -- Immediately get the response from our request
    --
    l_http_response := utl_http.get_response(l_http_request);
    utl_http.read_text( l_http_response, l_response );
    utl_http.end_response(l_http_response);
    
    --
    -- Parse the response into a variable of XMLType and then
    -- extract just the return value using XPath syntax
    --
    l_xml := xmltype.createxml( l_response );
    return l_xml.extract('//return/child::text()').getStringVal();
end;
/
