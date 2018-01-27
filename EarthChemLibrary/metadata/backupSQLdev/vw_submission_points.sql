-- View: public.mvw_submission_points

-- DROP VIEW public.mvw_submission_points;

CREATE VIEW public.vw_submission_points AS 
 SELECT distinct s.submission_id AS s_id,
     (st_dump(dfg.geometry)).geom AS the_geom,
    geometrytype((st_dump(dfg.geometry)).geom) AS type 
   FROM  submissions s 
	left join dataset_file_list dfl  on s.submission_id = dfl.submission_id
	left join dataset_file_geometry dfg on dfl.dataset_file_list_id = dfg.dataset_file_list_id  

  WHERE   

   dfg.geometry IS NOT NULL AND geometrytype(dfg.geometry) = 'POINT'::text
WITH DATA
;

ALTER TABLE public.vw_submission_points
  OWNER TO postgres;
