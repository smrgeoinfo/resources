This directory contains php scripts that will scan a web accessible folder (TransformJob.php) or a local directory (DOItoISO.php), and if it finds xml files in recognized xml dialects will transform them to ISO 19139 (gmd:MD_Metadata) XML and deposit them in a specified directory on the server hosting the php. 

Developed and tested with WAMP Server 3.1.1, php 5.6.31. 

The URLs and file paths for reading and writing are specific to my dev environment and will need to be reviewed and updated for use in IEDA production environments. 

TransformJob will recognize DataCite XML, Dublin Core XML (OAI or rdf flavors), EML (tested with v2.1.1) XML, and CSDGM (FGDC) XML, and writes to a directory tree constructed to reflect the directory tree of the web location it was pointed at. It is designed to scrape metadat from a web accessible folder and write ISO 19139 xml for another WAF to be harvested by an ISO metadata aggregator. It uses xslt files that are at https://github.com/usgin/metadataTransforms

DOtoISO.php reads DataCite xml metadata from a directory, tries to identify the IEDA partner system that is the steward of the described resoruce, and writes ISO xml to subdirectories for each partner. 

Stephen Richard 2018-06-02
