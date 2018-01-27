
 SELECT s.submission_id,
    xmlagg(
		XMLELEMENT(NAME subject, 
			XMLATTRIBUTES(kt.keyword_type_label AS "subjectScheme"), ik.ikeyword_label) 
		ORDER BY kt.keyword_type_label
	) AS subject_xml
   FROM submissions s join submission_keyword_map skm on s.submission_id = skm.submission_id
     join iedakeywords ik on skm.keyword_id = ik.ikeyword_id
     join keyword_type kt on ik.ikeyword_type_id = kt.keyword_type_id
  GROUP BY s.submission_id;