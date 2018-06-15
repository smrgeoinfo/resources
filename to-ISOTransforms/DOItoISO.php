<?php

/**
 * PHP Script that read the xml files in the ../metadata/doi directory,
 * runs some tests to identify their source system, 
 * transforms the DataCite XML to ISO 19139 and 
 * writes the metadata to the watch directory at /metadata/iso/{source}.  
 * Will have to add additional tests to identify partner system source
 * and handle appropriately.
 * Original by S. M. Richard 2018-01-29, 
 *  based on xml-sitemap.php from  Joost de Valk, joost@yoast.com
 *
 * 2018-06-02 SMR update to put configuration variable assignment inside the
 *    script instead of an import.  Checks for UTIG, ECL, MGDS, USAP and CSDMS
 *	 resources and puts output ISO metadata in separate subfolders for each.
 * 2018-06/02 NOTE to use this script, you will need to check the file inspection 
 *    tests, source locations and target locations for consistency with current IEDA 
 *	 DataCite xml encoding and get.iedadata.org site configuration.
 */
 
 /*
 * The starting point directory to check. LOcation is relative to the location 
 *  of the php code on the server */
$DirectoryToScan = './metadata/doi/';
/*


 * Relative path at which output files will be written. MUST have subdirectories
 *  /usap
 *  /mgdl
 *  /ecl
 *  /csdms
 *  /utig  */
$WriteToDirectory = './metadata/iso/';
 
 // Whether or not the script should recursively drill in to subfolders.
$RECURSIVE = false;

// The file types, you can just add them on, so 'pdf', 'php' would work
$filetypes = array( '' );

// Ignore array, all files in this array will be: ignored!
$ignore =  array( '.', '..', 'config.php', 'xml-sitemap.php' );

function parse_dir( $dir, $target ) {
	global $ignore, $filetypes;
	echo $dir . '<p>' ;
	// set up the transform 
	// the xslt source is at https://raw.githubusercontent.com/usgin/metadataTransforms/master/dataciteToISO19139v3.2.xslt
	// It could be accessed from there, but here its accessed from a /metadata directory
	// on the server that's running this script
	$xslfile = "http://{$_SERVER['HTTP_HOST']}/metadata/DataciteToISO19139v3.2.xslt";
	
	#echo "xslfile: ".$xslfile;
	$xslt = new XSLTProcessor();
	$xslt->importStylesheet(new SimpleXMLElement(file_get_contents($xslfile)));
	
	$handle = opendir( $dir );
	$count = 0;
	while ( false !== ( $file = readdir( $handle ) ) ) {

		// Check if this file needs to be ignored, if so, skip it.
		if ( in_array( utf8_encode( $file ), $ignore ) )
			continue;

		if ( is_dir( $file ) ) {
			if ($RECURSIVE)
				parse_dir( $file, $url . $file . '/' );
		}

		// Check whether the file has one of the extensions allowed for this transform
		$fileinfo = pathinfo( $dir . $file );
		
		#echo $dir.$file."<p/>";
		
		if (strpos($file, '.') == FALSE){
			$theExtension='';
		} else {
			$theExtension=$fileinfo['extension'];
		}
		
		if ( in_array( $theExtension, $filetypes ) ) {

			// do the transform
			// see line 24, $DirectoryToScan (passed into function as $dir)
			// for the local path on the server that this URL uses
			// TBD-- we already read the file, use that as the source for transform; this
			// http access is a relict of the original code I copied to build this
			$service = "http://{$_SERVER['HTTP_HOST']}/metadata/doi/{$file}";
			echo $service . "<p/>";
			$headers = get_headers($service, 1);
			#echo $headers[0]."<p/>";
			if ($headers[0] == 'HTTP/1.1 200 OK')  {

				$content = file_get_contents($service);
				//echo 'content length ' . strlen($content). "\r\n";
				//test to see what source 
				$test1 = strpos($content, 'alternateIdentifierType="URL">https://csdms.colorado.edu') != false;  #CSDMS model
				$test2 = strpos($content, 'alternateIdentifierType="MGDS">') != false;  # MGDS
				$test3 = strpos($content, 'alternateIdentifierType="URL">http://www-udc.ig.utexas.edu')!= false;  #UTIG
				$test4 = strpos($content, 'landing page">http://www.usap-dc.org') != false;  #USAP
				$test5 = strpos($content, 'alternateIdentifierType="URL">http://www.earthchem.org/library')!= false; #ecl
				$test6 = strpos($content, 'alternateIdentifierType="URL">http://www.marine-geo.org')!= false; #MGDS
				$test8 = strlen($file) != 6;

				// these tests and processing source and location will need to be updated for current
				//  DataCite encoding and file locations.
				if (($test1 or $test2 or $test3 or $test4 or $test5 or $test6) === true)  {
					//echo $content
					$newxml = $xslt->transformToXml(new SimpleXMLElement($content));
					//echo $newxml;
					if ($test1) {
						$my_file = $target.'csdms/' . $file . 'iso.xml';
					} elseif ($test2 or $test6) {
						$my_file = $target.'mgdl/' . $file . 'iso.xml';
					} elseif ($test3) {
						$my_file = $target.'utig/' . $file . 'iso.xml';
					} elseif ($test4) {
						$my_file = $target.'usap/' . $file . 'iso.xml';
					} elseif ($test5) {
						$my_file = $target.'ecl/' . $file . 'iso.xml';
					} else {
						$thedir = $target.'testfail/';
						if (!is_dir($thedir)){
							echo "mkdir: ".$thedir."<br/>";
							mkdir($thedir);
						}
						$my_file = $thedir . $file . 'iso.xml';
					}
					#$my_file="test.xml";
					echo "file to write: ".$my_file."<p/>";
					$fhandle = fopen($my_file, 'w') or die('Cannot open file:  '.$my_file); 
					echo 'writing ' . $my_file ;
					echo '<p>';
					if ($newxml) {
					    fwrite($fhandle, $newxml);
					} else {
						fwrite($fhandle, 'transform failure');
					}
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

parse_dir( $DirectoryToScan, $WriteToDirectory );

echo 'all done'
?>

