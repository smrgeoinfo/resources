Instructions to update GRL database (2017-11-08)
There are two master SQL scripts for updating the GRL database:

ScriptToInsertDataForGRLdbUpdate20171206.sql  This script inserts the new data tables:
NOTE: this script is also in the EarthChemLibrary/metadata directory because it is used to update the database for new keyword scheme.
  keyword_ieda, keyword_ecl, keyword_type, and submission_keyword_map, person_external_identifier,  bridge_person_num_distinctname, bridge_submission_cruise. 
  These implement a new many to many mapping from keywords to submissions, with one keyword table for standard IEDA keywords, and one for local ecl keywords. The other tables implement multiple person external identifiers and submission-cruise mapping (from R2R), and mapping duplicate persons in the person table to a single 'normative' instance. 
  
  See below for description of tables added.
  
 These tables need to be added by running this script before inserting the queries with the second script:
  
ScriptToCreateViews4DataCiteXML-v2.sql  This drops all the xml-related queries (if they exist) and creates them again. If the queries are modified, the changes MUST be made in this script or they will be lost if the script is run again. Dropping all the existing queries avoids problems with dependencies between between the queries. 



  
These queries generate DataCite v4 xml metadata from the GRL production database. In the process of generating the dataCite metadata, Peng Ji's work on deduplicating persons and mapping to ORCID's or Scopus IDs was used to update the GRL.person table, and also created a new table mapping cruise IDs to Bob Arko's R2R Cruise DOIs so we can link those as well. This adds three tables in the database-- bridge_submission_cruise and person_external_identifier, bridge_person_num_distinctname, along with a set of linked queries. 
The bridge_person_num_distinctname table will be unnecessary if we update the author_list tables to reference a unique person_num for each person.  The Person table does not need to be culled, but duplicate person_num values should be marked deprecated somehow--perhaps use the 'approval' field?. 
JIRA tasks have been created for the Db updates required (http://jira.iedadata.org/browse/GRLD-235 and http://jira.iedadata.org/browse/GRLD-236)

The XML is constructed with a set of queries (defined in ScriptToCreateViews4DataCiteXML.sql) that construct various components for the XML document.  The queries are documented here.

vw_submission_geom:  aggregate IGSN sample locations from mvw_submission_points, to get all geometries associated with a submission as a multipoiint, bounding box as text, and a bounding box geometry, along with a geometrytype.   If there is only one point, the bbox geometry is a point.

vw_submission_points: Join submissions with dataset_file_list and dataset_file_geometry to gather all geometries associated with a submission; returns submission_id, geometry and geometry type (not just points)

vw_xml_related_submission: joins  submissions and dataset_relations to generates xml  relatedidentifier elements in DataCite, returns the xml element and submission_Id.  

vw_xml_submission_format: Joins submissions, dataset_file_list and data_file_formats to generate xml element 'format' containing a list of all the file formats associated with the submission. File order is not preserved.

vw_datacite_xml_generator:  Main query, gathers subqueries to assemble final XML documents for all published submissions; returns submission_id, DataCite xml where submission status = 2 (i.e. only published submissions). JOINS: submissions, dataset_types, submission_coverage_scopes, languages, dataset_group, mvw_xml_related_submission, vw_submission_cruise_xml, vw_xmligsn, mvw_xml_submission_format,  xmlcreator_lu, xml_subject_datatype, mvw_submission_geom

vw_datacite_xml_generator_withStatus: same as vw_datacite_xml_generator but allows status to be queried. Returns submission_id, status_id, DataCite xml

vw_lookup_ids2use: lookup table, maps current person.person_num to a de-duplicated person_num (the min person_num for the set of person_nums referring to the same person) by selecting min person_num from bridge_person_num_distinctname grouped by lastName,FirstName, MI, email; also has column for email and iaf_guid. The iaf_guid is for lookup in  person_external_identifier to get Scopus and Orcid identifiers from Peng Ji's work.

vw_submission_cruise_xml: Join bridge_submission_cruise and submisions to generate DataCite relatedIdentifeir XML for correlation of submissions with cruises, using cruise DOIs from Bob Arko. 

vw_submission_igsn: Joins dataset_file_list, submisions, dataset_file_external_identifier, external_identifier_system where the external ID system is 'IGSN' to link submission_ID with IGSN and landing page URL; return submission_id, igsn, and langding page URL.

vw_xmligsn: generates XML relatedIdentifer elements from vw_submission_igsn by aggregating on submission_id. Returns submission_id and XML relatedIdentifier elements.

xml_subject_datatype: JOINS submissions, data_type_list, and data_type to generate xml element 'subject' by aggregating all data types in data_type_list associated with each submission.
 
xmlcreator_lu: Joins author_list, person, person_external_identifier, bridge_person_num_distinctname and vw_lookup_ids2use to generate a DataCite xml 'creator' elements based on the author list for the submission.  Returns submission_id and xmlCreator

These are the GRL database tables that are used by the queries:
author_list
bridge_submission_cruise  (New)
bridge_person_num_distinctname (new, but ideally the author_list table can be updates to its unnecessary)
dataset_file_geometry
dataset_file_list
dataset_group
dataset_relation
dataset_types
languages
person
person_external_identifier (new)
submissions
submission_coverage_scopes

The DataCite xml applies the 
https://creativecommons.org/licenses/by-nc-sa/3.0/us/  license for all submissions.

**********************************************************************
Data Tables added to schema
**********************************************************************
For field descriptions, see the creatTable sections in the script to insert data for GRL update.

"person_external_identifier";  Correlation table, correlated person with 0 to many identifiers. 

sequence  public.person_external_identifier_id_seq : sequence used for default nextval for PK (id) in person_external_identifier
 
"bridge_person_num_distinctname" :maps multiple person_num values to single identifier; use to remove duplicate entries for same person in person table. TBD-- update person and author_list tables to remove duplicates.'

"bridge_submission_cruise" : Correlates submissions to Cruise identifier strings and DOI assigned to cruises. Data from GeoLink (Peng Ji). 

"keyword_ecl" : compilation of all keywords from USAP database tables: initiative, keyword, parameter, platform, program, sensor. The original table names are loaded as keyword types.';

"keyword_ieda" : unique values for new IEDA keywords, created october 2017.

"keyword_type" : classifiers for keywords, use to group in user interface facets.

"submission_keyword_map" : simple correlation table, maps keywords from either keyword_ecl or keyword_ieda table to submissions; compound key (submission_id, keyword_id)