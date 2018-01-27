-- View: public.vw_submission_cruise_xml

-- DROP VIEW public.vw_submission_cruise_xml;

CREATE OR REPLACE VIEW public.vw_submission_cruise_xml AS 
 SELECT relsub.submission_id AS s_id,
    xmlagg(XMLELEMENT(NAME "relatedIdentifier", XMLATTRIBUTES('DOI'::text AS "relatedIdentifierType", 'IsDerivedFrom'::text AS "relationType", 'research cruise'::text AS "relatedMetadataScheme"), relsub.rdoi)) AS xmlrelcruise
   FROM ( SELECT s.submission_id,
            bsc.*::bridge_submission_cruise AS cruise_id,
            bsc.cruise_doi AS rdoi
           FROM bridge_submission_cruise bsc,
            submissions s
          WHERE bsc.ecl_id = s.submission_id::text) relsub
  GROUP BY relsub.submission_id;

ALTER TABLE public.vw_submission_cruise_xml
  OWNER TO postgres;
COMMENT ON VIEW public.vw_submission_cruise_xml
  IS 'Join bridge_submission_cruise and submisions to generate DataCite relatedIdentifeir XML for correlation of submissions with cruises, using cruise DOIs from Bob Arko. ';
