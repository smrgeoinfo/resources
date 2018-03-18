<?php
/**
 * Sets up environment for eclsync.php-- location of metadata relative
 to location where php will run, the url for the directory containing output 
 metadata, and flag to determin if the input directory should be traversed
 recursively.  Other variables are inherited from original sitemap xml script, and
 are probably not used (but left just in case...)  SMR 2018-03-18
 * Change the configuration below and rename this file to config.php
 */

/*
 * The directory to check.
 * Make sure the DIR ends ups in the Sitemap Dir URL below, otherwise the links to files will be broken!
 */
define( 'SITEMAP_DIR', '../metadata/doi/' );

// With trailing slash!
define( 'SITEMAP_DIR_URL', 'http://get.iedadata.org/metadata/doi/' );

// Whether or not the script should check recursively.
define( 'RECURSIVE', false );

// The file types, you can just add them on, so 'pdf', 'php' would work
$filetypes = array( '' );

// The replace array, this works as file => replacement, so 'index.php' => '', would make the index.php be listed as just /
$replace = array( 'index.php' => '' );

// The XSL file used for styling the sitemap output, make sure this path is relative to the root of the site.
$xsl = 'dataciteToHTMLwithSDO.xsl';

// The Change Frequency for files see https://www.sitemaps.org/protocol.html.
$chfreq = 'yearly';

// The Priority Frequency for files. There's no way to differentiate so it might just as well be 1.
$prio = 1;

// Ignore array, all files in this array will be: ignored!
$ignore = array( 'configxform.php' );
