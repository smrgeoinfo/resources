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

$filetypes = array( '' );

// Ignore array, files listed in this array will not be included in the sitemap.
$ignore =  array( '.', '..', 'config.php', 'xml-sitemap.php' ) ;

/*
 * The directory to check.
 * Make sure the DIR ends ups in the Sitemap Dir URL below, otherwise the links to files will be broken!
 */
$dir = 'metadata/iso' ;

// With trailing slash!
$baseurl = 'http://get.iedadata.org/' ;

// Set the correct header in the sitemapindex file so browsers display properly.
header( 'Content-Type: application/xml' );

echo '<?xml version="1.0" encoding="utf-8"?>' . "\n"; 

// insert xsl directive so browsers display as html
if ( isset( $xsl ) && !empty( $xsl ) )
	echo '<?xml-stylesheet type="text/xsl" href="' . $xsl . '"?>' . "\n"; 


function parse_dir( ) {
	global $ignore, $filetypes, $chfreq, $prio, $dir, $baseurl, $xsl;
	
	$dirit = new DirectoryIterator($dir);
	foreach ($dirit as $fileinfo) {
		if ($fileinfo->isDir() && !$fileinfo->isDot()) {
			//echo $fileinfo->getFilename().'<br>';
			$thisdir = $fileinfo->getFilename();
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
				// Create a W3C valid date for use in the XML sitemap based on the file modification time
				if (filemtime( $localpath .'/'. $file )==FALSE) {
					$mod = date( 'c', filectime( $localpath . '/'. $file ) );
				} else {
					$mod = date( 'c', filemtime( $localpath . '/'. $file ) );
				}
				
				fwrite($sitemap,'<url>'. "\n");
				fwrite($sitemap,'<loc>'. $baseurl . $localpath.'/'.$file . '</loc>'. "\n");
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
