# Files for html display of ISO19139 and 19139-1 records

What's here

## displaymetadata.php

PHP page that gets an ISO xml record and transforms to html using teh xsl files in this direcory.

Calling parameters: displaymetadata.php?file={NNNNNN} or displaymetadata.php?file={NNNNNN}.XXX

where NNNNNN is the 6 digit number used by IEDA as the final token in DOI string, e.g. for doi:10.1594/IEDA/100096, NNNNNN would be '100096'.  The file extension is optional, '.xml' will return the ISO xml raw, '.htm' or '.html' will return the html view (same as no file extension). 

## ISO19139ToHTMLwMap.xsl

Base transform for converting ISO xml to html. Extensively modified from transform originated by Jacqui Mize at NOAA. This transform imports the various xsl files in the imports subdirectory, as well as the ISO19139ToSchemaOrgDataset1.0.xslt transform.

## ISO19139ToSchemaOrgDataset1.0.xslt

XML transform to generate Schema.org Dataset JSON-LD metadata serialization from ISO xml metadata format.

## .htaccess

Apache rewrite directives. Strips a string of numbers  or a string of numbers followed by '.' and some characters from the end of the url, and passes that to displaymetadata.php as the file= parameter. Designed for requests like http://{$_SERVER['HTTP_HOST']}/metadata/{NNNNNN} or 
http://{$_SERVER['HTTP_HOST']}/metadata/{NNNNNN}.XXX

## imports

Subdirectory containing various files required for the ISO xml to html transformation.

### generalwMap.xslt

### iso19139usginMap.xslt

### other support files

These are unmodified from the original package produced by JM at NOAA: 

auxCountries.xslt, auxLanguages.xslt, auxUCUM.xslt are lookup files for standard abbreviations.

codelists.xslt, XML.xslt handlers for commonly used elements.

## Files for map display in html view:

If the ISO xml contains spatial extents encoded either as a bounding box or as gmd:polygon//gmd:Point, a map will be displayed in the landing page. The scripts were written by developers at IEDA and are used in the IEDA dataset landing pages. Minor modifications were necessary for use here; changes are noted in comments in the code. Note that coordinate locations at the poles are not handled.

### doimap.js

Handles drawing extent geometries on the basemap

### basemap_v3.js

Sets up the base map, using WMS tiles from the GMRT OGC web map service.

### jquery-1.9.1.js, jquery-ui-1.10.2.custom.min.js 

Handlers for jquery. No modifications in these scripts for use here, they are cached to make sure we have the correct versions.

### doimap.CSS

Styles used for map display. The cascade of CSS files has not been analyzed here, and there's probably a lot of unused stuff that could be culled. TBD....

# Deployment

This package is designed to deploy on a LAMP or WAMP server, tested with php 5.1.6 (LAMP, RedHat) and 5.6.31 (WAMP, Windows 10). Deploy the code in a directory ../metadata/iso, relative to the root web path. The directory should contain subdirectories containing ISO XML metadata. In the IEDA deployment, the subdirectories are associated with IEDA partner systems, and the code contains various customizations specific to the IEDA environment. Expected subdirectories are USAP, ECL, and MGDL. 

The .htaccess file takes a URL like http://{$_SERVER['HTTP_HOST']}/metadata/{NNNNNN} and rewrites to pass to the displaymetadata.php page with file=NNNNNN as the parameter. This will generate and display an html view for that resource with a schema.org JSON-LD script in the header

