<?php

/**
 * This script pulls a file from the htdocs/metadata/doi directory and tries to transform to
    ISO 19139 xml, assuming that the file name provided by the input argument ('id') is_a
	and xml file in that directory that conforms to the DataCite v2, v3, or v4 xml schema.
	
	precondition: the xslt to do the transform must be located in the htdocs/doi directory on 
	the host from which this php is running
	Postcondition: outpufile is written to htdocs/metadata/iso/test.file.xml on the host
	from which this php is running. 
	
	This is a simpel test script to demonstrate calling and xml transformation using
	the php XSLTProcessor class.
	
	SMR 2018-02-04
 */


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

