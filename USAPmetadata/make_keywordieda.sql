--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.3
-- Dumped by pg_dump version 10.0

-- Started on 2017-11-15 11:41:49

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 238 (class 1259 OID 134556)
-- Name: keyword_ieda; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE keyword_ieda (
    keyword_id text,
    keyword_label text NOT NULL,
    keyword_type_id text,
    keyword_description text
);


ALTER TABLE keyword_ieda OWNER TO postgres;

--
-- TOC entry 2581 (class 0 OID 0)
-- Dependencies: 238
-- Name: TABLE keyword_ieda; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE keyword_ieda IS 'unique values for new IEDA keywords, created october 2017.';


--
-- TOC entry 2582 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN keyword_ieda.keyword_description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN keyword_ieda.keyword_description IS 'text explanation/scope notes for usage of term ';


--
-- TOC entry 2576 (class 0 OID 134556)
-- Dependencies: 238
-- Data for Name: keyword_ieda; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0001', 'Antarctica', 'kt-0008', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0002', 'Arctic', 'kt-0008', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0049', 'Atmosphere', 'kt-0010', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0003', 'Back Arc Basin', 'kt-0008', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0023', 'Bathymetry/Topography', 'kt-0009', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0024', 'Biology', 'kt-0009', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0050', 'Biosphere', 'kt-0010', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0025', 'Chemistry:Fluid', 'kt-0009', 'includes gas, water, and other liquids');
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0062', 'Chemistry:Ice', 'kt-0008', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0026', 'Chemistry:Rock', 'kt-0009', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0027', 'Chemistry:Sediment', 'kt-0009', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0028', 'Chemistry:Soil', 'kt-0009', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0004', 'Continental Arc', 'kt-0008', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0005', 'Continental Margin', 'kt-0008', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0006', 'Continental Rift', 'kt-0008', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0051', 'Cosmos', 'kt-0010', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0007', 'Craton', 'kt-0008', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0008', 'Critical Zone', 'kt-0008', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0052', 'Cryosphere', 'kt-0010', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0053', 'Geochemistry', 'kt-0010', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0029', 'Geochronology', 'kt-0009', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0030', 'Geology/Geophysics - Other', 'kt-0009', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0009', 'Glaciers/Ice Sheet', 'kt-0008', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0031', 'Glaciology', 'kt-0009', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0010', 'Global', 'kt-0008', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0054', 'Human Dimensions', 'kt-0010', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0011', 'Hydrothermal Vent', 'kt-0008', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0032', 'Ice Core Records', 'kt-0009', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0061', 'IntraContinental Magmatism', 'kt-0008', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0012', 'Island Arc', 'kt-0008', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0033', 'Kinetics', 'kt-0009', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0055', 'Marine Geoscience', 'kt-0010', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0013', 'Marine Sediments', 'kt-0008', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0014', 'Meteorite', 'kt-0008', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0063', 'Meteorology', 'kt-0009', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0034', 'Mineralogy', 'kt-0009', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0015', 'Moon', 'kt-0008', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0035', 'Navigation', 'kt-0009', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0056', 'Near Surface Environment', 'kt-0010', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0016', 'Ocean Island/Plateau', 'kt-0008', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0057', 'Oceans', 'kt-0010', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0036', 'Paleoclimate', 'kt-0009', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0037', 'Petrography', 'kt-0009', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0042', 'Photo/Video', 'kt-0009', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0038', 'Physical Oceanography', 'kt-0009', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0064', 'Physical Properties', 'kt-0008', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0039', 'Potential Field', 'kt-0009', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0065', 'Radar', 'kt-0008', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0066', 'Remote Sensing imagery', 'kt-0008', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0040', 'Sample/Collection Description', 'kt-0009', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0017', 'Sea Ice', 'kt-0008', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0041', 'Sea Surface', 'kt-0009', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0043', 'Seismic Reflection:MCS', 'kt-0009', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0044', 'Seismic Reflection:SCS', 'kt-0009', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0045', 'Seismic Refraction', 'kt-0009', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0046', 'Sidescan Sonar', 'kt-0009', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0067', 'Snow/Ice', 'kt-0009', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0058', 'Solid Earth', 'kt-0010', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0018', 'Southern Ocean', 'kt-0008', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0019', 'Spreading Center', 'kt-0008', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0020', 'Subduction Zone', 'kt-0008', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0059', 'Terrestrial Hydrosphere', 'kt-0010', NULL);
INSERT INTO keyword_ieda (keyword_id, keyword_label, keyword_type_id, keyword_description) VALUES ('ik-0047', 'Thermodynamics', 'kt-0009', NULL);


-- Completed on 2017-11-15 11:41:49

--
-- PostgreSQL database dump complete
--

