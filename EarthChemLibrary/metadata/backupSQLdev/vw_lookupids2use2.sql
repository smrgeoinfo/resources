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
          ORDER BY (min(bpnd_1.person_num))) useme 
          ON useme.last_name = bpnd.last_name 
          AND useme.first_name = bpnd.first_name 
          AND useme.mi = bpnd.mi 
          AND useme.email = bpnd.email
union
select 
pe.person_num,
    pe.person_num use_person_num,
    pe.last_name,
    pe.first_name,
    pe.middle_initial mi,
    pe.email,
    null::text as iaf_guid
 from  person pe 
left join bridge_person_num_distinctname bp on pe.person_num = bp.person_num  
where bp.person_num is null and pe.last_name is not null and length(pe.last_name)>0

order by person_num
 ;