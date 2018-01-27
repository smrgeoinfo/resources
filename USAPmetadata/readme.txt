The make_*.sql create new keyword tables for the usap database. There is a separate make script for each table.

 ScriptToCreateViews_USAP-DataciteXML.sql creates queries to make DataCiteXML from the USAP database tables. 
 
 usap_dump2meta.py processes a bulk DataCiteXML dump from the USAP-DC database, generated using the generate_datacite_xml query, into separate DataCite v4 XML files for processing into the geoportal. 

 SplitGCMD-api-alignWithIEDA-ISO.xsl transform to process results from API calls to gcmd to extract GCMD ISO records and convert to schema valid ISO19139 XML.
 
 SMR 2018-01-27