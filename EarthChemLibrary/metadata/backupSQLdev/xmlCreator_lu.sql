-- Materialized View: public.xmlcreator_lu

-- DROP MATERIALIZED VIEW public.xmlcreator_lu;

CREATE MATERIALIZED VIEW public.xmlcreator_lu AS 
 SELECT al.submission_id AS s_id,
    xmlagg(XMLELEMENT(NAME creator, 
		XMLELEMENT(NAME "creatorName", 
			btrim(concat(litu.last_name, ',', litu.first_name, ' ', litu.mi))), 
		XMLELEMENT(NAME "givenName", 
			btrim(concat(litu.first_name, ' ', litu.mi))), 
		XMLELEMENT(NAME "familyName", btrim(litu.last_name)),
        CASE
            WHEN litu.email IS NOT NULL AND litu.email <> ''::text THEN 
				XMLELEMENT(NAME "nameIdentifier", XMLATTRIBUTES('e-mail address'::text AS "nameIdentifierScheme"), concat('mailto:'::text, litu.email))
            ELSE NULL::xml
        END, 
		( SELECT theids.xmlnameid
           FROM ( SELECT bpnd.person_num,
                    xmlagg(
						XMLELEMENT(NAME "nameIdentifier", XMLATTRIBUTES(pei.external_identifier_schema AS "nameIdentifierScheme"), pei.external_identifier_value)) AS xmlnameid
                   FROM person_external_identifier pei
                     LEFT JOIN bridge_person_num_distinctname bpnd ON pei.person_id::text = bpnd.iaf_guid
                  GROUP BY bpnd.person_num) theids
          WHERE theids.person_num = p.person_num), 
		 XMLELEMENT(NAME "nameIdentifier", XMLATTRIBUTES('grl person_num'::text AS "nameIdentifierScheme"), concat('urn:grl:person:'::text, litu.use_person_num))) ORDER BY al.author_order) AS xmlcreator
   FROM author_list al
     LEFT JOIN person p ON p.person_num = al.person_num
     JOIN vw_lookup_ids2use litu ON p.person_num = litu.person_num
  GROUP BY al.submission_id
WITH DATA;

ALTER TABLE public.xmlcreator_lu
  OWNER TO postgres;
COMMENT ON MATERIALIZED VIEW public.xmlcreator_lu
  IS 'Joins author_list, person, person_external_identifier, bridge_person_num_distinctname and vw_lookup_ids2use to generate DataCite xml ''creator'' elements based on the author list for the submission.  Returns submission_id and xmlCreator';
