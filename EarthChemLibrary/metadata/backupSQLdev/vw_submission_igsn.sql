-- View: public.vw_submission_igsn

-- DROP VIEW public.vw_submission_igsn;

CREATE VIEW public.vw_submission_igsn AS 
 SELECT s.submission_id,
    dfei.external_identifier_name AS igsn,
    concat('https://app.geosamples.org/sample/igsn/'::text, dfei.external_identifier_name) AS landingpage
   FROM dataset_file_list dfl,
    submissions s,
    dataset_file_external_identifier dfei,
    external_identifier_system eis
  WHERE dfl.dataset_file_list_id = dfei.dataset_file_list_id AND s.submission_id = dfl.submission_id AND dfei.external_identifier_system_id = eis.external_identifier_system_id AND eis.external_identifier_system_name::text = 'IGSN'::text
  ORDER BY s.submission_id
WITH DATA;

ALTER TABLE public.vw_submission_igsn
  OWNER TO postgres;
COMMENT ON VIEW public.vw_submission_igsn
  IS 'link submission ID with IGSN and landing page URL';
