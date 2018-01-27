-- Materialized View: public.xml_subject_datatype

-- DROP MATERIALIZED VIEW public.xml_subject_datatype;

CREATE MATERIALIZED VIEW public.xml_subject_datatype AS 
 SELECT s.submission_id,
    xmlagg(
		XMLELEMENT(NAME subject, 
			XMLATTRIBUTES('dataType'::text AS "subjectScheme"), dt.data_type_name) 
		ORDER BY dtl.list_order
	) AS subject_xml
   FROM submissions s,
    data_type_list dtl,
    data_type dt 
  WHERE dtl.submission_id = s.submission_id AND dtl.data_type_id = dt.data_type_id
  GROUP BY s.submission_id
WITH DATA;

ALTER TABLE public.xml_subject_datatype
  OWNER TO postgres;
COMMENT ON MATERIALIZED VIEW public.xml_subject_datatype
  IS 'aggregates all data types in data_type_list associated with each submission, and generates a set of subject xml elements for DataCite output';
