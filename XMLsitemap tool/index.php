<?php

/**

 License:  This script is licensed under the Apache2.0
 
 * 2018-05/09 SM Richard to generate sitemaps and sitemapindex for IEDA partner systems.
 This page produces an xml sitemapindex file, with a processing directive in the 
 xml header to use xml-sitemap.xsl to display the index as a web page. 
 This PHP also generates a sitemap for each subdirectory in the /metadata/iso directory, 
 and these are indexed by the sitemap index. All sitemaps and the index are created in the same
 directory that contains this web page.
 
 repository: https://github.com/iedadata/resources/tree/master/XMLsitemap%20tool
 */


// The XSL file used for styling the sitemap output, make sure this path is relative to the root of the site.
$xsl = 'xml-sitemap.xsl';

// The Change Frequency for files
$chfreq = 'yearly';
 
// The Priority Frequency for files. Same for all files for IEDA
$prio = 1;

// Ignore array, files listed in this array will not be included in the sitemap.
$ignore =  array( '.', '..', 'config.php', 'iedasitemaps.php', 'imports' ) ;

/*
 * The directory to check.
 * Make sure the DIR ends ups in the Sitemap Dir URL below, otherwise the links to files will be broken!
 */
$dir = '../metadata/iso' ; // path relative to this web page on the server file system to get iso files
$webdir = 'metadata/iso'; //path relative to $baseurl that contains iso/ partner directories

// With trailing slash!
$baseurl = 'http://get.iedadata.org/' ;

// Set the correct header in the sitemapindex file so browsers display properly.
header( 'Content-Type: application/xml' );

echo '<?xml version="1.0" encoding="utf-8"?>' . "\n"; 

// insert xsl directive so browsers display as html
if ( isset( $xsl ) && !empty( $xsl ) )
	echo '<?xml-stylesheet type="text/xsl" href="' . $xsl . '"?>' . "\n"; 


function parse_dir( ) {
	global $ignore, $webdir, $chfreq, $prio, $dir, $baseurl, $xsl;
	
	$dirit = new DirectoryIterator($dir);
	foreach ($dirit as $fileinfo) {
		if ($fileinfo->isDir() && !$fileinfo->isDot()) {
			//echo $fileinfo->getFilename().'<br>';
			$thisdir = $fileinfo->getFilename();
			
			// Check if this dir needs to be ignored, if so, skip it.
			if ( in_array( utf8_encode( $thisdir ), $ignore ) )
				continue;
			
			
			
			$sitemapfilename = $thisdir.'_sitemap.xml';
			$sitemap = fopen($sitemapfilename, 'w') or die('Cannot open file:  '.$sitemapfilename); //implicitly creates file
			
			fwrite($sitemap, '<?xml version="1.0" encoding="utf-8"?>' . "\n");
			fwrite($sitemap, '<?xml-stylesheet type="text/xsl" href="' . $xsl . '"?>' . "\n");
			fwrite($sitemap, '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'. "\n");
			
			$localpath = $dir.'/'.$thisdir;
		//	echo 'this directory path: '.$localpath . '<br>';
				
			$filedirit = new DirectoryIterator($localpath);
			foreach ($filedirit as $fileinfo) {
				if ($fileinfo->isFile() && !$fileinfo->isDot()) {
				
				$file = $fileinfo->getFilename();
				
				// Check if this file needs to be ignored, if so, skip it.
				if ( in_array( utf8_encode( $file ), $ignore ) )
						continue;
					
					
				// have to extract the 6 digit token used by IEDA to mint DOIs
				// currently the various parnter subdirectories name the iso files differently, so requires some logic
				
				if ($thisdir == 'ecl'){
					//ecl token start with '1'
					// file names are NNNNNNiso.xml
				  $id = substr($file,0,6);
				} 
				elseif($thisdir == 'mgdl') {
					// mgdl names are like NNNNNN_iso.xml, where the leading part '3' and any 
					// following 0's are not included, e.g. 99_iso.xml, 9948_iso.xml
					$seed = strtok($file,'_');
					switch (strlen($seed)) {
						case 2:
							$id = '3000'.$seed;
							break;
						case 3:
							$id = '300'.$seed;
							break;
						case 4:
							$id = '30'.$seed;
							break;
						case 5:
							$id = '3'.$seed;
							break;
						case 6:
							$id = $seed;							
					}
				} 
				elseif($thisdir == 'usap' ) {
					// usap 6 digit tokes start with 6
					// file names like submission-id600009iso.xml
					
					$id = substr($file,13,6 );
					
				} else {
					// default is NNNNNN_xxx.xml, file name starts with 6 digit number, delimited
					//  by a '_' character
					$id = strtok($file,'_');
					
				}
				
				//echo $thisdir . '  ' . $id . '<p>' ;
				
				// Create a W3C valid date for use in the XML sitemap based on the file modification time
				if (filemtime( $localpath .'/'. $file )==FALSE) {
					$mod = date( 'c', filectime( $localpath . '/'. $file ) );
				} else {
					$mod = date( 'c', filemtime( $localpath . '/'. $file ) );
				}
				
				fwrite($sitemap,'<url>'. "\n");
				fwrite($sitemap,'<loc>'. $baseurl . $webdir . '/' .$id . '</loc>'. "\n");
				fwrite($sitemap,'<lastmod>'. $mod .'</lastmod>' . "\n");
				fwrite($sitemap,'<changefreq>' . $chfreq . '</changefreq>' . "\n");
				fwrite($sitemap,'<priority>' . $prio . '</priority>' . "\n");
				fwrite($sitemap,'</url>'. "\n");
			}
			}
			//closedir( $dirhandle );
			
			fwrite($sitemap, '</urlset>');
			// close the xmlsitemap
			fclose($sitemap);
			//sitemap index entry for this sitemap:
			?>

	<sitemap>
		<loc><?php echo $sitemapfilename; ?></loc>
		<lastmod><?php echo date('Y-m-d\TH:i:sP'); ?></lastmod>
	</sitemap>
<?php
		}
	}
}
	?>

<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
	<?php
	parse_dir();
	?>
</sitemapindex>
