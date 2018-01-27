-- View: public.xml_subject_datatype

-- DROP VIEW public.xml_subject_datatype;
-- Created by SMR 2017-09
-- SMR 2017-10-17 adapt to use new eclkeyword and iedakeyword tables


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

