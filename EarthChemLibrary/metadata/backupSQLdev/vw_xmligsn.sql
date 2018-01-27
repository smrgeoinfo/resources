-- View: public.vw_xmligsn

-- DROP VIEW public.vw_xmligsn;

CREATE OR REPLACE VIEW public.vw_xmligsn AS 
 SELECT vsi.submission_id AS s_id,
    xmlagg(
		XMLELEMENT(NAME "relatedIdentifier", 
			XMLATTRIBUTES('IGSN'::text AS "relatedIdentifierType", 'IsDerivedFrom'::text AS "relationType"), 
			concat('igsn:'::text, vsi.igsn)) 
		ORDER BY vsi.submission_id
	) AS xmligsn
   FROM vw_submission_igsn vsi
  GROUP BY vsi.submission_id;

ALTER TABLE public.vw_xmligsn
  OWNER TO postgres;
COMMENT ON VIEW public.vw_xmligsn
  IS 'aggregate igsn associated with a submission';
