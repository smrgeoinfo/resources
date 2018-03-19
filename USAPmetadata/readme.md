# scripts to update the USAP-DC database

This directory contains SQL scripts to add keyword tables and views to generate DataCite metadata from the USAP-DC database 

The make_*.sql create new keyword tables for the usap database. There is a separate make script for each table.

 ScriptToCreateViews_USAP-DataciteXML.sql creates queries to make DataCiteXML from the USAP database tables. 
 
 usap_dump2meta.py processes a bulk DataCiteXML dump from the USAP-DC database, generated using the generate_datacite_xml query, into separate DataCite v4 XML files for processing into the geoportal. This is from early development when the generate datacite xml query results were exported in bulk, then parsed to save separate datacite xml records for each dataset. 

 SplitGCMD-api-alignWithIEDA-ISO.xsl transform to process results from API calls to gcmd to extract GCMD ISO records and convert to schema valid ISO19139 XML.  This was created to process results from API calls to GCMD to get ISO metadata records for the Antarctic Master directory. Final query to pull Antarctic data from GCMD. there are 3177 records, so have to page, use page size 1000 to get more manageable file size:
<pre>
curl -X POST \
  'https://cmr.earthdata.nasa.gov/search/collections.iso19115?page_num=1&page_size=1000&sort_key\[\]=short_name' \
  -H 'content-type: application/json' \
-d '{ "condition": {"or":[{"keyword":"AMD/US"},{"project":"NSF/PLR"},{"project":"USARP"},{"project":"USAP"},{"keyword":"LTER_PAL_*"},{"keyword":"NBP*"}, {"keyword":"LMG*"} ]}} '
</pre>
 
 SMR 2018-01-27
