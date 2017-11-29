--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.3
-- Dumped by pg_dump version 10.0

-- Started on 2017-11-15 11:36:52

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
-- TOC entry 239 (class 1259 OID 134562)
-- Name: keyword_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE keyword_type (
    keyword_type_id text NOT NULL,
    keyword_type_label text NOT NULL,
    keyword_type_description text,
    keyword_type_source text
);


ALTER TABLE keyword_type OWNER TO postgres;

--
-- TOC entry 2583 (class 0 OID 0)
-- Dependencies: 239
-- Name: TABLE keyword_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE keyword_type IS 'classifiers for keywords, use to group in user interface facets.';


--
-- TOC entry 2584 (class 0 OID 0)
-- Dependencies: 239
-- Name: COLUMN keyword_type.keyword_type_description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN keyword_type.keyword_type_description IS 'explanation of what the category is supposed to include';


--
-- TOC entry 2585 (class 0 OID 0)
-- Dependencies: 239
-- Name: COLUMN keyword_type.keyword_type_source; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN keyword_type.keyword_type_source IS 'text indicating where the keyword category originated.';


--
-- TOC entry 2578 (class 0 OID 134562)
-- Dependencies: 239
-- Data for Name: keyword_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0001', 'keyword', 'generic tag', 'USAP type');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0002', 'sensor', 'mapped to instrument type', 'USAP type');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0003', 'platform', 'container for multiple instruments, location mutable', 'USAP type');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0004', 'initiative', 'generalize project, cruise, expedition', 'USAP type');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0005', 'program', 'fixed purpose, multiple projects/organizations', 'USAP type');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0006', 'place', 'where is it--instance, not notion', 'USAP type');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0007', 'parameter', NULL, 'USAP type');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0008', 'IEDA Feature of Interest', 'generic or categorical physical settings', 'IEDA type');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0009', 'IEDA Data Type', NULL, 'IEDA type');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0010', 'IEDA Topic', 'what is it about', 'IEDA type');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0012', 'process', NULL, 'USAP compilation');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0013', 'instrument', NULL, 'USAP compilation');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0015', 'facility', 'fixed location', 'USAP compilation');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0017', 'project', NULL, 'USAP compilation');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0018', 'method', NULL, 'USAP compilation');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0021', 'constituent', NULL, 'USAP compilation');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0024', 'environment', NULL, 'USAP compilation');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0025', 'sampling feature', NULL, 'USAP compilation');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0026', 'Feature Instance', 'particular instances of features that are subject of a resource', 'USAP compilation');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0027', 'person', NULL, 'USAP compilation');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0028', 'organization', 'fixed purpose and members', 'USAP compilation');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0029', 'datset identifier', 'In some cases, identifiers for datasets from other contexts have been put in keyword fields. These should get moved to alternate identifier metadata elements with som indication of their authority context.', 'USAP compilation');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0030', 'grant identifier', NULL, 'USAP compilation');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0031', 'topic detail', NULL, 'USAP compilation');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0032', 'cruise', 'fixed platform and time interval', 'add to USAP from ECL compilation');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0033', 'database', NULL, 'add to USAP from ECL compilation');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0034', 'geochronology', NULL, 'add to USAP from ECL compilation');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0035', 'identifier', 'use dataset identifier', 'add to USAP from ECL compilation');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0036', 'isotopes', NULL, 'add to USAP from ECL compilation');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0037', 'living thing', NULL, 'add to USAP from ECL compilation');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0038', 'material', NULL, 'add to USAP from ECL compilation');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0039', 'subject', NULL, 'add to USAP from ECL compilation');
INSERT INTO keyword_type (keyword_type_id, keyword_type_label, keyword_type_description, keyword_type_source) VALUES ('kt-0040', 'data type', 'Data types more specific or out of scope of IEDA Data Types.', 'add to USAP from ECL compilation');


--
-- TOC entry 2440 (class 2606 OID 134569)
-- Name: keyword_type keyword_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY keyword_type
    ADD CONSTRAINT keyword_type_pkey PRIMARY KEY (keyword_type_id);


-- Completed on 2017-11-15 11:36:53

--
-- PostgreSQL database dump complete
--

