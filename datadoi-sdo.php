<?php
$id = (int) $_GET['id'];
if ($id=='100001'){
    header('Location: '.'http://www.marine-geo.org/tools/maps_grids.php');
} elseif ($id=='900001') {
    header ("Location: http://www.marine-geo.org/tools/search/Document_Accept.php?url_uid=1464&client=DataLink");
} else {
    $service = "http://{$_SERVER['HTTP_HOST']}/metadata/doi/{$id}";
    $headers = get_headers($service, 1);
    if ($headers[0] == 'HTTP/1.1 200 OK') {
        $xslfile = "http://{$_SERVER['HTTP_HOST']}/doi/dataciteToHTMLwithSDO.xsl";
        $xslt = new XSLTProcessor();
        $xslt->importStylesheet(new SimpleXMLElement(file_get_contents($xslfile)));
        $content = file_get_contents($service);
        echo $xslt->transformToXml(new SimpleXMLElement($content));
    } else {
        echo "Invalid DOI, please try again.\n";
    }
}
