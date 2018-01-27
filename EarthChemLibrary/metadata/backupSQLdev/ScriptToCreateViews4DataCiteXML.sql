-- SMR 2017-10-17 split the script into data loader and query generator
-- drop all the existing queries when start--
-- !!!!!!!!! SO BE SURE TO SYNC any changes YOU MADE in the database with this file 
-- before you run it OR YOU WILL LOSE YOUR WORK!!

-- SMR 2017-12-03  update geometry query so doesn't generate geometry if coverage scope 
--   is tagged as 'global' (submission coverage_scope_id = 2)

-- 2. insert queries.
--    vw_submission_points
--    vw_submission_geom
--    vw_lookup_ids2use
--    vw_submission_igsn

	-- queries to generate XML
	--    vw_xml_creator_lu
	--    vw_xmligsn
	--    vw_xml_submission_format
	--    vw_xml_related_submission
	--    vw_xml_submission_format
	--    vw_submission_cruise_xml

	-- queries that generate final XML docs
	--    vw_datacite_xml_generator
	--    vw_datacite_xml_generator_withStatus
--
--First clean up
DROP VIEW if exists public.vw_datacite_xml_generator CASCADE;
DROP VIEW if exists public."vw_datacite_xml_generator_withStatus" CASCADE;
DROP VIEW if exists public."vw_xml_ieda_subject" CASCADE;
DROP VIEW if exists public."vw_xml_ecl_subject" CASCADE;
DROP VIEW if exists public.vw_submission_points CASCADE;
DROP VIEW if exists public.vw_submission_geom CASCADE;
DROP VIEW if exists public.vw_lookup_ids2use CASCADE;
DROP VIEW if exists public.vw_xml_creator_lu CASCADE;
DROP VIEW if exists public.vw_submission_igsn CASCADE;
DROP VIEW if exists public.vw_xmligsn CASCADE;
DROP VIEW if exists public.vw_xml_related_submission CASCADE;
DROP VIEW if exists public.vw_xml_submission_format CASCADE;
DROP VIEW if exists public.vw_submission_cruise_xml CASCADE;

--  Now the queries.  

-- View: public."vw_xml_ieda_subject"
-- DROP VIEW public."vw_xml_ieda_subject";
CREATE  VIEW public.vw_xml_ieda_subject AS 
 SELECT s.submission_id,
    xmlagg(
		XMLELEMENT(NAME subject, 
			XMLATTRIBUTES(kt.keyword_type_label AS "subjectScheme"), ik.ikeyword_label) 
		ORDER BY kt.keyword_type_label
	) AS subject_xml
   FROM submissions s join submission_keyword_map skm on s.submission_id = skm.submission_id
     join iedakeywords ik on skm.keyword_id = ik.ikeyword_id
     join keyword_type kt on ik.ikeyword_type_id = kt.keyword_type_id
  GROUP BY s.submission_id;


-- View: public."vw_xml_ecl_subject"
-- DROP VIEW public."vw_xml_ecl_subject";
CREATE  VIEW public.vw_xml_ecl_subject AS 
   SELECT s.submission_id,
    xmlagg(
		XMLELEMENT(NAME subject, 
			XMLATTRIBUTES(kt.keyword_type_label AS "subjectScheme"), ek.keyword_label) 
		ORDER BY kt.keyword_type_label
	) AS subject_xml
   FROM submissions s join submission_keyword_map skm on s.submission_id = skm.submission_id
     join eclkeyword ek on skm.keyword_id = ek.keyword_id
     join keyword_type kt on ek.keyword_type_id = kt.keyword_type_id
    GROUP BY s.submission_id;

--  View: public.vw_submission_points
-- DROP  VIEW public.vw_submission_points;
CREATE  VIEW public.vw_submission_points AS 
 SELECT distinct s.submission_id AS s_id,
     (st_dump(dfg.geometry)).geom AS the_geom,
    geometrytype((st_dump(dfg.geometry)).geom) AS type 
   FROM  submissions s 
	left join dataset_file_list dfl  on s.submission_id = dfl.submission_id
	left join dataset_file_geometry dfg on dfl.dataset_file_list_id = dfg.dataset_file_list_id  
  WHERE   
   dfg.geometry IS NOT NULL AND geometrytype(dfg.geometry) = 'POINT'::text;
   
-- ALTER TABLE public.vw_submission_points
  -- OWNER TO postgres;

  
--  View: public.vw_submission_geom
-- DROP VIEW public.vw_submission_geom;
-- SMR 2017-12-03 update to skip submissions that have coverage scope 'global'
CREATE VIEW public.vw_submission_geom AS 
 SELECT f.s_id,
    count(f.the_geom) AS count,
    st_multi(st_collect(f.the_geom)) AS multipt,
    st_astext(st_envelope(st_multi(st_collect(f.the_geom)))) AS bbox_txt,
    st_envelope(st_multi(st_collect(f.the_geom))) AS bbox_geom,
    geometrytype(st_envelope(st_multi(st_collect(f.the_geom)))) AS type
   FROM vw_submission_points f left join submissions s on f.s_id=s.submission_id 
   where submission_coverage_scope_id != 2
  GROUP BY f.s_id;

-- ALTER TABLE public.vw_submission_geom
  -- OWNER TO postgres;
COMMENT ON VIEW public.vw_submission_geom
  IS 'gather IGSN sample locations associated with a submission, return a multipoiint, bounding box as text, and a bounding box geometry.   If there is only one point, the bbox geometry is a point. Do not return results if coverage scope is global.';


-- View: public.vw_lookup_ids2use
-- smr 2017-10-17 update to union with persons who aren't in the bridge_person_num_distinctname table
-- DROP VIEW public.vw_lookup_ids2use;
CREATE OR REPLACE VIEW public.vw_lookup_ids2use AS 
  SELECT bpnd.person_num,
    useme.use_person_num,
    bpnd.last_name,
    bpnd.first_name,
    bpnd.mi,
    bpnd.email,
    bpnd.iaf_guid
   FROM bridge_person_num_distinctname bpnd
       JOIN ( SELECT min(bpnd_1.person_num) AS use_person_num,
            bpnd_1.last_name,
            bpnd_1.first_name,
            bpnd_1.mi,
            bpnd_1.email
          FROM bridge_person_num_distinctname bpnd_1
    GROUP BY bpnd_1.last_name, bpnd_1.first_name, bpnd_1.mi, bpnd_1.email
    ORDER BY (min(bpnd_1.person_num))) useme 
       ON useme.last_name = bpnd.last_name 
          AND useme.first_name = bpnd.first_name 
          AND useme.mi = bpnd.mi 
          AND useme.email = bpnd.email
union
    select 
     pe.person_num,
     pe.person_num use_person_num,
     pe.last_name,
     pe.first_name,
     pe.middle_initial mi,
     pe.email,
     null::text as iaf_guid
      from  person pe 
        left join bridge_person_num_distinctname bp on pe.person_num = bp.person_num  
      where bp.person_num is null and pe.last_name is not null and length(pe.last_name)>0

order by person_num;

-- ALTER TABLE public.vw_lookup_ids2use
  -- OWNER TO postgres;
COMMENT ON VIEW public.vw_lookup_ids2use
  IS 'lookup table, maps current person.person_num to a de-duplicated person_num (the min person_num for the set of person_nums referring to the same person); also has column for email and iaf_guid. The iaf_guid is for lookup in  person_external_identifier to get Scopus and Orcid identifiers from Peng Ji''s work.';

  
-- View: public.vw_submission_igsn
-- DROP VIEW public.vw_submission_igsn;
CREATE VIEW public.vw_submission_igsn AS 
 SELECT s.submission_id as s_id,
    dfei.external_identifier_name AS igsn,
    concat('https://app.geosamples.org/sample/igsn/'::text, dfei.external_identifier_name) AS landingpage
   FROM dataset_file_list dfl,
    submissions s,
    dataset_file_external_identifier dfei,
    external_identifier_system eis
  WHERE dfl.dataset_file_list_id = dfei.dataset_file_list_id AND s.submission_id = dfl.submission_id AND dfei.external_identifier_system_id = eis.external_identifier_system_id AND eis.external_identifier_system_name::text = 'IGSN'::text
  ORDER BY s.submission_id;

-- ALTER TABLE public.vw_submission_igsn
  -- OWNER TO postgres;
COMMENT ON VIEW public.vw_submission_igsn
  IS 'link submission ID with IGSN and landing page URL';

  -- **** START HERE-- have to figure out how to integrate updated person list with subsequent uncontrolled additions.
  
-- View: public.vw_xml_creator_lu
-- DROP VIEW public.vw_xml_creator_lu;
CREATE VIEW public.vw_xml_creator_lu AS 
 SELECT al.submission_id AS s_id,
    xmlagg(XMLELEMENT(NAME creator, 
		XMLELEMENT(NAME "creatorName", 
			btrim(concat(litu.last_name, ',', litu.first_name, ' ', litu.mi))), 
		XMLELEMENT(NAME "givenName", 
			btrim(concat(litu.first_name, ' ', litu.mi))), 
		XMLELEMENT(NAME "familyName", btrim(litu.last_name)),
        CASE
            WHEN litu.email IS NOT NULL AND litu.email <> ''::text THEN 
				XMLELEMENT(NAME "nameIdentifier", XMLATTRIBUTES('e-mail address'::text AS "nameIdentifierScheme"), concat('mailto:'::text, litu.email))
            ELSE NULL::xml
        END, 
		( SELECT theids.xmlnameid
           FROM ( SELECT bpnd.person_num,
                    xmlagg(
						XMLELEMENT(NAME "nameIdentifier", XMLATTRIBUTES(pei.external_identifier_schema AS "nameIdentifierScheme"), pei.external_identifier_value)) AS xmlnameid
                   FROM person_external_identifier pei
                     LEFT JOIN bridge_person_num_distinctname bpnd ON pei.person_id::text = bpnd.iaf_guid
                  GROUP BY bpnd.person_num) theids
          WHERE theids.person_num = p.person_num), 
		 XMLELEMENT(NAME "nameIdentifier", XMLATTRIBUTES('grl person_num'::text AS "nameIdentifierScheme"), concat('urn:grl:person:'::text, litu.use_person_num))) ORDER BY al.author_order) AS xmlcreator
   FROM author_list al
     LEFT JOIN person p ON p.person_num = al.person_num
     JOIN vw_lookup_ids2use litu ON p.person_num = litu.person_num
  GROUP BY al.submission_id;

-- ALTER TABLE public.vw_xml_creator_lu
  -- OWNER TO postgres;
COMMENT ON VIEW public.vw_xml_creator_lu
  IS 'Joins author_list, person, person_external_identifier, bridge_person_num_distinctname and vw_lookup_ids2use to generate DataCite xml ''creator'' elements based on the author list for the submission.  Returns submission_id and xmlCreator';


-- View: public.vw_xmligsn
-- DROP VIEW public.vw_xmligsn;
CREATE OR REPLACE VIEW public.vw_xmligsn AS 
 SELECT vsi.s_id AS s_id,
    xmlagg(
		XMLELEMENT(NAME "relatedIdentifier", 
			XMLATTRIBUTES('IGSN'::text AS "relatedIdentifierType", 'IsDerivedFrom'::text AS "relationType"), 
			concat('igsn:'::text, vsi.igsn)) 
		ORDER BY vsi.s_id
	) AS xmligsn
   FROM vw_submission_igsn vsi
  GROUP BY vsi.s_id;

-- ALTER TABLE public.vw_xmligsn
  -- OWNER TO postgres;
COMMENT ON VIEW public.vw_xmligsn
  IS 'aggregate igsn associated with a submission';

 --The name on this view is defined twice in the script; this query is xml_subject_datatype
-- VIEW: public.vw_xml_subject_datatype
-- DROP VIEW public.vw_xml_subject_datatype;
CREATE OR REPLACE VIEW public.vw_xml_subject_datatype AS 
 SELECT s.submission_id as s_id,
    xmlagg(
		XMLELEMENT(NAME subject, 
			XMLATTRIBUTES('dataType'::text AS "subjectScheme"), dt.data_type_name) 
		ORDER BY dtl.list_order
	) AS subject_xml
   FROM submissions s,
    data_type_list dtl,
    data_type dt 
  WHERE dtl.submission_id = s.submission_id AND dtl.data_type_id = dt.data_type_id
  GROUP BY s.submission_id;

-- ALTER TABLE public.vw_xml_subject_datatype
  -- OWNER TO postgres;
COMMENT ON VIEW public.vw_xml_subject_datatype
  IS 'aggregates all data types in data_type_list associated with each submission, and generates a set of subject xml elements for DataCite output';

  
-- VIEW: public.vw_xml_related_submission
-- DROP VIEW public.vw_xml_related_submission;
CREATE OR REPLACE VIEW public.vw_xml_related_submission AS 
 SELECT relsub.submission_id AS s_id,
    xmlagg(XMLELEMENT(NAME "relatedIdentifier", XMLATTRIBUTES('DOI'::text AS "relatedIdentifierType", relsub.type AS "relationType"), relsub.rdoi)) AS xmlrelsub
   FROM ( SELECT s.submission_id,
            dr.type,
            rs.dataset_doi AS rdoi
           FROM dataset_relation dr,
            submissions s,
            submissions rs
          WHERE dr.relation_id = rs.submission_id AND s.submission_id = dr.submission_id) relsub
  GROUP BY relsub.submission_id;

-- ALTER TABLE public.vw_xml_related_submission
  -- OWNER TO postgres;
COMMENT ON VIEW public.vw_xml_related_submission
  IS 'generates xml for relatedIdentifier elemetns in DataCite by joining  submisions and dataset_relations, returns the xml element and submission_Id.';

-- VIEW: public.vw_xml_submission_format
-- DROP VIEW public.vw_xml_submission_format;
CREATE OR REPLACE VIEW public.vw_xml_submission_format AS 
 SELECT msf.submission_id AS s_id,
    xmlagg(XMLELEMENT(NAME format, concat(msf.data_file_format, '  '::text, msf.data_file_format_name))) AS xmlformat
   FROM ( SELECT DISTINCT s.submission_id,
            dff.data_file_format,
            dff.data_file_format_name
           FROM submissions s,
            dataset_file_list dfl,
            data_file_formats dff
          WHERE s.submission_id = dfl.submission_id AND dfl.data_file_format_id = dff.data_file_format_id) msf
  GROUP BY msf.submission_id;

-- ALTER TABLE public.vw_xml_submission_format
  -- OWNER TO postgres;
COMMENT ON VIEW public.vw_xml_submission_format
  IS 'Joins submissions, dataset_file_list and data_file_formats to generate xml element ''format'' containing a list of all the file formats associated with the submission.  File order is not preserved.';

  
-- View: public.vw_submission_cruise_xml
-- DROP VIEW public.vw_submission_cruise_xml;
CREATE OR REPLACE VIEW public.vw_submission_cruise_xml AS 
 SELECT relsub.submission_id AS s_id,
    xmlagg(XMLELEMENT(NAME "relatedIdentifier", XMLATTRIBUTES('DOI'::text AS "relatedIdentifierType", 'IsDerivedFrom'::text AS "relationType"), relsub.rdoi)) AS xmlrelcruise
   FROM ( SELECT s.submission_id,
            bsc.*::bridge_submission_cruise AS cruise_id,
            bsc.cruise_doi AS rdoi
           FROM bridge_submission_cruise bsc,
            submissions s
          WHERE bsc.ecl_id = s.submission_id::text) relsub
  GROUP BY relsub.submission_id;

-- ALTER TABLE public.vw_submission_cruise_xml
  -- OWNER TO postgres;
COMMENT ON VIEW public.vw_submission_cruise_xml
  IS 'Join bridge_submission_cruise and submisions to generate DataCite relatedIdentifeir XML for correlation of submissions with cruises, using cruise DOIs from Bob Arko. ';

  
-- DROP VIEW public.vw_datacite_xml_generator;
--2017-10-17 adapt to use new eclkeyword and iedakeyword tables SMR
CREATE OR REPLACE VIEW public."vw_datacite_xml_generator" AS 
 SELECT s.submission_id,
    XMLROOT(XMLELEMENT(NAME resource, XMLATTRIBUTES('http://datacite.org/schema/kernel-4' AS xmlns, 'http://www.w3.org/2001/XMLSchema-instance' AS "xmlns:xsi", 'http://datacite.org/schema/kernel-4 http://schema.datacite.org/meta/kernel-4/metadata.xsd' AS "xsi:schemaLocation"), XMLELEMENT(NAME identifier, XMLATTRIBUTES(
        CASE
            WHEN s.dataset_doi IS NOT NULL AND s.dataset_doi::text <> ''::text THEN 'DOI'::text
            ELSE 'Other'::text
        END AS "identifierType"), COALESCE(ltrim(s.dataset_doi::text, 'doi:'::text), concat('http://www.earthchem.org/library/browse/view?id='::text, s.submission_id))), 
        XMLELEMENT(NAME creators, xlu.xmlcreator), 
             XMLELEMENT(NAME titles, XMLELEMENT(NAME title, s.title)), XMLELEMENT(NAME publisher, 'EarthChem Library(ECL) | Interdisciplinary Earth Data Alliance (IEDA) | Columbia University; doi:10.17616/R3V644'::text), XMLELEMENT(NAME "publicationYear", "left"(s.release_date::text, 4)), 
        XMLELEMENT(NAME "resourceType", XMLATTRIBUTES(( SELECT dt.dataset_type_name
           FROM dataset_types dt
          WHERE s.dataset_type_id = dt.dataset_type_id) AS "resourceTypeGeneral"), ( SELECT dt.dataset_type_name
           FROM dataset_types dt
          WHERE s.dataset_type_id = dt.dataset_type_id)), 
          XMLELEMENT(NAME subjects, 
		     XMLELEMENT(NAME subject, XMLATTRIBUTES('coverage scope'::text AS "subjectScheme"), 
		        ( SELECT scs.submission_coverage_scope_name
                      FROM submission_coverage_scopes scs
                WHERE s.submission_coverage_scope_id = scs.submission_coverage_scope_id)), 
             isx.subject_xml,
			 esx.subject_xml), 
          XMLELEMENT(NAME dates, 
		     XMLELEMENT(NAME date, XMLATTRIBUTES('Updated'::text AS "dateType"), concat('metadata update:'::text, s.last_modified)), 
		     XMLELEMENT(NAME date, XMLATTRIBUTES('Available'::text AS "dateType"), s.release_date), 
		     XMLELEMENT(NAME date, XMLATTRIBUTES('Created'::text AS "dateType"), s.created_date)), 
	XMLELEMENT(NAME language,
        CASE ( SELECT l.language
               FROM languages l
              WHERE s.language_id = l.language_id)
            WHEN 'English'::text THEN 'eng'::text
            ELSE ':unas'::text
        END), XMLELEMENT(NAME "alternateIdentifiers", XMLELEMENT(NAME "alternateIdentifier", XMLATTRIBUTES('IEDA submission_ID'::text AS "alternateIdentifierType"), concat('urn:grl:submission:'::text, s.submission_id::text)), XMLELEMENT(NAME "alternateIdentifier", XMLATTRIBUTES('URL'::text AS "alternateIdentifierType"), concat('http://www.earthchem.org/library/browse/view?id='::text, s.submission_id))), XMLELEMENT(NAME "relatedIdentifiers",
        CASE
            WHEN s.publication_doi IS NOT NULL AND s.publication_doi::text <> ''::text THEN XMLELEMENT(NAME "relatedIdentifier", XMLATTRIBUTES('DOI'::text AS "relatedIdentifierType", 'IsSupplementTo'::text AS "relationType"), s.publication_doi)
            ELSE NULL::xml
        END, ( SELECT mxrs.xmlrelsub
           FROM vw_xml_related_submission mxrs
          WHERE mxrs.s_id = s.submission_id), ( SELECT vsc.xmlrelcruise
           FROM vw_submission_cruise_xml vsc
          WHERE vsc.s_id = s.submission_id), ( SELECT vw_xmligsn.xmligsn
           FROM vw_xmligsn
          WHERE vw_xmligsn.s_id = s.submission_id)), XMLELEMENT(NAME formats, ( SELECT mxsf.xmlformat
           FROM vw_xml_submission_format mxsf
          WHERE mxsf.s_id = s.submission_id)),
        CASE
            WHEN s.rights IS NULL OR s.rights = ''::text THEN XMLELEMENT(NAME "rightsList", XMLELEMENT(NAME rights, XMLATTRIBUTES('https://creativecommons.org/licenses/by-nc-sa/3.0/us/'::text AS "rightsURI"), 'Creative Commons Attribution-NonCommercial-Share Alike 3.0 United States [CC BY-NC-SA 3.0]'::text))
            ELSE XMLELEMENT(NAME "rightsList", XMLELEMENT(NAME rights, s.rights))
        END, XMLELEMENT(NAME descriptions, XMLELEMENT(NAME description, XMLATTRIBUTES('Abstract'::text AS "descriptionType"), s.description), XMLELEMENT(NAME description, XMLATTRIBUTES('Other'::text AS "descriptionType"), concat('Related publications: '::text, s.related_publications))), XMLELEMENT(NAME "geoLocations", XMLELEMENT(NAME "geoLocation", XMLELEMENT(NAME "geoLocationPlace", s.geo_keywords),
        CASE
            WHEN msg.bbox_geom IS NOT NULL AND geometrytype(msg.bbox_geom) = 'POLYGON'::text THEN XMLELEMENT(NAME "geoLocationBox", XMLELEMENT(NAME "westBoundLongitude", st_xmin(msg.bbox_geom::box3d)), XMLELEMENT(NAME "eastBoundLongitude", st_xmax(msg.bbox_geom::box3d)), XMLELEMENT(NAME "southBoundLatitude", st_ymin(msg.bbox_geom::box3d)), XMLELEMENT(NAME "northBoundLatitude", st_ymax(msg.bbox_geom::box3d)))
            WHEN msg.bbox_geom IS NOT NULL AND geometrytype(msg.bbox_geom) = 'POINT'::text THEN XMLELEMENT(NAME "geoLocationPoint", XMLELEMENT(NAME "pointLongitude", st_xmax(msg.bbox_geom::box3d)), XMLELEMENT(NAME "pointLatitude", st_ymax(msg.bbox_geom::box3d)))
            ELSE NULL::xml
        END))), VERSION '1.0'::text) AS "dataCiteXML"
   FROM submissions s
     LEFT JOIN vw_xml_creator_lu xlu ON xlu.s_id = s.submission_id
     LEFT JOIN vw_xml_ieda_subject isx ON isx.submission_id = s.submission_id
     LEFT JOIN vw_xml_ecl_subject esx ON esx.submission_id = s.submission_id
     LEFT JOIN vw_submission_geom msg ON msg.s_id = s.submission_id
  WHERE s.status_id = 2;



-- ALTER TABLE public.vw_datacite_xml_generator
  -- OWNER TO postgres;
COMMENT ON VIEW public.vw_datacite_xml_generator
  IS 'Main query, gathers subqueries to assemble final XML documents for all published submissions; returns submission_id, DataCite xml where submission status = 2 (i.e. only published submissions). 
JOINS: 
submissions, 
dataset_types, 
submission_coverage_scopes,
languages, 
dataset_group, 
vw_xml_related_submission, 
vw_submission_cruise_xml, 
vw_xmligsn, 
vw_xml_submission_format,  
vw_xml_creator_lu, 
vw_xml_submission_format, 
vw_submission_geom';

-- View: public."vw_datacite_xml_generator_withStatus"
-- DROP VIEW public."vw_datacite_xml_generator_withStatus";
CREATE OR REPLACE VIEW public."vw_datacite_xml_generator_withStatus" AS 
 SELECT s.submission_id,
    s.status_id,
    XMLROOT(XMLELEMENT(NAME resource, XMLATTRIBUTES('http://datacite.org/schema/kernel-4' AS xmlns, 'http://www.w3.org/2001/XMLSchema-instance' AS "xmlns:xsi", 'http://datacite.org/schema/kernel-4 http://schema.datacite.org/meta/kernel-4/metadata.xsd' AS "xsi:schemaLocation"), XMLELEMENT(NAME identifier, XMLATTRIBUTES(
        CASE
            WHEN s.dataset_doi IS NOT NULL AND s.dataset_doi::text <> ''::text THEN 'DOI'::text
            ELSE 'Other'::text
        END AS "identifierType"), COALESCE(ltrim(s.dataset_doi::text, 'doi:'::text), concat('http://www.earthchem.org/library/browse/view?id='::text, s.submission_id))), 
        XMLELEMENT(NAME creators, xlu.xmlcreator), 
             XMLELEMENT(NAME titles, XMLELEMENT(NAME title, s.title)), XMLELEMENT(NAME publisher, 'EarthChem Library(ECL) | Interdisciplinary Earth Data Alliance (IEDA) | Columbia University; doi:10.17616/R3V644'::text), XMLELEMENT(NAME "publicationYear", "left"(s.release_date::text, 4)), 
        XMLELEMENT(NAME "resourceType", XMLATTRIBUTES(( SELECT dt.dataset_type_name
           FROM dataset_types dt
          WHERE s.dataset_type_id = dt.dataset_type_id) AS "resourceTypeGeneral"), ( SELECT dt.dataset_type_name
           FROM dataset_types dt
          WHERE s.dataset_type_id = dt.dataset_type_id)), 
          XMLELEMENT(NAME subjects, 
		     XMLELEMENT(NAME subject, XMLATTRIBUTES('coverage scope'::text AS "subjectScheme"), 
		        ( SELECT scs.submission_coverage_scope_name
                      FROM submission_coverage_scopes scs
                WHERE s.submission_coverage_scope_id = scs.submission_coverage_scope_id)), 
             isx.subject_xml,
			 esx.subject_xml), 
          XMLELEMENT(NAME dates, 
		     XMLELEMENT(NAME date, XMLATTRIBUTES('Updated'::text AS "dateType"), concat('metadata update:'::text, s.last_modified)), 
		     XMLELEMENT(NAME date, XMLATTRIBUTES('Available'::text AS "dateType"), s.release_date), 
		     XMLELEMENT(NAME date, XMLATTRIBUTES('Created'::text AS "dateType"), s.created_date)), 
	XMLELEMENT(NAME language,
        CASE ( SELECT l.language
               FROM languages l
              WHERE s.language_id = l.language_id)
            WHEN 'English'::text THEN 'eng'::text
            ELSE ':unas'::text
        END), XMLELEMENT(NAME "alternateIdentifiers", XMLELEMENT(NAME "alternateIdentifier", XMLATTRIBUTES('IEDA submission_ID'::text AS "alternateIdentifierType"), concat('urn:grl:submission:'::text, s.submission_id::text)), XMLELEMENT(NAME "alternateIdentifier", XMLATTRIBUTES('URL'::text AS "alternateIdentifierType"), concat('http://www.earthchem.org/library/browse/view?id='::text, s.submission_id))), XMLELEMENT(NAME "relatedIdentifiers",
        CASE
            WHEN s.publication_doi IS NOT NULL AND s.publication_doi::text <> ''::text THEN XMLELEMENT(NAME "relatedIdentifier", XMLATTRIBUTES('DOI'::text AS "relatedIdentifierType", 'IsSupplementTo'::text AS "relationType"), s.publication_doi)
            ELSE NULL::xml
        END, ( SELECT mxrs.xmlrelsub
           FROM vw_xml_related_submission mxrs
          WHERE mxrs.s_id = s.submission_id), ( SELECT vsc.xmlrelcruise
           FROM vw_submission_cruise_xml vsc
          WHERE vsc.s_id = s.submission_id), ( SELECT vw_xmligsn.xmligsn
           FROM vw_xmligsn
          WHERE vw_xmligsn.s_id = s.submission_id)), XMLELEMENT(NAME formats, ( SELECT mxsf.xmlformat
           FROM vw_xml_submission_format mxsf
          WHERE mxsf.s_id = s.submission_id)),
        CASE
            WHEN s.rights IS NULL OR s.rights = ''::text THEN XMLELEMENT(NAME "rightsList", XMLELEMENT(NAME rights, XMLATTRIBUTES('https://creativecommons.org/licenses/by-nc-sa/3.0/us/'::text AS "rightsURI"), 'Creative Commons Attribution-NonCommercial-Share Alike 3.0 United States [CC BY-NC-SA 3.0]'::text))
            ELSE XMLELEMENT(NAME "rightsList", XMLELEMENT(NAME rights, s.rights))
        END, XMLELEMENT(NAME descriptions, XMLELEMENT(NAME description, XMLATTRIBUTES('Abstract'::text AS "descriptionType"), s.description), XMLELEMENT(NAME description, XMLATTRIBUTES('Other'::text AS "descriptionType"), concat('Related publications: '::text, s.related_publications))), XMLELEMENT(NAME "geoLocations", XMLELEMENT(NAME "geoLocation", XMLELEMENT(NAME "geoLocationPlace", s.geo_keywords),
        CASE
            WHEN msg.bbox_geom IS NOT NULL AND geometrytype(msg.bbox_geom) = 'POLYGON'::text THEN XMLELEMENT(NAME "geoLocationBox", XMLELEMENT(NAME "westBoundLongitude", st_xmin(msg.bbox_geom::box3d)), XMLELEMENT(NAME "eastBoundLongitude", st_xmax(msg.bbox_geom::box3d)), XMLELEMENT(NAME "southBoundLatitude", st_ymin(msg.bbox_geom::box3d)), XMLELEMENT(NAME "northBoundLatitude", st_ymax(msg.bbox_geom::box3d)))
            WHEN msg.bbox_geom IS NOT NULL AND geometrytype(msg.bbox_geom) = 'POINT'::text THEN XMLELEMENT(NAME "geoLocationPoint", XMLELEMENT(NAME "pointLongitude", st_xmax(msg.bbox_geom::box3d)), XMLELEMENT(NAME "pointLatitude", st_ymax(msg.bbox_geom::box3d)))
            ELSE NULL::xml
        END))), VERSION '1.0'::text) AS "dataCiteXML"
   FROM submissions s
     LEFT JOIN vw_xml_creator_lu xlu ON xlu.s_id = s.submission_id
     LEFT JOIN vw_xml_ieda_subject isx ON isx.submission_id = s.submission_id
     LEFT JOIN vw_xml_ecl_subject esx ON esx.submission_id = s.submission_id
     LEFT JOIN vw_submission_geom msg ON msg.s_id = s.submission_id;

-- ALTER TABLE public."vw_datacite_xml_generator_withStatus"
  -- OWNER TO postgres;
COMMENT ON VIEW public."vw_datacite_xml_generator_withStatus"
  IS 'submission_id, status_id, xml  tuples. Allows selection of submitted (status=1) vs. published (status=2) records. Otherwise identical to vw_datacite_xml_generator';

