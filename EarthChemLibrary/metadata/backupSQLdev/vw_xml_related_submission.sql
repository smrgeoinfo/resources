-- View: public.vw_xml_related_submission

-- DROP VIEW public.vw_xml_related_submission;

CREATE VIEW public.vw_xml_related_submission AS 
 SELECT relsub.submission_id AS s_id,
    xmlagg(XMLELEMENT(NAME relatedidentifier, XMLATTRIBUTES('DOI'::text AS "relatedIdentifierType", relsub.type AS "relationType"), relsub.rdoi)) AS xmlrelsub
   FROM ( SELECT s.submission_id,
            dr.type,
            rs.dataset_doi AS rdoi
           FROM dataset_relation dr,
            submissions s,
            submissions rs
          WHERE dr.relation_id = rs.submission_id AND s.submission_id = dr.submission_id) relsub
  GROUP BY relsub.submission_id
WITH DATA;

ALTER TABLE public.vw_xml_related_submission
  OWNER TO postgres;
COMMENT ON VIEW public.vw_xml_related_submission
  IS 'generates xml for relatedidentifier elemetns in DataCite by joining  submisions and dataset_relations, returns the xml element and submission_Id.';
