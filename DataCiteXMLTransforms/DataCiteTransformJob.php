<?php
$id = (int) $_GET['id'];
$service = "http://{$_SERVER['HTTP_HOST']}/metadata/doi/{$id}";
$headers = get_headers($service, 1);
if ($headers[0] == 'HTTP/1.1 200 OK') {
	$xslfile = "http://{$_SERVER['HTTP_HOST']}/doi/DataciteToISO19139v3.2.xslt";
	$xslt = new XSLTProcessor();
	$xslt->importStylesheet(new SimpleXMLElement(file_get_contents($xslfile)));
	$content = file_get_contents($service);
	$newxml = $xslt->transformToXml(new SimpleXMLElement($content));
	echo $newxml;
	
	$my_file = '../metadata/iso/test/file.xml';
	$handle = fopen($my_file, 'w') or die('Cannot open file:  '.$my_file); //implicitly creates file
	fwrite($handle, $newxml);
	fclose($my_file);
	
} else {
	echo "Invalid DOI, please try again.\n";
}

?>

