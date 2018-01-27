-- View: public.vw_datacite_xml_generator

-- DROP VIEW public.vw_datacite_xml_generator;
--2017-10-17 adapt to use new eclkeyword and iedakeyword tables SMR
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

