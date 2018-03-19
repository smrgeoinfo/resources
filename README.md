# Resources for IEDA systems
Public repository for sharing various resources with the community. resources are organized in folders related to IEDA partner systems or various applications that are not partner specific.

* DataCiteXMLTransforms: This folder contains XSLT transform modules for converting DataCiteXML to ISO19139, to HTML, and to HTML with Schema.org markup in the <head>. The transforms are constructed to work with dataCite v2, v3, or v4 XML. The php scripts are used in the get.iedadata.org/doi website to handle requests for DOI landing pages by getting the DataCiteXML file and transforming it to HTML. Datadoi.php does only html, Datadoi-sdo.php inserts the schema.org markup using the DataCiteToSchemaOrgDataset transform.   The archive subdirectory contains older versions of the various files.

* earthchemDB: contains draft sql script for generating the IEDA EarthChem Db schema and background content tables, necessary to create a new, clean earthchemDB instance. This has not been completed or tested.

* EarthChem Library. Contains sql to generate JSON archive job files for the ATP data submission hub archive workflow, and a python script to take a dump of DataCite metadata generated using the vw\_datacite\_xml\_generator query (defined in metadata/ScriptToCreateViews4ECLDataCiteXML sql script), and split into separate xml files for bulk processing into the IEDA geoportal.  
  * metadata subdirectory contains sql scripts for constructing DataCite XML from ECL database.

* USAP metadata. Contains SQL scripts to insert new keyword tables in usap database (separate make script for each table), and SQL script to generate queries to make DataCiteXML from the USAP database. The python script is for processing a bulk DataCiteXML dump from the USAP-DC database into separate XML files for processing into the geoportal. The SplitGCMD xsl transforms are for processing results from API calls to gcmd to extract GCMD ISO records and convert to schema valid ISO19139 XML.

* XMLsitemap tool. contains php code and xsl transform to display site map. This code is from https://github.com/jdevalk/XML-Sitemap-PHP-Script, with configuration added to work in the get.iedadata.org/doi directory.

* Specimen JSON-LD. Contains documents related to generating a JSON-LD representation for geologic specimens
