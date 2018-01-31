<?php

/**
 * XML Sitemap PHP Script
 * For more info, see: http://yoast.com/xml-sitemap-php-script/
 * Copyright (C), 2011 - 2012 - Joost de Valk, joost@yoast.com
 */

require './configxform.php';

// Get the keys so we can check quickly
$replace_files = array_keys( $replace );

// Sent the correct header so browsers display properly, with or without XSL.
header( 'Content-Type: application/xml' );

echo '<?xml version="1.0" encoding="utf-8"?>' . "\n";

$ignore = array_merge( $ignore, array( '.', '..', 'config.php', 'xml-sitemap.php' ) );

if ( isset( $xsl ) && !empty( $xsl ) )
	echo '<?xml-stylesheet type="text/xsl" href="' . SITEMAP_DIR_URL . $xsl . '"?>' . "\n";

function parse_dir( $dir, $url ) {
	global $ignore, $filetypes, $replace, $chfreq, $prio;
	
	// set up the transform 
	$xslfile = "http://{$_SERVER['HTTP_HOST']}/doi/DataciteToISO19139v3.2.xslt";
	$xslt = new XSLTProcessor();
	$xslt->importStylesheet(new SimpleXMLElement(file_get_contents($xslfile)));
	
	$handle = opendir( $dir );
	while ( false !== ( $file = readdir( $handle ) ) ) {

		// Check if this file needs to be ignored, if so, skip it.
		if ( in_array( utf8_encode( $file ), $ignore ) )
			continue;

		if ( is_dir( $file ) ) {
			if ( defined( 'RECURSIVE' ) && RECURSIVE )
				parse_dir( $file, $url . $file . '/' );
		}

		// Check whether the file has one of the extensions allowed for this transform
		$fileinfo = pathinfo( $dir . $file );
		if ( in_array( $fileinfo['extension'], $filetypes ) ) {

			
			// do the transform
			//$id = (int) $_GET['id'];
			$service = "http://{$_SERVER['HTTP_HOST']}/metadata/doi/{$file}";
			echo $service
			$headers = get_headers($service, 1);
			if ($headers[0] == 'HTTP/1.1 200 OK') {

				$content = file_get_contents($service);
				
				//test to see if its an MGDS file, don't process those
				$test1 = strpos($content, 'Scheme="MGDS"');
				$test2 = strpos($content, 'Scheme="CSDMS"');
				$test3 = strpos($content, 'Scheme="UTIG"');
				$test4 = strpos($content, 'Scheme="ECL"');
				$test5 = strpos($content, 'Scheme="EarthChem"');
				$test6 = strpos($content, 'alternateIdentifierType="URL">http://www.earthchem.org/library');
				
				if (($test1 or test2 or test3) === false)  {
					// not an mgds record
					//echo $content
					$newxml = $xslt->transformToXml(new SimpleXMLElement($content));
					//echo $newxml;
					if (($test4 or test5 or test6) === true) {
						$my_file = '../metadata/iso/test/' . $file . 'iso.xml';
					} else {
						$my_file = '../metadata/iso/testfail/' . $file . 'iso.xml';
					}
					$handle = fopen($my_file, 'w') or die('Cannot open file:  '.$my_file); 
					echo $my_file;
					fwrite($handle, $newxml);
					fclose($my_file);
				}
			} 
		}
	closedir( $handle );
	}
}
?>

<?php
	parse_dir( SITEMAP_DIR, SITEMAP_DIR_URL );
?>

