<?php

/**
 * PHP Script that read the xml files in the ../metadata/doi directory,
 * runs some tests to identify their source system, and for metadata not from 
 * MGDS (or CSDMS or UTIG), transforms the DataCite XML to ISO 19139 and writes
 * the metadata to the watch directory at /metadata/iso/{source}.  Currently
 * these are all from ECL, but expect to see USAP files there in the future;
 * will have to add additional tests to identify USAP metadata.
 * S. M. Richard 2018-01-29
 * framework based on xml-sitemap.php from  Joost de Valk, joost@yoast.com
 */

require './configxform.php';

// Get the keys so we can check quickly
$replace_files = array_keys( $replace );

$ignore = array_merge( $ignore, array( '.', '..', 'config.php', 'xml-sitemap.php' ) );

function parse_dir( $dir, $url ) {
	global $ignore, $filetypes, $replace, $chfreq, $prio;
	echo $dir . '<p>' . $url . '</p>';
	// set up the transform 
	$xslfile = "http://{$_SERVER['HTTP_HOST']}/doi/DataciteToISO19139v3.2.xslt";
	$xslt = new XSLTProcessor();
	$xslt->importStylesheet(new SimpleXMLElement(file_get_contents($xslfile)));
	
	$handle = opendir( $dir );
	$count = 0;
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

			$service = "http://{$_SERVER['HTTP_HOST']}/metadata/doi/{$file}";
			//echo $service . "\r\n";
			$headers = get_headers($service, 1);
			if ($headers[0] == 'HTTP/1.1 200 OK')  {

				$content = file_get_contents($service);
				//echo 'content length ' . strlen($content). "\r\n";
				//test to see if its an MGDS file, don't process those
				$test1 = strpos($content, 'Scheme="MGDS"');
				$test2 = strpos($content, 'Scheme="CSDMS"');
				$test3 = strpos($content, 'Scheme="UTIG"');
				$test4 = strpos($content, 'Scheme="ECL"');
				$test5 = strpos($content, 'Scheme="EarthChem"');
				$test6 = strpos($content, 'alternateIdentifierType="URL">http://www.earthchem.org/library');
				$test7 = strpos($content, 'alternateIdentifierType="MGDS"');
				$test8 = strlen($file) != 6;   //various test files have additional suffix strings

				if (($test1 or $test2 or $test3 or $test7 or $test8) === false)  {
					// not an mgds record
					//echo $content
					$newxml = $xslt->transformToXml(new SimpleXMLElement($content));
					//echo $newxml;
					if (($test4 or $test5 or $test6) === true) {
						$my_file = '../metadata/iso/test/' . $file . 'iso.xml';
					} else {
						
						$my_file = '../metadata/iso/testfail/' . $file . 'iso.xml';
					}
					$fhandle = fopen($my_file, 'w') or die('Cannot open file:  '.$my_file); 
					echo 'writing ' . $my_file ;
					echo '<p>';
					fwrite($fhandle, $newxml);
					fclose($fhandle);
					$count = $count + 1;
				}
			} 
		}
	}
	closedir( $handle );
	echo $count . ' files written';
	echo '<p>';
	}
?>

<?php
echo 'lets get started <p>';
parse_dir( SITEMAP_DIR, SITEMAP_DIR_URL );

echo 'all done'
?>

