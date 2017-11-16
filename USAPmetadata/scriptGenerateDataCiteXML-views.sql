
-- This script creates a set of queries to generate DataCite v4 xml records from 
-- the USAP DC database. 
-- component queries include vwCreator_xml, vwUSAPkeyword_xml, vwiedaKeyword_xml, vwDate_xml, 
--   vwReferenceLink_xml, vwGeoLocation_xml, vwLocationBox_xml, vwLocationPoint_xml,
--    vwAward_xml and dataset_dif_map
-- apparently much of the content in the USAP-dc database is not systematically updated
-- in the current (2017-10) workflow. Much of the content acquired from submitters
-- is kept in a separate text file.


-- start by removing existing queries
-- WARNING WARNING WARNING
-- this script will replace all the queries in the dependency chain
-- any changes not commited in the GitHub version will be LOST!!!!!!!!!

DROP VIEW if exists public."GenerateDataCite_xml2" CASCADE;
DROP VIEW if exists public."vwCreator_xml" CASCADE; 
DROP VIEW if exists public."vwAward_xml" CASCADE; 
DROP VIEW if exists public."vwLocationPoint_xml" CASCADE; 
DROP VIEW if exists public."vwLocationBox_xml" CASCADE; 
DROP VIEW if exists public."vwGeoLocation_xml" CASCADE; 
DROP VIEW if exists public."vwReferenceLink_xml" CASCADE; 
DROP VIEW if exists public."vwDate_xml" CASCADE; 
DROP VIEW if exists public."vwiedaKeyword_xml" CASCADE; 

-- View: public."vwCreator_xml"
-- 
CREATE OR REPLACE VIEW public."vwCreator_xml" AS
 SELECT dper.dataset_id AS d_id,
    xmlagg(XMLELEMENT(NAME creator, 
	   XMLELEMENT(NAME "creatorName", INITCAP(btrim(p.id))), 
	   XMLELEMENT(NAME "givenName", INITCAP(btrim(concat(p.first_name, ' ', p.middle_name)))), 
	   XMLELEMENT(NAME "familyName", INITCAP(btrim(p.last_name))),
        CASE
            WHEN p.email IS NOT NULL AND p.email <> ''::text THEN 
			   XMLELEMENT(NAME "nameIdentifier", XMLATTRIBUTES('e-mail address'::text AS "nameIdentifierScheme"), concat('mailto:'::text, p.email))
            ELSE NULL::xml
        END,
        CASE
            WHEN p.id_orcid IS NOT NULL AND p.id_orcid <> ''::text THEN 
			   XMLELEMENT(NAME "nameIdentifier", XMLATTRIBUTES('ORCID'::text AS "nameIdentifierScheme"), concat('ORCID:'::text, p.id_orcid))
            ELSE NULL::xml
        END,
        CASE
            WHEN p.address IS NOT NULL AND p.address <> ''::text OR p.city IS NOT NULL AND p.city <> ''::text OR p.country IS NOT NULL AND p.country <> ''::text THEN 
			XMLELEMENT(NAME affiliation, concat(
            CASE
                WHEN p.address IS NOT NULL AND p.address <> ''::text THEN concat(btrim(p.address), ', '::text)
                ELSE NULL::text
            END,
            CASE
                WHEN p.city IS NOT NULL AND p.city <> ''::text THEN concat(btrim(p.city), ', '::text)
                ELSE NULL::text
            END,
            CASE
                WHEN p.state IS NOT NULL AND p.state <> ''::text THEN concat(btrim(p.state), ', '::text)
                ELSE NULL::text
            END,
            CASE
                WHEN p.zip IS NOT NULL AND p.zip <> ''::text THEN concat(btrim(p.zip), ', '::text)
                ELSE NULL::text
            END,
            CASE
                WHEN p.country IS NOT NULL AND p.country <> ''::text THEN concat(btrim(p.country))
                ELSE NULL::text
            END))
            ELSE NULL::xml
        END)) AS xmlcreator
   FROM dataset_person_map dper
     LEFT JOIN person p ON p.id = dper.person_id
  GROUP BY dper.dataset_id;

ALTER TABLE public."vwCreator_xml"
    OWNER TO postgres;
COMMENT ON VIEW public."vwCreator_xml"
    IS 'Query assembles the persons linked to the usap dataset; address information is in affiliation. e-mail and ORCID, if present are included as name identifiers.  Note that the author order is indeterminate.';

-- View: public."vwiedaKeyword_xml"
-- 
CREATE OR REPLACE VIEW public."vwiedaKeyword_xml" AS
 SELECT d.id AS d_id,
    xmlagg(XMLELEMENT(NAME subject, XMLATTRIBUTES(kt.keyword_type_label AS "subjectScheme"), ik.ikeyword_label) ORDER BY kt.keyword_type_label, ik.ikeyword_label) AS keyword_xml
   FROM dataset d,
    dataset_keywordid_map dkm,
    iedakeywords ik,
    keyword_type kt
  WHERE d.id = dkm.dataset_id AND dkm.keyword_id = ik.ikeyword_id AND ik.ikeyword_type_id = kt.keyword_type_id
  GROUP BY d.id;

ALTER TABLE public."vwiedaKeyword_xml"
    OWNER TO postgres;
COMMENT ON VIEW public."vwiedaKeyword_xml"
    IS 'generate subject elements for iedata keywords associated with each dataset.';


-- View: public."vwDate_xml"
-- 
CREATE OR REPLACE VIEW public."vwDate_xml" AS
 SELECT dtem.dataset_id AS d_id,
    xmlagg(XMLELEMENT(NAME date, XMLATTRIBUTES('Collected'::text AS "dateType"), concat(dtem.start_date,
        CASE
            WHEN dtem.stop_date IS NOT NULL THEN concat('/'::text, dtem.stop_date)
            ELSE NULL::text
        END)) ORDER BY dtem.dataset_id) AS date_xml
   FROM dataset d,
    dataset_temporal_map dtem
  WHERE d.id = dtem.dataset_id
  GROUP BY dtem.dataset_id;

ALTER TABLE public."vwDate_xml"
    OWNER TO postgres;
COMMENT ON VIEW public."vwDate_xml"
    IS 'date xml objects date type ''Completed''';


-- View: public."vwReferenceLink_xml"
-- 
CREATE OR REPLACE VIEW public."vwReferenceLink_xml" AS
 SELECT dref.dataset_id AS d_id,
    xmlagg(XMLELEMENT(NAME "relatedIdentifier", XMLATTRIBUTES('URN'::text AS "relatedIdentifierType", 'IsReferencedBy'::text AS "relationType"), btrim(dref.reference)) ORDER BY dref.reference) AS reference_xml
   FROM dataset d,
    dataset_reference_map dref
  WHERE dref.reference IS NOT NULL AND dref.reference <> ''::text AND d.id = dref.dataset_id
  GROUP BY dref.dataset_id;

ALTER TABLE public."vwReferenceLink_xml"
    OWNER TO postgres;
COMMENT ON VIEW public."vwReferenceLink_xml"
    IS 'use citation in reference table as a related identifier. The USAP database doesn''t make relationship of reference to the dataset clear.';


-- View: public."vwGeoLocation_xml"
-- 
CREATE OR REPLACE VIEW public."vwGeoLocation_xml" AS
 SELECT d.id AS d_id,
    xmlagg(XMLELEMENT(NAME "geoLocation", XMLELEMENT(NAME "geoLocationPlace", concat(dlm.location_id,
        CASE
            WHEN dlm.detail IS NOT NULL AND dlm.detail = ''::text THEN NULL::text
            ELSE concat(' > '::text, dlm.detail)
        END))) ORDER BY dlm.location_id) AS location_xml
   FROM dataset d,
    dataset_location_map dlm
  WHERE d.id = dlm.dataset_id
  GROUP BY d.id;

ALTER TABLE public."vwGeoLocation_xml"
    OWNER TO postgres;
COMMENT ON VIEW public."vwGeoLocation_xml"
    IS 'construction geoLocation xml elements with place names from dataset_location_map table';


-- View: public."vwLocationBox_xml"
--
CREATE OR REPLACE VIEW public."vwLocationBox_xml" AS
 SELECT d.id AS d_id,
    xmlagg(XMLELEMENT(NAME "geoLocation", XMLELEMENT(NAME "geoLocationBox", XMLELEMENT(NAME "westBoundLongitude", dsm.west), XMLELEMENT(NAME "eastBoundLongitude", dsm.east), XMLELEMENT(NAME "southBoundLatitude", dsm.south), XMLELEMENT(NAME "northBoundLatitude", dsm.north)))) AS boxlocation_xml
   FROM dataset d,
    dataset_spatial_map dsm
  WHERE d.id = dsm.dataset_id AND dsm.west <> dsm.east AND dsm.north <> dsm.south AND dsm.east < 180::double precision AND dsm.west > '-180'::integer::double precision
  GROUP BY d.id;

ALTER TABLE public."vwLocationBox_xml"
    OWNER TO postgres;
COMMENT ON VIEW public."vwLocationBox_xml"
    IS 'geoLocationBox element; E-W and N-S coordinates must be different; also skip boxes that include all of polar region.';


-- View: public."vwLocationPoint_xml"
-- 
CREATE OR REPLACE VIEW public."vwLocationPoint_xml" AS
 SELECT d.id AS d_id,
    xmlagg(XMLELEMENT(NAME "geoLocation", XMLELEMENT(NAME "geoLocationPoint", XMLELEMENT(NAME "pointLongitude", dsm.west), XMLELEMENT(NAME "pointLatitude", dsm.north)))) AS pointlocation_xml
   FROM dataset d,
    dataset_spatial_map dsm
  WHERE d.id = dsm.dataset_id AND dsm.west = dsm.east AND dsm.north = dsm.south AND dsm.east < 180::double precision AND dsm.west > '-180'::integer::double precision
  GROUP BY d.id;

ALTER TABLE public."vwLocationPoint_xml"
    OWNER TO postgres;
COMMENT ON VIEW public."vwLocationPoint_xml"
    IS 'geoLocationPoint, E-W and N-S coordinates are equal; ';


-- View: public."vwAward_xml"
-- 
CREATE OR REPLACE VIEW public."vwAward_xml" AS
 SELECT daw.dataset_id AS d_id,
    xmlagg(XMLELEMENT(NAME "fundingReference", XMLELEMENT(NAME "funderName", concat('NSF:'::text, aw.dir, ':'::text, aw.div, ':'::text, apm.program_id)), XMLELEMENT(NAME "awardNumber", aw.award), XMLELEMENT(NAME "awardTitle", aw.title)) ORDER BY daw.dataset_id) AS award_xml
   FROM dataset_award_map daw
     LEFT JOIN award aw ON daw.award_id = aw.award
     LEFT JOIN award_program_map apm ON aw.award = apm.award_id
  WHERE apm.award_id <> 'XXXXXXX'::text
  GROUP BY daw.dataset_id;

ALTER TABLE public."vwAward_xml"
    OWNER TO postgres;
COMMENT ON VIEW public."vwAward_xml"
    IS 'generate fundingReference element from award and related tables';


-- View: public."GenerateDataCite_xml2
-- 
CREATE OR REPLACE VIEW public."GenerateDataCite_xml2" AS
 SELECT d.id,
    d.status_id,
    XMLROOT(XMLELEMENT(NAME resource, XMLATTRIBUTES('http://datacite.org/schema/kernel-4' AS xmlns, 'http://www.w3.org/2001/XMLSchema-instance' AS "xmlns:xsi", 'http://datacite.org/schema/kernel-4 http://schema.datacite.org/meta/kernel-4/metadata.xsd' AS "xsi:schemaLocation"), XMLELEMENT(NAME identifier, XMLATTRIBUTES(
        CASE
            WHEN d.doi IS NOT NULL AND d.doi <> ''::text THEN 'DOI'::text
            ELSE 'Other'::text
        END AS "identifierType"),
        CASE
            WHEN d.doi IS NOT NULL AND d.doi <> ''::text THEN ltrim(d.doi)
            ELSE concat('urn:usap-dc:metadata:'::text, d.id)
        END), XMLELEMENT(NAME creators,
        CASE
            WHEN vcr.xmlcreator IS NOT NULL THEN vcr.xmlcreator
            WHEN d.creator IS NOT NULL AND d.creator <> ''::text THEN XMLELEMENT(NAME creator, XMLELEMENT(NAME "creatorName", d.creator))
            ELSE XMLELEMENT(NAME creator, XMLELEMENT(NAME "creatorName", 'missing'::text))
        END), XMLELEMENT(NAME titles, XMLELEMENT(NAME title, d.title)),
        CASE
            WHEN d.publisher IS NOT NULL AND d.publisher <> ''::text THEN XMLELEMENT(NAME publisher, d.publisher)
            ELSE XMLELEMENT(NAME publisher, 'missing'::text)
        END, XMLELEMENT(NAME "publicationYear", "left"(d.release_date, 4)), XMLELEMENT(NAME "resourceType", XMLATTRIBUTES('Dataset'::text AS "resourceTypeGeneral"), 'Dataset'::text), XMLELEMENT(NAME subjects, vuk.keyword_xml, vik.keyword_xml), XMLELEMENT(NAME dates, vda.date_xml,
        CASE
            WHEN d.release_date IS NOT NULL THEN XMLELEMENT(NAME date, XMLATTRIBUTES('Available'::text AS "dateType"), d.release_date)
            ELSE NULL::xml
        END), XMLELEMENT(NAME language, 'eng'::text), XMLELEMENT(NAME "alternateIdentifiers",
        CASE
            WHEN ddm.dif_id IS NOT NULL AND ddm.dif_id <> ''::text THEN XMLELEMENT(NAME "alternateIdentifier", XMLATTRIBUTES('dif_id'::text AS "alternateIdentifierType"), ddm.dif_id)
            ELSE NULL::xml
        END,
        CASE
            WHEN d.series_name IS NOT NULL AND d.series_name <> ''::text THEN XMLELEMENT(NAME "alternateIdentifier", XMLATTRIBUTES('series name'::text AS "alternateIdentifierType"), d.series_name)
            ELSE NULL::xml
        END, XMLELEMENT(NAME "alternateIdentifier", XMLATTRIBUTES('landing page'::text AS "alternateIdentifierType"), concat('http://www.usap-dc.org/view/dataset/'::text, d.id))), XMLELEMENT(NAME "relatedIdentifiers", vrl.reference_xml),
        CASE
            WHEN d.version IS NOT NULL AND d.version <> ''::text THEN XMLELEMENT(NAME version, d.version)
            ELSE NULL::xml
        END, XMLELEMENT(NAME "rightsList", XMLELEMENT(NAME rights, XMLATTRIBUTES('https://creativecommons.org/licenses/by-nc-sa/3.0/us/'::text AS "rightsURI"), 'Creative Commons Attribution-NonCommercial-Share Alike 3.0 United States [CC BY-NC-SA 3.0]'::text)), XMLELEMENT(NAME descriptions, XMLELEMENT(NAME description, XMLATTRIBUTES('Abstract'::text AS "descriptionType"), d.abstract)), XMLELEMENT(NAME "geoLocations", vlo.location_xml, vlp.pointlocation_xml, vlb.boxlocation_xml), XMLELEMENT(NAME "fundingReferences", vaw.award_xml)), VERSION '1.0'::text) AS "dataCiteXML"
   FROM dataset d
     LEFT JOIN "vwCreator_xml" vcr ON d.id = vcr.d_id
     LEFT JOIN "vwUSAPkeyword_xml" vuk ON d.id = vuk.d_id
     LEFT JOIN "vwiedaKeyword_xml" vik ON d.id = vik.d_id
     LEFT JOIN "vwDate_xml" vda ON d.id = vda.d_id
     LEFT JOIN "vwReferenceLink_xml" vrl ON d.id = vrl.d_id
     LEFT JOIN "vwGeoLocation_xml" vlo ON d.id = vlo.d_id
     LEFT JOIN "vwLocationBox_xml" vlb ON d.id = vlb.d_id
     LEFT JOIN "vwLocationPoint_xml" vlp ON d.id = vlp.d_id
     LEFT JOIN "vwAward_xml" vaw ON d.id = vaw.d_id
     LEFT JOIN dataset_dif_map ddm ON d.id = ddm.dataset_id
  WHERE d.url IS NOT NULL AND d.url <> ''::text;

ALTER TABLE public."GenerateDataCite_xml2"
    OWNER TO postgres;
COMMENT ON VIEW public."GenerateDataCite_xml2"
    IS 'uses updated keywords';


