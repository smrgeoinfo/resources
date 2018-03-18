-- SMR 2017-10-17 split the script into data loader and query generator
-- drop all the existing queries when start--

/* !!!!!!!!! SO BE SURE TO SYNC any changes YOU MADE in the database with this file 
 before you run it OR YOU WILL LOSE YOUR WORK!!

 This SQL creates a set of queries that access tables in the USAP-DC database 
 

-- SMR 2018-03-06  script was written in January, but didn't insert header, insert now

queries to generate XML. See comments in the create scripts for the queries for 
	additional documentation
	--    vw_creator_xml
	--    vw_usapkeyword_xml
	--    vw_iedakeyword_xml
	--    vw_date_xml
	--    vw_referencelink_xml
	--    vw_geolocation_xml
	--    vw_locationbox_xml
	--    vw_locationpoint_xml
	--    vw_award_xml
	

	-- queries that generate final XML docs
	--    generate_datacite_xml
	
CHANGELOG:
2018-03-06-- change logic for publisher to make it always 'U.S. Antarctic Program (USAP) Data Center'
2018-03-07-- change field name in  generate_datacite_xml from dataCiteXML to datacitexml 
	
*/

--First clean up existing queries, all will be replaced.
DROP VIEW if exists public."vw_creator_xml" CASCADE;
DROP VIEW if exists public."vw_usapkeyword_xml" CASCADE;
DROP VIEW if exists public."vw_iedakeyword_xml" CASCADE;
DROP VIEW if exists public."vw_date_xml" CASCADE;
DROP VIEW if exists public."vw_referencelink_xml" CASCADE;
DROP VIEW if exists public."vw_geolocation_xml" CASCADE;
DROP VIEW if exists public."vw_locationbox_xml" CASCADE;
DROP VIEW if exists public."vw_locationpoint_xml" CASCADE;
DROP VIEW if exists public."vw_award_xml" CASCADE;

DROP VIEW if exists public."generate_datacite_xml" CASCADE;

--



-- View: public."vw _creator_xml"
-- aggregates author list to set of DataCite creator elements.
-- uses e-mail, orcid as the name identifier and
-- postal address for affiliation (if those are present)
CREATE OR REPLACE VIEW public."vw_creator_xml" AS
SELECT dper.dataset_id AS d_id,
    xmlagg(XMLELEMENT(NAME creator, 
		XMLELEMENT(NAME "creatorName", 
			INITCAP(btrim(p.id))), 
		XMLELEMENT(NAME "givenName", 
			INITCAP(btrim(concat(p.first_name, ' ', p.middle_name)))), 
		XMLELEMENT(NAME "familyName", INITCAP(btrim(p.last_name))),
        CASE
            WHEN p.email IS NOT NULL AND p.email <> ''::text THEN 
		XMLELEMENT(NAME "nameIdentifier", XMLATTRIBUTES('e-mail address'::text AS "nameIdentifierScheme"), concat('mailto:'::text, p.email))
            ELSE NULL::xml
        END,
        CASE
            WHEN p.id_orcid IS NOT NULL AND p.id_orcid <> ''::text THEN 
		XMLELEMENT(NAME "nameIdentifier", XMLATTRIBUTES('ORCID'::text AS "nameIdentifierScheme"), concat('ORCID:'::text,p.id_orcid))
            ELSE NULL::xml
        END,
        CASE
            WHEN (p.address IS NOT NULL AND p.address <> ''::text)
			OR (p.city IS NOT NULL AND p.city <> ''::text)
			OR (p.country IS NOT NULL AND p.country <> ''::text) Then
		XMLELEMENT(NAME "affiliation",  concat(
			CASE
				WHEN p.address IS NOT NULL AND p.address <> ''::text THEN 
					concat(btrim(p.address),', '::text)
				ELSE NULL::text
			END, 
			CASE
				WHEN p.city IS NOT NULL AND p.city <> ''::text THEN 
					concat(btrim(p.city),', '::text)
				ELSE NULL::text
			END, 
			CASE
				WHEN p.state IS NOT NULL AND p.state <> ''::text THEN 
					concat(btrim(p.state),', '::text)
				ELSE NULL::text
			END, 
			CASE
				WHEN p.zip IS NOT NULL AND p.zip <> ''::text THEN 
					concat(btrim(p.zip),', '::text)
				ELSE NULL::text
			END, 
			CASE
				WHEN p.country IS NOT NULL AND p.country <> ''::text THEN 
					concat(btrim(p.country))
				ELSE NULL::text
			END
		))
            ELSE NULL::xml
        END
        )) AS xmlcreator
   FROM dataset_person_map dper
        LEFT JOIN person p ON p.id = dper.person_id
     
  GROUP BY dper.dataset_id;
COMMENT ON VIEW public."vw_creator_xml"
    IS 'Query assembles the persons linked to the usap dataset; address information is in affiliation. e-mail and ORCID, if present are included as name identifiers.  Note that the author order is indeterminate.';

-- View: public."vw_usapkeyword_xml"
CREATE OR REPLACE VIEW public."vw_usapkeyword_xml" AS
 SELECT d.id AS d_id,
    xmlagg(XMLELEMENT(NAME subject, 
	   XMLATTRIBUTES(lower(kt.keyword_type_label) AS "subjectScheme"), uk.keyword_label) 
	    ORDER BY kt.keyword_type_label, uk.keyword_label) AS keyword_xml
   FROM dataset d,
    dataset_keyword_map dkm,
    keyword_usap uk,
    keyword_type kt
  WHERE d.id = dkm.dataset_id 
     AND dkm.keyword_id = uk.keyword_id 
     AND uk.keyword_type_id = kt.keyword_type_id
	 AND kt.keyword_type_label <> 'place'::text
  GROUP BY d.id;
COMMENT ON VIEW public."vw_usapkeyword_xml"
    IS 'generate keywords for initiative, platform, program, curatorLocation, and curatorKeywords from new amalgamated keyword list and correlation table. usapkeywords that are not type place go into datacite subject';

-- View: public."vw_iedakeyword_xml"
CREATE OR REPLACE VIEW public."vw_iedakeyword_xml" AS
 SELECT d.id AS d_id,
    xmlagg(XMLELEMENT(NAME subject, XMLATTRIBUTES(kt.keyword_type_label AS "subjectScheme"), ik.keyword_label) ORDER BY kt.keyword_type_label, ik.keyword_label) AS keyword_xml
   FROM dataset d,
    dataset_keyword_map dkm,
    keyword_ieda ik,
    keyword_type kt
  WHERE d.id = dkm.dataset_id AND dkm.keyword_id = ik.keyword_id AND ik.keyword_type_id = kt.keyword_type_id
  GROUP BY d.id;
COMMENT ON VIEW public."vw_iedakeyword_xml"
    IS 'generate subject elements for ieda keywords associated with each dataset.';

-- View: public."vw_date_xml"
CREATE OR REPLACE VIEW public."vw_date_xml" AS
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
COMMENT ON VIEW public."vw_date_xml"
    IS 'This is the time interval for data collection; make date type ''Collected''';

-- View: public."vw_referencelink_xml"
CREATE OR REPLACE VIEW public."vw_referencelink_xml" AS
 SELECT dref.dataset_id AS d_id,
    xmlagg(XMLELEMENT(NAME "relatedIdentifier", XMLATTRIBUTES('URN'::text AS "relatedIdentifierType", 'IsReferencedBy'::text AS "relationType"), btrim(dref.reference)) ORDER BY dref.reference) AS reference_xml
   FROM dataset d,
    dataset_reference_map dref
  WHERE dref.reference IS NOT NULL AND dref.reference <> ''::text AND d.id = dref.dataset_id
  GROUP BY dref.dataset_id;
COMMENT ON VIEW public."vw_referencelink_xml"
    IS 'use citation in reference table as a related identifier. The USAP database doesn''t make relationship of reference to the dataset clear.';

-- View: public."vw_geolocation_xml"
CREATE OR REPLACE VIEW public."vw_geolocation_xml" AS
 SELECT d.id AS d_id,
    xmlagg(XMLELEMENT(NAME "geoLocation", XMLELEMENT(NAME "geoLocationPlace", uk.keyword_label)) ORDER BY uk.keyword_label) AS location_xml
   FROM dataset d,
    dataset_keyword_map dkm,
    keyword_usap uk,
    keyword_type kt
  WHERE d.id = dkm.dataset_id 
     AND dkm.keyword_id = uk.keyword_id 
     AND uk.keyword_type_id = kt.keyword_type_id
	 AND kt.keyword_type_label = 'place'::text
  GROUP BY d.id;
COMMENT ON VIEW public."vw_geolocation_xml"
    IS 'construction geoLocation xml elements with place keyword type from usapkeyword table. Put place keywords in the datacite geoLocationPlace element.'; 

-- View: public."vw_locationbox_xml"
CREATE OR REPLACE VIEW public."vw_locationbox_xml" AS
 SELECT d.id AS d_id,
    xmlagg(XMLELEMENT(NAME "geoLocation", XMLELEMENT(NAME "geoLocationBox", XMLELEMENT(NAME "westBoundLongitude", dsm.west), XMLELEMENT(NAME "eastBoundLongitude", dsm.east), XMLELEMENT(NAME "southBoundLatitude", dsm.south), XMLELEMENT(NAME "northBoundLatitude", dsm.north)))) AS boxlocation_xml
   FROM dataset d,
    dataset_spatial_map dsm
  WHERE d.id = dsm.dataset_id AND dsm.west <> dsm.east AND dsm.north <> dsm.south AND dsm.east < 180::double precision AND dsm.west > '-180'::integer::double precision
  GROUP BY d.id;
COMMENT ON VIEW public."vw_locationbox_xml"
    IS 'geoLocationBox element; E-W and N-S coordinates must be different; also skip boxes that include all of polar region.';

-- View: public."vw_locationpoint_xml"
CREATE OR REPLACE VIEW public."vw_locationpoint_xml" AS
 SELECT d.id AS d_id,
    xmlagg(XMLELEMENT(NAME "geoLocation", XMLELEMENT(NAME "geoLocationPoint", XMLELEMENT(NAME "pointLongitude", dsm.west), XMLELEMENT(NAME "pointLatitude", dsm.north)))) AS pointlocation_xml
   FROM dataset d,
    dataset_spatial_map dsm
  WHERE d.id = dsm.dataset_id AND dsm.west = dsm.east AND dsm.north = dsm.south AND dsm.east < 180::double precision AND dsm.west > '-180'::integer::double precision
  GROUP BY d.id;
COMMENT ON VIEW public."vw_locationpoint_xml"
    IS 'geoLocationPoint, E-W and N-S coordinates are equal; Ignores east long < 180 and west long > -180 ';

-- View: public."vw_award_xml"
CREATE OR REPLACE VIEW public."vw_award_xml" AS
 SELECT daw.dataset_id AS d_id,
    xmlagg(XMLELEMENT(NAME "fundingReference", XMLELEMENT(NAME "funderName", concat('NSF:'::text, aw.dir, ':'::text, aw.div, ':'::text, apm.program_id)), XMLELEMENT(NAME "awardNumber", aw.award), XMLELEMENT(NAME "awardTitle", aw.title)) ORDER BY daw.dataset_id) AS award_xml
   FROM dataset_award_map daw
     LEFT JOIN award aw ON daw.award_id = aw.award
     LEFT JOIN award_program_map apm ON aw.award = apm.award_id
  WHERE apm.award_id <> 'XXXXXXX'::text
  GROUP BY daw.dataset_id;
COMMENT ON VIEW public."vw_award_xml"
    IS 'generate fundingReference element from award and related tables';



	
CREATE OR REPLACE VIEW public."generate_datacite_xml" AS
select d.id, d.status_id,
XMLROOT(XMLELEMENT(NAME resource, XMLATTRIBUTES('http://datacite.org/schema/kernel-4' AS xmlns, 'http://www.w3.org/2001/XMLSchema-instance' AS "xmlns:xsi", 'http://datacite.org/schema/kernel-4 http://schema.datacite.org/meta/kernel-4/metadata.xsd' AS "xsi:schemaLocation"), 

   XMLELEMENT(NAME "identifier", XMLATTRIBUTES(
          CASE
            WHEN d.doi IS NOT NULL AND d.doi::text <> ''::text THEN 
		'DOI'::text
            ELSE 
                'Other'::text 
           END
         AS "identifierType"),
         CASE
            WHEN d.doi IS NOT NULL AND d.doi::text <> ''::text THEN 
		 ltrim(d.doi::text)
            ELSE   
                concat('urn:usap-dc:metadata:'::text, d.id)
         END),
   XMLElement(Name "creators",
      CASE
         WHEN vcr.xmlcreator is not NULL THEN
		vcr.xmlcreator
	 WHEN d.creator is not null and d.creator <>''::text THEN
	    XMLELEMENT(NAME "creator", XMLELEMENT(NAME "creatorName", d.creator))
	 ELSE 
	    XMLELEMENT(NAME "creator", XMLELEMENT(NAME "creatorName",'missing'::text))
      END),
   XMLelement(Name titles,
   XMLElement(Name title, d.title)),
   XMLElement(Name publisher, 'U.S. Antarctic Program (USAP) Data Center'::text ),
   XMLELEMENT(NAME "publicationYear", "left"(d.release_date::text, 4)),
   XMLELEMENT(NAME "resourceType", XMLATTRIBUTES('Dataset'::text AS "resourceTypeGeneral"),'Dataset'::text),
   XMLELEMENT(NAME "subjects",vuk.keyword_xml, vik.keyword_xml),
   XMLElement(Name "dates", vda.date_xml,
      CASE
         WHEN d.release_date is not null then
	   XMLELEMENT(NAME "date", XMLATTRIBUTES('Available'::text AS "dateType"), d.release_date)
      END
   ),
   XMLELEMENT(NAME "language", 'eng'::text),
   XMLELEMENT(NAME "alternateIdentifiers", 
	CASE
	   WHEN ddm.dif_id is not NULL and ddm.dif_id<>'' THEN
	      XMLELEMENT(NAME "alternateIdentifier",
	         XMLAttributes('dif_id'::text AS "alternateIdentifierType"), ddm.dif_id)
	   ELSE NULL::xml
	END,
	CASE
           WHEN d.series_name is not NULL and d.series_name<>'' THEN
	      XMLELEMENT(NAME "alternateIdentifier",
	         XMLAttributes('series name'::text AS "alternateIdentifierType"), d.series_name)
	   ELSE NULL::xml
	END,
	XMLELEMENT(NAME "alternateIdentifier",
           XMLAttributes('landing page'::text AS "alternateIdentifierType"), 
             concat('http://www.usap-dc.org/view/dataset/'::text, d.id))
	),
   XMLELEMENT(NAME "relatedIdentifiers",vrl.reference_xml),
   Case
     WHEN d.version is not null and d.version<>'' THEN
        XMLELEMENT(NAME "version", d.version)
     else NULL::xml
   END,
   XMLELEMENT(NAME "rightsList", 
      XMLELEMENT(NAME "rights", XMLATTRIBUTES('https://creativecommons.org/licenses/by-nc-sa/3.0/us/'::text AS "rightsURI"), 
        'Creative Commons Attribution-NonCommercial-Share Alike 3.0 United States [CC BY-NC-SA 3.0]'::text)),
   XMLELEMENT(NAME "descriptions",
      XMLELEMENT(NAME "description", XMLATTRIBUTES('Abstract'::text AS "descriptionType"),d.abstract)),
   XMLELEMENT(NAME "geoLocations", vlo.location_xml, vlp.pointlocation_xml, vlb.boxlocation_xml),
   XMLELEMENT(NAME "fundingReferences", vaw.award_xml)
), VERSION '1.0'::text ) AS datacitexml  

From dataset d 
   left join "vw_creator_xml" vcr on d.id=vcr.d_id 
   
   left join "vw_usapkeyword_xml" vuk on d.id=vuk.d_id 
   left join "vw_iedakeyword_xml" vik on d.id=vik.d_id 
   
   left join "vw_date_xml" vda on d.id=vda.d_id
   left join "vw_referencelink_xml" vrl on d.id=vrl.d_id
   left join "vw_geolocation_xml" vlo on d.id=vlo.d_id
   left join "vw_locationbox_xml" vlb on d.id=vlb.d_id
   left join "vw_locationpoint_xml" vlp on d.id=vlp.d_id
   left join "vw_award_xml" vaw on d.id=vaw.d_id
   left join "dataset_dif_map" ddm on d.id=ddm.dataset_id
where d.url is not null and d.url <> '';
COMMENT ON VIEW public."generate_datacite_xml"
    IS 'This query assembles component query fragments for repeated elements and extracts databse content for single valued elements, to generate a set of records with 3 fields: the dataset ID, the dataset status ID, and an xml field containing the DataCite XML record. Inclusion of status allows filtering results for only published
	records.';