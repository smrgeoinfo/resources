-- Materialized View: public.mvw_submission_geom

-- DROP MATERIALIZED VIEW public.mvw_submission_geom;

CREATE  VIEW public.vw_submission_geom AS 
 SELECT f.s_id,
    count(f.the_geom) AS count,
    st_multi(st_collect(f.the_geom)) AS multipt,
    st_astext(st_envelope(st_multi(st_collect(f.the_geom)))) AS bbox_txt,
    st_envelope(st_multi(st_collect(f.the_geom))) AS bbox_geom,
    geometrytype(st_envelope(st_multi(st_collect(f.the_geom)))) AS type
   FROM vw_submission_points f
  GROUP BY f.s_id;


ALTER TABLE public.vw_submission_geom
  OWNER TO postgres;
COMMENT ON  VIEW public.vw_submission_geom
  IS 'gather IGSN sample locations associated with a submission, return a multipoiint, bounding box as text, and a bounding box geometry.   If there is only one point, the bbox geometry is a point.
';
