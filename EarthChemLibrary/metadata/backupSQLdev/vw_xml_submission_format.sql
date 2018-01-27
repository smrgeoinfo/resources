-- View: public.mvw_xml_submission_format

-- DROP VIEW public.mvw_xml_submission_format;

CREATE  VIEW public.vw_xml_submission_format AS 
 SELECT msf.submission_id AS s_id,
    xmlagg(XMLELEMENT(NAME format, concat(msf.data_file_format, '  '::text, msf.data_file_format_name))) AS xmlformat
   FROM ( SELECT DISTINCT s.submission_id,
            dff.data_file_format,
            dff.data_file_format_name
           FROM submissions s,
            dataset_file_list dfl,
            data_file_formats dff
          WHERE s.submission_id = dfl.submission_id AND dfl.data_file_format_id = dff.data_file_format_id) msf
  GROUP BY msf.submission_id
WITH DATA;

ALTER TABLE public.vw_xml_submission_format
  OWNER TO postgres;
COMMENT ON VIEW public.vw_xml_submission_format
  IS 'Joins submissions, dataset_file_list and data_file_formats to generate xml element ''format'' containing a list of all the file formats associated with the submission.  File order is not preserved.';
