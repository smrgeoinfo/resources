-- View: public.vw_lookup_ids2use

-- DROP VIEW public.vw_lookup_ids2use;

CREATE OR REPLACE VIEW public.vw_lookup_ids2use AS 
 SELECT bpnd.person_num,
    useme.use_person_num,
    bpnd.last_name,
    bpnd.first_name,
    bpnd.mi,
    bpnd.email,
    bpnd.iaf_guid
   FROM bridge_person_num_distinctname bpnd
     JOIN ( SELECT min(bpnd_1.person_num) AS use_person_num,
            bpnd_1.last_name,
            bpnd_1.first_name,
            bpnd_1.mi,
            bpnd_1.email
           FROM bridge_person_num_distinctname bpnd_1
          GROUP BY bpnd_1.last_name, bpnd_1.first_name, bpnd_1.mi, bpnd_1.email
          ORDER BY (min(bpnd_1.person_num))) useme ON useme.last_name = bpnd.last_name AND useme.first_name = bpnd.first_name AND useme.mi = bpnd.mi AND useme.email = bpnd.email
  ORDER BY bpnd.person_num;

ALTER TABLE public.vw_lookup_ids2use
  OWNER TO postgres;
COMMENT ON VIEW public.vw_lookup_ids2use
  IS 'lookup table, maps current person.person_num to a de-duplicated person_num (the min person_num for the set of person_nums referring to the same person); also has column for email and iaf_guid. The iaf_guid is for lookup in  person_external_identifier to get Scopus and Orcid identifiers from Peng Ji''s work.';
