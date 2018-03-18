<?php
/**
 * PHP handler that takes requests redirected from http://doi.org/10.1594/ieda/nnnnnnn by the
 * .htaccess file in the htdocs/doi directory where this php is deployed. The
 * ID token ('nnnnnnn') from the DOI is passed as an argument; this scripts gets the 
 * DataCite xml file from the metadata/doi directory and uses the dataciteToHTMLwithSDO.xsl 
 * transdform to convert it to html for display.   The transform also embeds a Schema.org 
 * JSON-LD script in the <head> section of the html for use by schema.org aware search engines.
 
 * S. M. Richard 2018-01-29
 * smr 2018-03-2018 change file extension on xml transform from xsl to xslt for consistency
 *  
 */
$id = (int) $_GET['id'];
if ($id=='100001'){
    header('Location: '.'http://www.marine-geo.org/tools/maps_grids.php');
} elseif ($id=='900001') {
    header ("Location: http://www.marine-geo.org/tools/search/Document_Accept.php?url_uid=1464&client=DataLink");
} else {
    $service = "http://{$_SERVER['HTTP_HOST']}/metadata/doi/{$id}";
    $headers = get_headers($service, 1);
    if ($headers[0] == 'HTTP/1.1 200 OK') {
        $xslfile = "http://{$_SERVER['HTTP_HOST']}/doi/dataciteToHTMLwithSDO.xslt";
        $xslt = new XSLTProcessor();
        $xslt->importStylesheet(new SimpleXMLElement(file_get_contents($xslfile)));
        $content = file_get_contents($service);
        echo $xslt->transformToXml(new SimpleXMLElement($content));
    } else {
        echo "Invalid DOI, please try again.\n";
    }
}
