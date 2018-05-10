<?php

/**
 * PHP Script to generate xml sitemap index for IEDA metadata
 
 * 2018-04-30
 * 
 
 repository: https://github.com/iedadata/resources/tree/master/XMLsitemap%20tool
 */

// require './config.php';

// Sent the correct header so browsers display properly, with or without XSL.
header( 'Content-Type: application/xml' );

echo '<?xml version="1.0" encoding="utf-8"?>' . "\n";

// xslt to make pretty html for sitemap index
if ( isset( $xsl ) && !empty( $xsl ) )
	echo '<?xml-stylesheet type="text/xsl" href="' . SITEMAP_DIR_URL . $xsl . '"?>' . "\n";

function get_sitemapindex() {
	global $chfreq;

	$handle = opendir( $dir );
	while ( false !== ( $file = readdir( $handle ) ) ) {

		// Check if this file needs to be ignored, if so, skip it.
		if ( in_array( utf8_encode( $file ), $ignore ) )
			continue;

		if ( is_dir( $file ) ) {
			if ( defined( 'RECURSIVE' ) && RECURSIVE )
				parse_dir( $file, $url . $file . '/' );
		}

		// Check whether the file has on of the extensions allowed for this XML sitemap
		$fileinfo = pathinfo( $dir . $file );
		if ( in_array( $fileinfo['extension'], $filetypes ) ) {

			// Create a W3C valid date for use in the XML sitemap based on the file modification time
			if (filemtime( $dir .'/'. $file )==FALSE) {
				$mod = date( 'c', filectime( $dir . $file ) );
			} else {
				$mod = date( 'c', filemtime( $dir . $file ) );
			}

			// Replace the file with it's replacement from the settings, if needed.
			if ( in_array( $file, $replace ) )
				$file = $replace[$file];

			// Start creating the output
	?>

<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
   <sitemap>
      <loc>http://www.example.com/sitemap1.xml.gz</loc>
      <lastmod>2004-10-01T18:23:17+00:00</lastmod>
   </sitemap>
   <sitemap>
      <loc>http://www.example.com/sitemap2.xml.gz</loc>
      <lastmod>2005-01-01</lastmod>
   </sitemap>
</sitemapindex>
	
	
<!--    <url>
        <loc><?php echo 'http://get.iedadata.org/' . rawurlencode( $file ); ?></loc>
        <lastmod><?php echo $mod; ?></lastmod>
        <changefreq><?php echo $chfreq; ?></changefreq>
        <priority><?php echo $prio; ?></priority>
    </url>
-->
	
	<?php
		}
	}
	closedir( $handle );
}

?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"><?php
	get_sitemapindex();
?>

</urlset>
