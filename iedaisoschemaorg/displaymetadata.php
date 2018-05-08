<?php
/**
 * PHP handler that takes requests to http://{thishost}/metadata/nnnnnnn by the
 * .htaccess file in the htdocs/doi directory where this php is deployed. The
 * ID token ('nnnnnnn') from the DOI is passed as an argument; this scripts gets the 
 * DataCite xml file from the metadata/doi directory and uses the dataciteToHTMLwithSDO.xsl 
 * transdform to convert it to html for display.   The transform also embeds a Schema.org 
 * JSON-LD script in the <head> section of the html for use by schema.org aware search engines.
 
 * S. M. Richard 2018-01-29
 * smr 2018-03-2018 change file extension on xml transform from xsl to xslt for consistency
 *  
 */

$file= (string) $_GET['file'];
//echo "the file {$file}";
//echo "<p>";

// first handle output format request if have file extension

if (strpos($file, ".") === false) {
	$extension = '';
	$id = $file;
} else {
	$extension = substr($file, strpos($file, ".") + 1);
	$id = substr($file, 0, strpos($file, '.'));
}

$slen = strlen($extension);
//echo "file extension {$extension}; file {$file}; len {$slen}; id {$id} <p>";

// have to figure out which partner this ID goes with, based on number range

if (substr($id,0,2)== '10' or substr($id,0,2)=='11') {
	//ecl id range
	$xmlname= "iso/ecl/" . $id .  "iso.xml";
//	echo "ecl file name $xmlname <p>";	
	$service = "http://{$_SERVER['HTTP_HOST']}/metadata/{$xmlname}";
	$headers = get_headers($service, 1);
	if ($headers[0] == 'HTTP/1.1 200 OK') {
		$content = file_get_contents($service);
		$xslfile = "http://{$_SERVER['HTTP_HOST']}/doi/test/isosdo/ISO19139ToHTMLwMap.xsl";
		
		if (substr($extension,0,3) == 'htm' or strlen($extension) == 0) { 
			//convert ISO xml to html with schema.org
			
			$xslt = new XSLTProcessor();
			$dom = new DomDocument('1.0','utf-8');
			/* $xslt->importStylesheet(new SimpleXMLElement(file_get_contents($xslfile))); */

			$dom->load($xslfile);
			$xslt->importStyleSheet($dom);
			$xslt->setParameter('gmd','isopath',$service);
			//echo $service;
			$dom->loadXML($content);
			echo $xslt->transformToXML($dom);
			//echo $xslt->transformToXml(new SimpleXMLElement($content));
	
		} elseif (substr($extension,0,3) == 'xml') {
			//just echo the ISO xml
			header( 'Content-Type: application/xml' );
			echo $content;
		}
	} else {
		echo "Invalid DOI, please try again.<p>";
	}
	
} elseif (substr($id,0,1) == '3') {
	//mgdl; ISO file names are the part after '3' and following zeros
	if (substr($id,0,4)=='3000') {
		$xmlname= "iso/mgdl/" . substr($id,4,2) . "_iso.xml";
	} elseif (substr($id,0,3)=='300') {
		$xmlname= "iso/mgdl/" . substr($id,3,3) . "_iso.xml";
	} elseif (substr($id,0,2)=='30') {
		$xmlname= "iso/mgdl/" . substr($id,2,4) . "_iso.xml";
	} elseif (substr($id,0,1)=='3') {
		$xmlname= "iso/mgdl/" . substr($id,1,5) . "_iso.xml";
	}
	//echo "mgdl file name $xmlname <p>";	
	$service = "http://{$_SERVER['HTTP_HOST']}/metadata/{$xmlname}";

	$headers = get_headers($service, 1);
	if ($headers[0] == 'HTTP/1.1 200 OK') {
		$content = file_get_contents($service);
		$xslfile = "http://{$_SERVER['HTTP_HOST']}/doi/test/isosdo/ISO19139ToHTMLwMap.xsl";
		
		if (substr($extension,0,3) == 'htm' or strlen($extension) == 0) { 
			//convert ISO xml to html with schema.org
			
			$xslt = new XSLTProcessor();
			$xslt->importStylesheet(new SimpleXMLElement(file_get_contents($xslfile)));
			$xslt->setParameter('gmd','isopath',$service);
			echo $xslt->transformToXml(new SimpleXMLElement($content));
	
		} elseif (substr($extension,0,3) == 'xml') {
			//just echo the ISO xml
			header( 'Content-Type: application/xml' );
			echo $content;
		}
	} else {
		echo "Invalid DOI, please try again.<p>";
	}
	
} elseif (substr($id, 0, 2) == '50') {
	//ASP at UT; no records for these in  ISO folder, use the dataCite record
	$service = "http://{$_SERVER['HTTP_HOST']}/metadata/doi/{$id}";
	$headers = get_headers($service, 1);
	if ($headers[0] == 'HTTP/1.1 200 OK') {
		$xslfile = "http://{$_SERVER['HTTP_HOST']}/doi/DataciteToISO19139v3.2.xslt";
		$xslt = new XSLTProcessor();
		$xslt->importStylesheet(new SimpleXMLElement(file_get_contents($xslfile)));
		$content = file_get_contents($service);
		$isoxml = $xslt->transformToXml(new SimpleXMLElement($content));
//		echo $xslt->transformToXml(new SimpleXMLElement($content));
	
		if (substr($extension,0,3) == 'htm' or strlen($extension) == 0) { 
			//convert ISO xml to html with schema.org
			$xslfile = "http://{$_SERVER['HTTP_HOST']}/doi/test/isosdo/ISO19139ToHTMLwMap.xsl";
			$xslt = new XSLTProcessor();
			$xslt->importStylesheet(new SimpleXMLElement(file_get_contents($xslfile)));
			$service = "http://{$_SERVER['HTTP_HOST']}/doi/test/isosdo/{$id}.xml";
			$xslt->setParameter('gmd','isopath',$service);
			echo $xslt->transformToXml(new SimpleXMLElement($isoxml));
		} elseif (substr($extension,0,3) == 'xml') {
			//just echo the ISO xml
			header( 'Content-Type: application/xml' );
			echo $isoxml;
		}
	} else {
		echo "Invalid DOI, please try again.<p>";
	}

} elseif (substr($id, 0, 2) == '60') {
	//USAP-DC id range
		
	$xmlname= "iso/usap/submission-id" . $id .  "iso.xml";
//	echo "ecl file name $xmlname <p>";	
	$service = "http://{$_SERVER['HTTP_HOST']}/metadata/{$xmlname}";
	$headers = get_headers($service, 1);
	if ($headers[0] == 'HTTP/1.1 200 OK') {
		$content = file_get_contents($service);
		$xslfile = "http://{$_SERVER['HTTP_HOST']}/doi/test/isosdo/ISO19139ToHTMLwMap.xsl";
		
		if (substr($extension,0,3) == 'htm' or strlen($extension) == 0) { 
			//convert ISO xml to html with schema.org
			
			$xslt = new XSLTProcessor();
			$xslt->importStylesheet(new SimpleXMLElement(file_get_contents($xslfile)));
			$xslt->setParameter('gmd','isopath',$service);
			echo $xslt->transformToXml(new SimpleXMLElement($content));
	
		} elseif (substr($extension,0,3) == 'xml') {
			//just echo the ISO xml
			header( 'Content-Type: application/xml' );
			echo $content;
		}
	} else {
		echo "Invalid DOI, please try again.<p>";
	}
	
}



/* if ($extension=='xml') {
	//return the ISO xml record
	
} elseif (substr($extension,0,3) == 'htm' or $file == '') {
	
} else {
	echo "unknown file extension $extension <p> Valid values are htm, html, or xml";
	
}


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
} */

