--
-- PostgreSQL database dump
-- Dumped from Postgres version 9.3.5
-- Dumped by pg_dump version 10.0

-- Started on 2017-11-06 11:06:19
-- edited by SMR to make standalone script
-- start 2017-11-15

/* Run this script inside the database that is to contain the earthchem schema.
 the database must already exist
  * NOTE !!!!!!!!!!!
  * user ecdb_dev will be created if not already define 
*/



SET statement_timeout = 0;
SET lock_timeout = 0;
--SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--COMMENT ON DATABASE earthchemdb IS 'Schema template from PetDb Migration completed 2017-08-07.';

CREATE SCHEMA IF NOT EXISTS earthchem;

/*
thanks to https://stackoverflow.com/questions/8092086/create-postgresql-role-user-if-it-doesnt-exist
*/
DO
$body$
BEGIN
   IF NOT EXISTS (
      SELECT    *                   
      FROM   pg_catalog.pg_user
      WHERE  usename = 'ecdb_dev') THEN
	    CREATE USER ecdb_dev WITH
	      LOGIN
	      PASSWORD 'changeme'  
	      NOSUPERUSER
	      INHERIT
	      NOCREATEDB
	      CREATEROLE
	      NOREPLICATION;
   END IF;
END
$body$;

--ALTER DATABASE earthchemdb OWNER TO ecdb_dev;



ALTER SCHEMA earthchem OWNER TO ecdb_dev;

COMMENT ON SCHEMA earthchem IS 'ODM2 based schema for geochemical data';

-- schema used by postGIS; probably don't need for earthchemdb?
CREATE SCHEMA IF NOT EXISTS topology;
ALTER SCHEMA topology OWNER TO ecdb_dev;

ALTER USER ecdb_dev SET search_path TO earthchem, public, topology;

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;
COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;
COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions, encryption, from Jason Ash dev db; used for password encryption?';

SET search_path = earthchem, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;


/*  
**************************************************************************************
Create tables. Constraints are generated after tables have been defined, in next sections
of this script.
*/

CREATE TABLE action
(
    action_num integer NOT NULL,
    action_type_num integer NOT NULL,
    method_num integer NOT NULL,
    begin_date_time timestamp without time zone,
    begin_date_time_utc_offset integer,
    end_date_time timestamp without time zone,
    end_date_time_utc_offset integer,
    action_description character varying(2000) COLLATE pg_catalog."default",
    action_file_link character varying(2000) COLLATE pg_catalog."default",
    organization_num integer NOT NULL,
    action_name character varying(256) COLLATE pg_catalog."default",
    dataset_num integer,
	status integer DEFAULT 1 NOT NULL
)
WITH (OIDS = FALSE)
TABLESPACE pg_default;

ALTER TABLE earthchem.action
    OWNER to ecdb_dev;

COMMENT ON COLUMN earthchem.action.action_description
    IS 'Description of what was done by the action';
COMMENT ON COLUMN earthchem.action.action_name
    IS 'name by which the action or event can be identified by users; will appear in pick lists and reports';
COMMENT ON COLUMN earthchem.action.status
    IS 'added to track action status';
CREATE SEQUENCE action_action_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE action_action_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE action_action_num_seq OWNED BY action.action_num;

ALTER TABLE ONLY action ALTER COLUMN action_num SET DEFAULT nextval('action_action_num_seq'::regclass);
ALTER TABLE ONLY action ADD CONSTRAINT action_pkey PRIMARY KEY (action_num);
ALTER TABLE ONLY action ADD CONSTRAINT uc_action UNIQUE (action_type_num, method_num, action_description, organization_num, action_name, begin_date_time, begin_date_time_utc_offset);


CREATE INDEX a_method_num_idx ON action USING btree (method_num);
CREATE INDEX action_method_num_idx ON action USING btree (method_num);

-- Name: action_annotation; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE action_annotation (
    action_annotation_num integer NOT NULL,
    action_num integer NOT NULL,
    annotation_num integer NOT NULL
);
ALTER TABLE action_annotation OWNER TO ecdb_dev;

CREATE SEQUENCE action_annotation_action_annotation_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE action_annotation_action_annotation_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE action_annotation_action_annotation_num_seq OWNED BY action_annotation.action_annotation_num;

ALTER TABLE ONLY action_annotation ALTER COLUMN action_annotation_num SET DEFAULT nextval('action_annotation_action_annotation_num_seq'::regclass);
ALTER TABLE ONLY action_annotation ADD CONSTRAINT action_annotation_pkey PRIMARY KEY (action_annotation_num);
ALTER TABLE ONLY action_annotation ADD CONSTRAINT uc_action_annotation UNIQUE (action_num, annotation_num);


-- Name: action_by; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE action_by (
    bridge_num integer NOT NULL,
    action_num integer NOT NULL,
    affiliation_num integer NOT NULL,
    is_action_lead integer NOT NULL,
    role_description character varying(256)
);
ALTER TABLE action_by OWNER TO ecdb_dev;

CREATE SEQUENCE action_by_bridge_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE action_by_bridge_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE action_by_bridge_num_seq OWNED BY action_by.bridge_num;

ALTER TABLE ONLY action_by ALTER COLUMN bridge_num SET DEFAULT nextval('action_by_bridge_num_seq'::regclass);
ALTER TABLE ONLY action_by ADD CONSTRAINT action_by_pkey PRIMARY KEY (bridge_num);
ALTER TABLE ONLY action_by ADD CONSTRAINT uc_action_num_affiliation_num_is_action_lead_role_description UNIQUE (action_num, affiliation_num, is_action_lead, role_description);




-- Name: action_extension_property; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE action_extension_property (
    bridge_num integer NOT NULL,
    action_num integer NOT NULL,
    extension_property_num integer NOT NULL,
    property_value double precision NOT NULL
);
ALTER TABLE action_extension_property OWNER TO ecdb_dev;

CREATE SEQUENCE action_extension_property_bridge_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE action_extension_property_bridge_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE action_extension_property_bridge_num_seq OWNED BY action_extension_property.bridge_num;

ALTER TABLE ONLY action_extension_property ALTER COLUMN bridge_num SET DEFAULT nextval('action_extension_property_bridge_num_seq'::regclass);
ALTER TABLE ONLY action_extension_property ADD CONSTRAINT action_extension_property_pkey PRIMARY KEY (bridge_num);
ALTER TABLE ONLY action_extension_property ADD CONSTRAINT uc_action_num_extension_property_num UNIQUE (action_num, extension_property_num);




-- Name: action_external_identifier; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE action_external_identifier (
    bridge_num integer NOT NULL,
    action_num integer NOT NULL,
    action_external_id character varying(256) NOT NULL,
    action_external_identifier_uri character varying(2000),
    external_identifier_system_num integer NOT NULL
);
ALTER TABLE action_external_identifier OWNER TO ecdb_dev;

CREATE SEQUENCE action_external_identifier_bridge_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE action_external_identifier_bridge_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE action_external_identifier_bridge_num_seq OWNED BY action_external_identifier.bridge_num;

ALTER TABLE ONLY action_external_identifier ALTER COLUMN bridge_num SET DEFAULT nextval('action_external_identifier_bridge_num_seq'::regclass);
ALTER TABLE ONLY action_external_identifier ADD CONSTRAINT action_external_identifier_pkey PRIMARY KEY (bridge_num);



-- Name: action_type; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE action_type (
    action_type_num integer NOT NULL,
    action_type_name character varying(256) NOT NULL,
    action_type_description character varying(2000) NOT NULL,
	action_category character varying(255),
	source character varying(255),
    status integer DEFAULT 1
);
ALTER TABLE action_type OWNER TO ecdb_dev;
COMMENT ON TABLE action_type IS 'types of actions; category groups for specific contexts';

CREATE SEQUENCE action_type_action_type_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE action_type_action_type_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE action_type_action_type_num_seq OWNED BY action_type.action_type_num;

ALTER TABLE ONLY action_type ALTER COLUMN action_type_num SET DEFAULT nextval('action_type_action_type_num_seq'::regclass);
ALTER TABLE ONLY action_type ADD CONSTRAINT action_type_pkey PRIMARY KEY (action_type_num);
ALTER TABLE ONLY action_type ADD CONSTRAINT uc_action_type_name UNIQUE (action_type_name);




-- Name: affiliation; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE affiliation (
    affiliation_num integer NOT NULL,
    person_num integer NOT NULL,
    organization_num integer NOT NULL,
    is_primary_organization_contact boolean,
    affiliation_start_date timestamp without time zone,
    affiliation_end_date timestamp without time zone,
    primary_phone character varying(20),
    primary_email character varying(64),
    primary_address character varying(2000),
    person_link character varying(2000),
    fax character varying(20),
    title character varying(128),
	status integer DEFAULT 1 NOT NULL
);
ALTER TABLE affiliation OWNER TO ecdb_dev;

CREATE SEQUENCE affiliation_affiliation_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE affiliation_affiliation_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE affiliation_affiliation_num_seq OWNED BY affiliation.affiliation_num;
ALTER TABLE ONLY affiliation ALTER COLUMN affiliation_num SET DEFAULT nextval('affiliation_affiliation_num_seq'::regclass);
ALTER TABLE ONLY affiliation ADD CONSTRAINT affiliation_pkey PRIMARY KEY (affiliation_num);
ALTER TABLE ONLY affiliation ADD CONSTRAINT uc_person_num_organization_num UNIQUE (person_num, organization_num);





-- Name: annotation; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE annotation (
    annotation_num integer NOT NULL,
    annotation_type_num integer NOT NULL,
    annotation_text character varying(2000) NOT NULL,
    data_source_num integer NOT NULL,
    annotation_entered_time timestamp without time zone NOT NULL,
    annotation_link character varying(256),
    annotation_code character varying(256)
);
ALTER TABLE annotation OWNER TO ecdb_dev;

CREATE SEQUENCE annotation_annotation_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE annotation_annotation_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE annotation_annotation_num_seq OWNED BY annotation.annotation_num;
ALTER TABLE ONLY annotation ALTER COLUMN annotation_num SET DEFAULT nextval('annotation_annotation_num_seq'::regclass);
ALTER TABLE ONLY annotation ADD CONSTRAINT annotation_pkey PRIMARY KEY (annotation_num);




-- Name: annotation_type; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE annotation_type (
    annotation_type_num integer NOT NULL,
    annotation_type_name character varying(256) NOT NULL,
	annotation_type_description character varying(2000) NOT NULL,
    annotation_category character varying(255),
	source character varying(255),
    status integer DEFAULT 1
);
ALTER TABLE annotation_type OWNER TO ecdb_dev;
COMMENT ON COLUMN annotation_type.annotation_type_name IS 'station_comment, location_comment';
COMMENT ON COLUMN annotation_type.annotation_type_description IS 'explanation of the annotation type';
COMMENT ON COLUMN annotation_type.annotation_category IS 'use to subset types for different annotation contexts';
COMMENT ON COLUMN annotation_type.status IS 'allow proposing and deprecating terms';

CREATE SEQUENCE annotation_type_annotation_type_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE annotation_type_annotation_type_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE annotation_type_annotation_type_num_seq OWNED BY annotation_type.annotation_type_num;

ALTER TABLE ONLY annotation_type ALTER COLUMN annotation_type_num SET DEFAULT nextval('annotation_type_annotation_type_num_seq'::regclass);
ALTER TABLE ONLY annotation_type ADD CONSTRAINT annotation_type_pkey PRIMARY KEY (annotation_type_num);
ALTER TABLE ONLY annotation_type ADD CONSTRAINT uc_annotation_type UNIQUE (annotation_type_name);


/* 
-- Name: array_data; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE array_data (
    result_num integer NOT NULL,
    x_coord character varying(32)[] NOT NULL,
    x_coord_unit_num integer,
    y_coord character varying(32)[],
    y_coord_unit_num integer,
    z_coord character varying(32)[],
    z_corrd_unit_num integer,
    data_values numeric(10,2)[] NOT NULL
);
ALTER TABLE array_data OWNER TO ecdb_dev;
COMMENT ON TABLE array_data IS 'keep x,y,z array data';
ALTER TABLE ONLY array_data ADD CONSTRAINT pkarray_data PRIMARY KEY (result_num);
 */


-- Name: author_list; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE author_list (
    author_list_num integer NOT NULL,
    citation_num integer NOT NULL,
    person_num integer NOT NULL,
    author_order integer DEFAULT 1 NOT NULL
);
ALTER TABLE author_list OWNER TO ecdb_dev;

CREATE SEQUENCE author_list_author_list_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE author_list_author_list_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE author_list_author_list_num_seq OWNED BY author_list.author_list_num;

ALTER TABLE ONLY author_list ALTER COLUMN author_list_num SET DEFAULT nextval('author_list_author_list_num_seq'::regclass);
ALTER TABLE ONLY author_list ADD CONSTRAINT author_list_pkey PRIMARY KEY (author_list_num);
ALTER TABLE ONLY author_list ADD CONSTRAINT uc_citation_num_author_order UNIQUE (citation_num, author_order);

CREATE UNIQUE INDEX "author_list_ref_num_author_order_Idx" ON author_list USING btree (author_list_num, person_num);


-- Name: citation; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE citation (
    citation_num integer NOT NULL,
    title character varying(256) NOT NULL,
    publisher character varying(256),
    publication_year integer NOT NULL,
    citation_link character varying(2000),
    journal character varying(256),
    issue character varying(16),
    volume character varying(32),
    first_page integer,
    last_page integer,
    book_title character varying(256),
    book_editor character varying(256),
    citation_abstract character varying(20000),
	status integer DEFAULT 1 NOT NULL,
	authors character varying(1000) COLLATE pg_catalog."default"
);
ALTER TABLE citation OWNER TO ecdb_dev;

CREATE SEQUENCE citation_citation_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE citation_citation_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE citation_citation_num_seq OWNED BY citation.citation_num;

ALTER TABLE ONLY citation ALTER COLUMN citation_num SET DEFAULT nextval('citation_citation_num_seq'::regclass);
ALTER TABLE ONLY citation ADD CONSTRAINT citation_pkey PRIMARY KEY (citation_num);
ALTER TABLE ONLY citation ADD CONSTRAINT uc_title_publisher_publication_year UNIQUE (title, publisher, publication_year);




-- Name: citation_dataset; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE citation_dataset (
    citation_dataset_num integer NOT NULL,
    citation_num integer NOT NULL,
    dataset_num integer NOT NULL,
    relationship_type_num integer NOT NULL
);
ALTER TABLE citation_dataset OWNER TO ecdb_dev;
COMMENT ON TABLE citation_dataset IS 'mimic datasource table from PetDb';
COMMENT ON COLUMN citation_dataset.relationship_type_num IS 'relationship between citation and dataset, typicall either isSourceFrom, isCitedBy';

CREATE SEQUENCE citation_dataset_citation_dataset_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE citation_dataset_citation_dataset_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE citation_dataset_citation_dataset_num_seq OWNED BY citation_dataset.citation_dataset_num;

ALTER TABLE ONLY citation_dataset ALTER COLUMN citation_dataset_num SET DEFAULT nextval('citation_dataset_citation_dataset_num_seq'::regclass);
ALTER TABLE ONLY citation_dataset ADD CONSTRAINT citation_dataset_pkey PRIMARY KEY (citation_dataset_num);
ALTER TABLE ONLY citation_dataset ADD CONSTRAINT uc_citation_num_dataset_num_relationship_type_num UNIQUE (citation_num, dataset_num, relationship_type_num);




-- Name: citation_external_identifier; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE citation_external_identifier (
    bridge_num integer NOT NULL,
    citation_num integer NOT NULL,
    external_identifier_system_num integer NOT NULL,
    citation_external_identifier character varying(2000) NOT NULL,
    citation_external_identifier_uri character varying(2000)
);
ALTER TABLE citation_external_identifier OWNER TO ecdb_dev;
COMMENT ON TABLE citation_external_identifier IS 'doi etc.';
COMMENT ON COLUMN citation_external_identifier.citation_external_identifier IS 'Such as DOI without URI:10.1016/0040-1951(88)90298-3';
COMMENT ON COLUMN citation_external_identifier.citation_external_identifier_uri IS '10.1016/0040-1951(88)90298-3';

CREATE SEQUENCE citation_external_identifier_bridge_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE citation_external_identifier_bridge_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE citation_external_identifier_bridge_num_seq OWNED BY citation_external_identifier.bridge_num;

ALTER TABLE ONLY citation_external_identifier ALTER COLUMN bridge_num SET DEFAULT nextval('citation_external_identifier_bridge_num_seq'::regclass);
ALTER TABLE ONLY citation_external_identifier ADD CONSTRAINT citation_external_identifier_pkey PRIMARY KEY (bridge_num);
ALTER TABLE ONLY citation_external_identifier ADD CONSTRAINT uc_citation_num_external_identifier_system_num_citation_externa UNIQUE (citation_num, external_identifier_system_num, citation_external_identifier);




-- Name: country; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE country (
    country_num integer NOT NULL,
    country_name character varying(500) NOT NULL,
    country_code character varying(3) NOT NULL,
    country_abbrev character varying(2) NOT NULL,
    country_full_name character varying(512) NOT NULL,
	status integer DEFAULT 1
);
ALTER TABLE country OWNER TO ecdb_dev;

CREATE SEQUENCE country_country_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE country_country_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE country_country_num_seq OWNED BY country.country_num;

ALTER TABLE ONLY country ALTER COLUMN country_num SET DEFAULT nextval('country_country_num_seq'::regclass);
ALTER TABLE ONLY country ADD CONSTRAINT country_pkey PRIMARY KEY (country_num);
ALTER TABLE ONLY country ADD CONSTRAINT uc_country_abbrev UNIQUE (country_abbrev);

ALTER TABLE ONLY country ADD CONSTRAINT uc_country_code UNIQUE (country_code);

ALTER TABLE ONLY country ADD CONSTRAINT uc_country_full_name UNIQUE (country_full_name);

ALTER TABLE ONLY country ADD CONSTRAINT uc_country_name UNIQUE (country_name);




-- Name: data_reduction; Type: Table; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE data_reduction (
    data_reduction_num integer NOT NULL,
    data_reduction_type_num integer NOT NULL,
    data_reduction_description character varying(2000) NOT NULL,
    variable_num integer NOT NULL
);
ALTER TABLE data_reduction OWNER TO ecdb_dev;
COMMENT ON COLUMN data_reduction.data_reduction_description IS 'explanation of data reduction process';

CREATE SEQUENCE data_reduction_data_reduction_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE data_reduction_data_reduction_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE data_reduction_data_reduction_num_seq OWNED BY data_reduction.data_reduction_num;
ALTER TABLE ONLY data_reduction ALTER COLUMN data_reduction_num SET DEFAULT nextval('data_reduction_data_reduction_num_seq'::regclass);
ALTER TABLE ONLY data_reduction ADD CONSTRAINT data_reduction_pkey PRIMARY KEY (data_reduction_num);
ALTER TABLE ONLY data_reduction ADD CONSTRAINT uc_data_reduction UNIQUE (data_reduction_type_num, variable_num, data_reduction_description);



-- Name: data_reduction_type; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE data_reduction_type (
    data_reduction_type_num integer NOT NULL,
    data_reduction_type_name character varying(256) NOT NULL,
    data_reduction_description character varying(2000),
    data_reduction_category character varying(255),
	source character varying(255),
    status integer DEFAULT 1
);
ALTER TABLE data_reduction_type OWNER TO ecdb_dev;
COMMENT ON TABLE data_reduction_type IS 'fraction_correction';

CREATE SEQUENCE data_reduction_type_data_reduction_type_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE data_reduction_type_data_reduction_type_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE data_reduction_type_data_reduction_type_num_seq OWNED BY data_reduction_type.data_reduction_type_num;

ALTER TABLE ONLY data_reduction_type ALTER COLUMN data_reduction_type_num SET DEFAULT nextval('data_reduction_type_data_reduction_type_num_seq'::regclass);
ALTER TABLE ONLY data_reduction_type ADD CONSTRAINT data_reduction_type_pkey PRIMARY KEY (data_reduction_type_num);
ALTER TABLE ONLY data_reduction_type ADD CONSTRAINT uc_data_reduction_type UNIQUE (data_reduction_type_name, data_reduction_description);




-- Name: dataquality; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE dataquality (
    dataquality_num integer NOT NULL,
    dataquality_type_num integer NOT NULL,
    dataquality_value double precision NOT NULL,
    unit_num integer NOT NULL,
    dataquality_description character varying(2000),
    dataquality_link character varying(2000)
);
ALTER TABLE dataquality OWNER TO ecdb_dev;

CREATE SEQUENCE dataquality_dataquality_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE dataquality_dataquality_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE dataquality_dataquality_num_seq OWNED BY dataquality.dataquality_num;
ALTER TABLE ONLY dataquality ALTER COLUMN dataquality_num SET DEFAULT nextval('dataquality_dataquality_num_seq'::regclass);
ALTER TABLE ONLY dataquality ADD CONSTRAINT dataquality_pkey PRIMARY KEY (dataquality_num);
ALTER TABLE ONLY dataquality ADD CONSTRAINT uc_dataquality UNIQUE (dataquality_type_num, dataquality_value, unit_num, dataquality_description);




-- Name: dataquality_type; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE dataquality_type (
    dataquality_type_num integer NOT NULL,
    dataquality_type_name character varying(256) NOT NULL,
    dataquality_type_description character varying(2000),
	dataquality_category character varying(255),
    source character varying(255),
    status integer DEFAULT 1
);
ALTER TABLE dataquality_type OWNER TO ecdb_dev;

CREATE SEQUENCE dataquality_type_dataquality_type_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE dataquality_type_dataquality_type_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE dataquality_type_dataquality_type_num_seq OWNED BY dataquality_type.dataquality_type_num;

ALTER TABLE ONLY dataquality_type ALTER COLUMN dataquality_type_num SET DEFAULT nextval('dataquality_type_dataquality_type_num_seq'::regclass);
ALTER TABLE ONLY dataquality_type ADD CONSTRAINT dataquality_type_pkey PRIMARY KEY (dataquality_type_num);
ALTER TABLE ONLY dataquality_type ADD CONSTRAINT uc_dataquality_type UNIQUE (dataquality_type_name, dataquality_type_description);




-- Name: dataset; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE dataset (
    dataset_num integer NOT NULL,
    dataset_uuid uuid NOT NULL,
    dataset_type character varying(128) NOT NULL,
    dataset_code character varying(64) NOT NULL,
    dataset_title character varying(512) NOT NULL,
    dataset_abstract character varying(2000) NOT NULL
);
ALTER TABLE dataset OWNER TO ecdb_dev;
COMMENT ON COLUMN dataset.dataset_uuid IS 'table_in_ref_num';

CREATE SEQUENCE dataset_dataset_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE dataset_dataset_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE dataset_dataset_num_seq OWNED BY dataset.dataset_num;
ALTER TABLE ONLY dataset ALTER COLUMN dataset_num SET DEFAULT nextval('dataset_dataset_num_seq'::regclass);
ALTER TABLE ONLY dataset ADD CONSTRAINT dataset_pkey PRIMARY KEY (dataset_num);
ALTER TABLE ONLY dataset ADD CONSTRAINT uc_dataset_type_dataset_code_dataset_title UNIQUE (dataset_type, dataset_code, dataset_title);

ALTER TABLE ONLY dataset ADD CONSTRAINT uc_dataset_uuid UNIQUE (dataset_uuid);





-- Name: dataset_external_identifier; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE dataset_external_identifier (
    bridge_num integer NOT NULL,
    dataset_num integer NOT NULL,
    external_identifier_system_num integer NOT NULL,
    dataset_external_identifier character varying(2000) NOT NULL,
    dataset_external_identifier_uri character varying(2000)
);
ALTER TABLE dataset_external_identifier OWNER TO ecdb_dev;

CREATE SEQUENCE dataset_external_identifier_bridge_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE dataset_external_identifier_bridge_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE dataset_external_identifier_bridge_num_seq OWNED BY dataset_external_identifier.bridge_num;
ALTER TABLE ONLY dataset_external_identifier ALTER COLUMN bridge_num SET DEFAULT nextval('dataset_external_identifier_bridge_num_seq'::regclass);
ALTER TABLE ONLY dataset_external_identifier ADD CONSTRAINT dataset_external_identifier_pkey PRIMARY KEY (bridge_num);
ALTER TABLE ONLY dataset_external_identifier ADD CONSTRAINT uc_dataset_num_external_identifier_system_num_dataset_external_ UNIQUE (dataset_num, external_identifier_system_num, dataset_external_identifier);




-- Name: dataset_result; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE dataset_result (
    bridge_num integer NOT NULL,
    dataset_num integer NOT NULL,
    result_num integer NOT NULL
);
ALTER TABLE dataset_result OWNER TO ecdb_dev;

CREATE SEQUENCE dataset_result_bridge_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE dataset_result_bridge_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE dataset_result_bridge_num_seq OWNED BY dataset_result.bridge_num;

ALTER TABLE ONLY dataset_result ALTER COLUMN bridge_num SET DEFAULT nextval('dataset_result_bridge_num_seq'::regclass);
ALTER TABLE ONLY dataset_result ADD CONSTRAINT dataset_result_pkey PRIMARY KEY (bridge_num);
ALTER TABLE ONLY dataset_result ADD CONSTRAINT uc_dataset_num_result_num UNIQUE (dataset_num, result_num);




-- Name: ec_group; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE ec_group (
    ec_group_num integer NOT NULL,
    ec_group_name character varying(256) NOT NULL,
    ec_group_description character varying(2000) NOT NULL
);
ALTER TABLE ec_group OWNER TO ecdb_dev;
ALTER TABLE ONLY ec_group ADD CONSTRAINT pkec_group PRIMARY KEY (ec_group_num);
ALTER TABLE ONLY ec_group ADD CONSTRAINT uc_ec_group UNIQUE (ec_group_name);



-- Name: ec_log_all_table; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE ec_log_all_table (
    ec_log_all_table_num integer NOT NULL,
    table_name character varying(64) NOT NULL,
    ec_user_num integer NOT NULL,
    row_id bigint NOT NULL,
    column_name character varying(256) NOT NULL,
    old_value character varying(2000) NOT NULL,
    new_value character varying(2000) NOT NULL,
    log_time timestamp without time zone NOT NULL
);
ALTER TABLE ec_log_all_table OWNER TO ecdb_dev;
ALTER TABLE ONLY ec_log_all_table ADD CONSTRAINT pkec_log_all_table PRIMARY KEY (ec_log_all_table_num);
ALTER TABLE ONLY ec_log_all_table ADD CONSTRAINT uc_ec_log_all_table UNIQUE (table_name, row_id, column_name, old_value, new_value);




-- Name: ec_role; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE ec_role (
    ec_role_num integer NOT NULL,
    ec_role_name character varying(16) NOT NULL,
    ec_role_description character varying(2000) NOT NULL
);
ALTER TABLE ec_role OWNER TO ecdb_dev;
ALTER TABLE ONLY ec_role ADD CONSTRAINT pkec_role PRIMARY KEY (ec_role_num);
ALTER TABLE ONLY ec_role ADD CONSTRAINT uc_ec_role UNIQUE (ec_role_name);


-- Name: ec_status_info; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE ec_status_info (
    ec_status_info_num integer NOT NULL,
    citation_num integer NOT NULL,
    data_status character varying(16) NOT NULL,
    public_comment character varying(2000),
    internal_comment character varying(2000)
);
ALTER TABLE ec_status_info OWNER TO ecdb_dev;
COMMENT ON COLUMN ec_status_info.data_status IS 'In Progress, Completed etc.';

CREATE SEQUENCE ec_status_info_ec_status_info_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE ec_status_info_ec_status_info_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE ec_status_info_ec_status_info_num_seq OWNED BY ec_status_info.ec_status_info_num;

ALTER TABLE ONLY ec_status_info ALTER COLUMN ec_status_info_num SET DEFAULT nextval('ec_status_info_ec_status_info_num_seq'::regclass);



ALTER TABLE ONLY ec_status_info ADD CONSTRAINT pkec_status_info PRIMARY KEY (ec_status_info_num);
ALTER TABLE ONLY ec_status_info ADD CONSTRAINT uc_ec_status_info_citation_num UNIQUE (citation_num);




-- Name: ec_user; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE ec_user (
    ec_user_num integer NOT NULL,
    ec_user_login character varying(256) NOT NULL,
    ec_user_password character varying(2000) NOT NULL
);
ALTER TABLE ec_user OWNER TO ecdb_dev;
ALTER TABLE ONLY ec_user ADD CONSTRAINT pkec_user PRIMARY KEY (ec_user_num);
ALTER TABLE ONLY ec_user ADD CONSTRAINT uc_ec_user UNIQUE (ec_user_login);




-- Name: ec_user_group; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE ec_user_group (
    ec_user_group_num integer NOT NULL,
    ec_user_num integer NOT NULL,
    ec_group_num integer NOT NULL
);
ALTER TABLE ec_user_group OWNER TO ecdb_dev;
ALTER TABLE ONLY ec_user_group ADD CONSTRAINT pkec_user_group PRIMARY KEY (ec_user_group_num);
ALTER TABLE ONLY ec_user_group ADD CONSTRAINT uc_ec_user_group UNIQUE (ec_user_num, ec_group_num);




-- Name: ec_user_role; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE ec_user_role (
    ec_user_role_num integer NOT NULL,
    ec_user_num integer NOT NULL,
    ec_role_num integer NOT NULL
);
ALTER TABLE ec_user_role OWNER TO ecdb_dev;
ALTER TABLE ONLY ec_user_role ADD CONSTRAINT pkec_user_role PRIMARY KEY (ec_user_role_num);
ALTER TABLE ONLY ec_user_role ADD CONSTRAINT uc_ec_user_role UNIQUE (ec_user_num, ec_role_num);




-- Name: equipment; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE equipment (
    equipment_num integer NOT NULL,
    equipment_code character varying(256) NOT NULL,
    equipment_name character varying(256) NOT NULL,
    equipment_type_num integer NOT NULL,
    model_id bigint,
    equipment_serial_num bigint,
    equipment_inventory_num bigint,
    equipment_owner_id character varying(256),
    equipment_vendor_id character varying(256),
    equipment_phurchase_date timestamp without time zone,
    equipment_phurchase_order_num bigint,
    equipment_photo_file_name character varying(256),
    equipment_description character varying(256),
    status integer DEFAULT 1
);
ALTER TABLE equipment OWNER TO ecdb_dev;

CREATE SEQUENCE equipment_equipment_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE equipment_equipment_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE equipment_equipment_num_seq OWNED BY equipment.equipment_num;

ALTER TABLE ONLY equipment ALTER COLUMN equipment_num SET DEFAULT nextval('equipment_equipment_num_seq'::regclass);
ALTER TABLE ONLY equipment ADD CONSTRAINT equipment_pkey PRIMARY KEY (equipment_num);
ALTER TABLE ONLY equipment ADD CONSTRAINT uc_equipment UNIQUE (equipment_code, equipment_name, equipment_type_num, model_id, equipment_serial_num);



-- Name: equipment_action; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE equipment_action (
    bridge_num integer NOT NULL,
    equipment_num integer NOT NULL,
    action_num integer NOT NULL
);
ALTER TABLE equipment_action OWNER TO ecdb_dev;

CREATE SEQUENCE equipment_action_bridge_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE equipment_action_bridge_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE equipment_action_bridge_num_seq OWNED BY equipment_action.bridge_num;

ALTER TABLE ONLY equipment_action ALTER COLUMN bridge_num SET DEFAULT nextval('equipment_action_bridge_num_seq'::regclass);
ALTER TABLE ONLY equipment_action ADD CONSTRAINT equipment_action_pkey PRIMARY KEY (bridge_num);
ALTER TABLE ONLY equipment_action ADD CONSTRAINT uc_equipment_action UNIQUE (equipment_num, action_num);





-- Name: equipment_type; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE equipment_type (
    equipment_type_num integer NOT NULL,
    equipment_type_name character varying(256) NOT NULL,
    equipment_type_description character varying(2000) NOT NULL,
	equipment_category character varying(255),
    source character varying(255),
    status integer DEFAULT 1
);
ALTER TABLE equipment_type OWNER TO ecdb_dev;

CREATE SEQUENCE equipment_type_equipment_type_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE equipment_type_equipment_type_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE equipment_type_equipment_type_num_seq OWNED BY equipment_type.equipment_type_num;

ALTER TABLE ONLY equipment_type ALTER COLUMN equipment_type_num SET DEFAULT nextval('equipment_type_equipment_type_num_seq'::regclass);
ALTER TABLE ONLY equipment_type ADD CONSTRAINT equipment_type_pkey PRIMARY KEY (equipment_type_num);
ALTER TABLE ONLY equipment_type ADD CONSTRAINT uc_equipment_type UNIQUE (equipment_type_name);


-- Name: extension_property; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE extension_property (
    extension_property_num integer NOT NULL,
    extension_property_name character varying(256) NOT NULL,
    extension_property_description character varying(2000),
    property_data_type character varying(256) NOT NULL,
    property_data_unit_num integer,
	source character varying(255),
    status integer DEFAULT 1
);
ALTER TABLE extension_property OWNER TO ecdb_dev;

CREATE SEQUENCE extension_property_extension_property_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE extension_property_extension_property_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE extension_property_extension_property_num_seq OWNED BY extension_property.extension_property_num;
ALTER TABLE ONLY extension_property ALTER COLUMN extension_property_num SET DEFAULT nextval('extension_property_extension_property_num_seq'::regclass);
ALTER TABLE ONLY extension_property ADD CONSTRAINT extension_property_pkey PRIMARY KEY (extension_property_num);
ALTER TABLE ONLY extension_property ADD CONSTRAINT uc_extension_property UNIQUE (extension_property_name, property_data_type);




-- Name: external_identifier_system; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE external_identifier_system (
    external_identifier_system_num integer NOT NULL,
    external_identifier_system_name character varying(256) NOT NULL,
    external_identifier_system_organization_num integer NOT NULL,
    external_identifier_system_description character varying(2000),
    external_identifier_system_url character varying(2000)
);
ALTER TABLE external_identifier_system OWNER TO ecdb_dev;
COMMENT ON COLUMN external_identifier_system.external_identifier_system_name IS 'Namea of external ID scheme,e.g. ORCID, DOI, IGSN';

CREATE SEQUENCE external_identifier_system_external_identifier_system_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE external_identifier_system_external_identifier_system_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE external_identifier_system_external_identifier_system_num_seq OWNED BY external_identifier_system.external_identifier_system_num;

ALTER TABLE ONLY external_identifier_system ALTER COLUMN external_identifier_system_num SET DEFAULT nextval('external_identifier_system_external_identifier_system_num_seq'::regclass);
ALTER TABLE ONLY external_identifier_system ADD CONSTRAINT external_identifier_system_pkey PRIMARY KEY (external_identifier_system_num);
ALTER TABLE ONLY external_identifier_system ADD CONSTRAINT uc_external_identifier_system UNIQUE (external_identifier_system_name, external_identifier_system_organization_num);




-- Name: feature_action; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE feature_action (
    feature_action_num integer NOT NULL,
    sampling_feature_num integer NOT NULL,
    action_num integer NOT NULL
);
ALTER TABLE feature_action OWNER TO ecdb_dev;

CREATE SEQUENCE feature_action_feature_action_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE feature_action_feature_action_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE feature_action_feature_action_num_seq OWNED BY feature_action.feature_action_num;

ALTER TABLE ONLY feature_action ALTER COLUMN feature_action_num SET DEFAULT nextval('feature_action_feature_action_num_seq'::regclass);
ALTER TABLE ONLY feature_action ADD CONSTRAINT feature_action_pkey PRIMARY KEY (feature_action_num);
ALTER TABLE ONLY feature_action ADD CONSTRAINT uc_feature_action UNIQUE (sampling_feature_num, action_num);

CREATE INDEX fa_action_num_idx ON feature_action USING btree (action_num);
CREATE INDEX fa_sampling_feature_num_idx ON feature_action USING btree (sampling_feature_num);
CREATE INDEX fa_sf_num_idx ON feature_action USING btree (sampling_feature_num);





-- Name: feature_of_interest; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE feature_of_interest (
    feature_of_interest_num integer NOT NULL,
    sampling_feature_num integer NOT NULL,
    feature_of_interest_type_num integer NOT NULL,
    feature_of_interest_cv_num integer,

);
ALTER TABLE feature_of_interest OWNER TO ecdb_dev;

-- Name: feature_of_interest_feature_of_interest_num_seq; Type: SEQUENCE; Schema: earthchem; Owner: ecdb_dev
CREATE SEQUENCE feature_of_interest_feature_of_interest_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE feature_of_interest_feature_of_interest_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE feature_of_interest_feature_of_interest_num_seq OWNED BY feature_of_interest.feature_of_interest_num;

ALTER TABLE ONLY feature_of_interest ALTER COLUMN feature_of_interest_num SET DEFAULT nextval('feature_of_interest_feature_of_interest_num_seq'::regclass);
ALTER TABLE ONLY feature_of_interest ADD CONSTRAINT feature_of_interest_pkey PRIMARY KEY (feature_of_interest_num);
ALTER TABLE ONLY feature_of_interest ADD CONSTRAINT uc_feature_of_interest UNIQUE (sampling_feature_num, feature_of_interest_type_num, feature_of_interest_cv_num);
CREATE INDEX fi_sf_num_idx ON feature_of_interest USING btree (sampling_feature_num);

CREATE INDEX foi_feature_of_interest_cv_num_idx ON feature_of_interest USING btree (feature_of_interest_cv_num);

CREATE INDEX foi_feature_of_interest_type_num_idx ON feature_of_interest USING btree (feature_of_interest_type_num);

CREATE INDEX foi_sampling_feature_num_idx ON feature_of_interest USING btree (sampling_feature_num);





-- Name: feature_of_interest_annotation; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE feature_of_interest_annotation (
    feature_of_interest_annotation_num integer NOT NULL,
    feature_of_interest_num integer NOT NULL,
    annotation_num integer NOT NULL
);
ALTER TABLE feature_of_interest_annotation OWNER TO ecdb_dev;

CREATE SEQUENCE feature_of_interest_annotatio_feature_of_interest_annotatio_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE feature_of_interest_annotatio_feature_of_interest_annotatio_seq OWNER TO ecdb_dev;
ALTER SEQUENCE feature_of_interest_annotatio_feature_of_interest_annotatio_seq OWNED BY feature_of_interest_annotation.feature_of_interest_annotation_num;

ALTER TABLE ONLY feature_of_interest_annotation ALTER COLUMN feature_of_interest_annotation_num SET DEFAULT nextval('feature_of_interest_annotatio_feature_of_interest_annotatio_seq'::regclass);
ALTER TABLE ONLY feature_of_interest_annotation ADD CONSTRAINT feature_of_interest_annotation_pkey PRIMARY KEY (feature_of_interest_annotation_num);
ALTER TABLE ONLY feature_of_interest_annotation ADD CONSTRAINT uc_feature_of_interest_annotation UNIQUE (feature_of_interest_num, annotation_num);



-- Name: feature_of_interest_cv; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE feature_of_interest_cv (
    feature_of_interest_cv_num integer NOT NULL,
    feature_of_interest_cv_name character varying(256) NOT NULL,
    feature_of_interest_description character varying(2000),
	source character varying(255),
    status integer DEFAULT 1
);
ALTER TABLE feature_of_interest_cv OWNER TO ecdb_dev;

CREATE SEQUENCE feature_of_interest_cv_feature_of_interest_cv_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE feature_of_interest_cv_feature_of_interest_cv_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE feature_of_interest_cv_feature_of_interest_cv_num_seq OWNED BY feature_of_interest_cv.feature_of_interest_cv_num;
ALTER TABLE ONLY feature_of_interest_cv ALTER COLUMN feature_of_interest_cv_num SET DEFAULT nextval('feature_of_interest_cv_feature_of_interest_cv_num_seq'::regclass);
ALTER TABLE ONLY feature_of_interest_cv ADD CONSTRAINT feature_of_interest_cv_pkey PRIMARY KEY (feature_of_interest_cv_num);
ALTER TABLE ONLY feature_of_interest_cv ADD CONSTRAINT uc_feature_of_interest_cv UNIQUE (feature_of_interest_cv_name);




-- Name: feature_of_interest_type; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE feature_of_interest_type (
    feature_of_interest_type_num integer NOT NULL,
    feature_of_interest_type_name character varying(255) NOT NULL,
    feature_of_interest_type_description character varying(2000) NOT NULL,
	feature_of_interest_category character varying(255),
    source character varying(255),
    status integer DEFAULT 1
);
ALTER TABLE feature_of_interest_type OWNER TO ecdb_dev;

CREATE SEQUENCE feature_of_interest_type_feature_of_interest_type_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE feature_of_interest_type_feature_of_interest_type_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE feature_of_interest_type_feature_of_interest_type_num_seq OWNED BY feature_of_interest_type.feature_of_interest_type_num;

ALTER TABLE ONLY feature_of_interest_type ALTER COLUMN feature_of_interest_type_num SET DEFAULT nextval('feature_of_interest_type_feature_of_interest_type_num_seq'::regclass);
ALTER TABLE ONLY feature_of_interest_type ADD CONSTRAINT feature_of_interest_type_pkey PRIMARY KEY (feature_of_interest_type_num);
ALTER TABLE ONLY feature_of_interest_type ADD CONSTRAINT uc_feature_of_interest_type_name_desc UNIQUE (feature_of_interest_type_name, feature_of_interest_type_description);

CREATE TABLE geological_time (
    primary_key integer NOT NULL,
    name character varying(255),
    geol_age_prefix character varying(255),
    geol_age character varying(255),
    max_age real,
    min_age real,
    age_level character varying(255)
);




-- Name: material; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE material (
    material_num integer NOT NULL,
    material_code character varying(255) NOT NULL,
    material_name character varying(255) NOT NULL,
    material_description character varying(2000) NOT NULL,
	material_category character varying(255),
    source character varying(255),
    status integer DEFAULT 1
);
ALTER TABLE material OWNER TO ecdb_dev;

CREATE SEQUENCE material_material_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE material_material_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE material_material_num_seq OWNED BY material.material_num;
ALTER TABLE ONLY material ALTER COLUMN material_num SET DEFAULT nextval('material_material_num_seq'::regclass);

ALTER TABLE ONLY material ADD CONSTRAINT material_pkey PRIMARY KEY (material_num);
CREATE UNIQUE INDEX "material_material_name_Idx" ON material USING btree (material_name);
CREATE UNIQUE INDEX "material_material_code_Idx" ON material USING btree (material_code);

ALTER TABLE ONLY material ADD CONSTRAINT uc_material_code UNIQUE (material_code);
ALTER TABLE ONLY material ADD CONSTRAINT uc_material_name UNIQUE (material_name);

-- Name: method; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE method (
    method_num integer NOT NULL,
    method_type_num integer NOT NULL,
    method_code character varying(32) NOT NULL,
    method_name character varying(256) NOT NULL,
    method_description character varying(2000),
    method_link character varying(2000),
    organization_num integer,
    status integer DEFAULT 1
);
ALTER TABLE method OWNER TO ecdb_dev;
COMMENT ON COLUMN method.method_type_num IS 'CV term describing the type of method (e.g., sample collection, laboratory analytical, field, sample prepratation, etc.)';
COMMENT ON COLUMN method.method_code IS 'Used for display. Sometimes the name is too long.';

CREATE SEQUENCE method_method_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE method_method_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE method_method_num_seq OWNED BY method.method_num;

ALTER TABLE ONLY method ALTER COLUMN method_num SET DEFAULT nextval('method_method_num_seq'::regclass);
ALTER TABLE ONLY method ADD CONSTRAINT method_pkey PRIMARY KEY (method_num);
ALTER TABLE ONLY method ADD CONSTRAINT uc_method_code UNIQUE (method_type_num, method_code);
ALTER TABLE ONLY method ADD CONSTRAINT uc_method_name UNIQUE (method_type_num, method_name);




-- Name: method_type; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE method_type (
    method_type_num integer NOT NULL,
    method_type_name character varying(256) NOT NULL,
    method_type_description character varying(2000) NOT NULL,
	method_type_category character varying(255),
    source character varying(255),
    status integer DEFAULT 1
);
ALTER TABLE method_type OWNER TO ecdb_dev;


CREATE SEQUENCE method_type_method_type_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE method_type_method_type_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE method_type_method_type_num_seq OWNED BY method_type.method_type_num;

ALTER TABLE ONLY method_type ALTER COLUMN method_type_num SET DEFAULT nextval('method_type_method_type_num_seq'::regclass);
ALTER TABLE ONLY method_type ADD CONSTRAINT method_type_pkey PRIMARY KEY (method_type_num);
ALTER TABLE ONLY method_type ADD CONSTRAINT uc_method_type_name UNIQUE (method_type_name);




-- Name: migrate_msg; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
--

CREATE TABLE migrate_msg (
    msg character varying(200)
);
ALTER TABLE migrate_msg OWNER TO ecdb_dev;

-- Name: numeric_data; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE numeric_data (
    numeric_data_num integer NOT NULL,
    result_num integer NOT NULL,
    value_meas double precision NOT NULL,
    stdev double precision,
    stdev_type character varying(255),
    unit_num integer NOT NULL,
    data_entered_date date DEFAULT now() NOT NULL
);
ALTER TABLE numeric_data OWNER TO ecdb_dev;

CREATE SEQUENCE numeric_data_numeric_data_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE numeric_data_numeric_data_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE numeric_data_numeric_data_num_seq OWNED BY numeric_data.numeric_data_num;

ALTER TABLE ONLY numeric_data ALTER COLUMN numeric_data_num SET DEFAULT nextval('numeric_data_numeric_data_num_seq'::regclass);
ALTER TABLE ONLY numeric_data ADD CONSTRAINT numeric_data_pkey PRIMARY KEY (numeric_data_num);
CREATE INDEX numeric_result_idx ON numeric_data USING btree (result_num);


-- Name: organization; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE organization (
    organization_num integer NOT NULL,
    organization_type_num integer NOT NULL,
    organization_code character varying(128) NOT NULL,
    organization_name character varying(256) NOT NULL,
    organization_description character varying(2000),
    organization_link character varying,
    parent_organization_num integer,
    country_num integer NOT NULL,
    department character varying(256),
    organization_unique_id integer,
    organization_unique_id_type character varying(128),
    address_part1 character varying(2000),
    address_part2 character varying(256),
    city character varying(256),
    state_num integer,
    zip character varying(256),
	status integer DEFAULT 1 NOT NULL
);
ALTER TABLE organization OWNER TO ecdb_dev;

CREATE SEQUENCE organization_organization_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE organization_organization_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE organization_organization_num_seq OWNED BY organization.organization_num;

ALTER TABLE ONLY organization ALTER COLUMN organization_num SET DEFAULT nextval('organization_organization_num_seq'::regclass);
ALTER TABLE ONLY organization ADD CONSTRAINT organization_pkey PRIMARY KEY (organization_num);
ALTER TABLE ONLY organization ADD CONSTRAINT uc_organization UNIQUE (organization_type_num, organization_code, organization_name, country_num, department);



-- Name: organization_type; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE organization_type (
    organization_type_num integer NOT NULL,
    organization_type_name character varying(256) NOT NULL,
    organization_type_description character varying(2000) NOT NULL,
	organization_category character varying(255),
    source character varying(255),
    status integer DEFAULT 1
);
ALTER TABLE organization_type OWNER TO ecdb_dev;

CREATE SEQUENCE organization_type_organization_type_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE organization_type_organization_type_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE organization_type_organization_type_num_seq OWNED BY organization_type.organization_type_num;
ALTER TABLE ONLY organization_type ALTER COLUMN organization_type_num SET DEFAULT nextval('organization_type_organization_type_num_seq'::regclass);
ALTER TABLE ONLY organization_type ADD CONSTRAINT organization_type_pkey PRIMARY KEY (organization_type_num);
ALTER TABLE ONLY organization_type ADD CONSTRAINT uc_organization_type UNIQUE (organization_type_name);




-- Name: person; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE person (
    person_num integer NOT NULL,
    first_name character varying(256) NOT NULL,
    middle_name character varying(256),
    last_name character varying(64) NOT NULL,
    pnum integer DEFAULT 1 NOT NULL
	status integer DEFAULT 1 NOT NULL
);
ALTER TABLE person OWNER TO ecdb_dev;

CREATE SEQUENCE person_person_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE person_person_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE person_person_num_seq OWNED BY person.person_num;

ALTER TABLE ONLY person ALTER COLUMN person_num SET DEFAULT nextval('person_person_num_seq'::regclass);
ALTER TABLE ONLY person ADD CONSTRAINT person_pkey PRIMARY KEY (person_num);
ALTER TABLE ONLY person ADD CONSTRAINT uc_person UNIQUE (first_name, middle_name, last_name, pnum);




-- Name: person_external_identifier; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE person_external_identifier (
    bridge_num integer NOT NULL,
    person_num integer NOT NULL,
    person_external_identifier character varying(256) NOT NULL,
    person_external_identifier_uri character varying(2000),
    external_identifier_system_num integer NOT NULL
);
ALTER TABLE person_external_identifier OWNER TO ecdb_dev;

CREATE SEQUENCE person_external_identifier_bridge_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE person_external_identifier_bridge_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE person_external_identifier_bridge_num_seq OWNED BY person_external_identifier.bridge_num;

ALTER TABLE ONLY person_external_identifier ALTER COLUMN bridge_num SET DEFAULT nextval('person_external_identifier_bridge_num_seq'::regclass);
ALTER TABLE ONLY person_external_identifier ADD CONSTRAINT person_external_identifier_pkey PRIMARY KEY (bridge_num);
ALTER TABLE ONLY person_external_identifier ADD CONSTRAINT uc_person_external_identifier UNIQUE (person_num, person_external_identifier, external_identifier_system_num);





-- Name: processing_level; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE processing_level (
    processing_level_num integer NOT NULL,
    processing_level_code character varying(256) NOT NULL,
    definition character varying(256),
    explanation character varying(2000)
);
ALTER TABLE processing_level OWNER TO ecdb_dev;

CREATE SEQUENCE processing_level_processing_level_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE processing_level_processing_level_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE processing_level_processing_level_num_seq OWNED BY processing_level.processing_level_num;

ALTER TABLE ONLY processing_level ALTER COLUMN processing_level_num SET DEFAULT nextval('processing_level_processing_level_num_seq'::regclass);
ALTER TABLE ONLY processing_level ADD CONSTRAINT processing_level_pkey PRIMARY KEY (processing_level_num);
ALTER TABLE ONLY processing_level ADD CONSTRAINT uc_processing_level UNIQUE (processing_level_code);


-- Name: reference_material_value; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE reference_material_value (
    reference_material_value_num integer NOT NULL,
    reference_material_value double precision NOT NULL,
    reference_material_accuracy character varying(50) NOT NULL,
    variable_num integer NOT NULL,
    unit_num integer NOT NULL,
    citation_num integer
);
ALTER TABLE reference_material_value OWNER TO ecdb_dev;

CREATE SEQUENCE reference_material_value_reference_material_value_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE reference_material_value_reference_material_value_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE reference_material_value_reference_material_value_num_seq OWNED BY reference_material_value.reference_material_value_num;

ALTER TABLE ONLY reference_material_value ALTER COLUMN reference_material_value_num SET DEFAULT nextval('reference_material_value_reference_material_value_num_seq'::regclass);
ALTER TABLE ONLY reference_material_value ADD CONSTRAINT reference_material_value_pkey PRIMARY KEY (reference_material_value_num);
ALTER TABLE ONLY reference_material_value ADD CONSTRAINT uc_reference_material_value UNIQUE (reference_material_value, variable_num, unit_num, citation_num, reference_material_accuracy);




-- Name: related_action; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE related_action (
    relation_num integer NOT NULL,
    action_num integer NOT NULL,
    relationship_type_num integer NOT NULL,
    related_action_num integer NOT NULL
);
ALTER TABLE related_action OWNER TO ecdb_dev;

CREATE SEQUENCE related_action_relation_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE related_action_relation_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE related_action_relation_num_seq OWNED BY related_action.relation_num;

ALTER TABLE ONLY related_action ALTER COLUMN relation_num SET DEFAULT nextval('related_action_relation_num_seq'::regclass);
ALTER TABLE ONLY related_action ADD CONSTRAINT related_action_pkey PRIMARY KEY (relation_num);
ALTER TABLE ONLY related_action ADD CONSTRAINT uc_related_action UNIQUE (action_num, relationship_type_num, related_action_num);




-- Name: related_feature; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE related_feature (
    related_feature_num integer NOT NULL,
    sampling_feature_num integer NOT NULL,
    relationship_type_num integer NOT NULL,
    related_sampling_feature_num integer NOT NULL,
    spatial_offset_num integer
);
ALTER TABLE related_feature OWNER TO ecdb_dev;

CREATE SEQUENCE related_feature_related_feature_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE related_feature_related_feature_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE related_feature_related_feature_num_seq OWNED BY related_feature.related_feature_num;

ALTER TABLE ONLY related_feature ALTER COLUMN related_feature_num SET DEFAULT nextval('related_feature_related_feature_num_seq'::regclass);
ALTER TABLE ONLY related_feature ADD CONSTRAINT related_feature_pkey PRIMARY KEY (related_feature_num);
ALTER TABLE ONLY related_feature ADD CONSTRAINT uc_related_feature UNIQUE (sampling_feature_num, relationship_type_num, related_sampling_feature_num, spatial_offset_num);

CREATE INDEX rf_sf_num_idx ON related_feature USING btree (sampling_feature_num);
CREATE INDEX rf_rsf_num_idx ON related_feature USING btree (related_sampling_feature_num);

-- Name: related_result; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE related_result (
    relation_num integer NOT NULL,
    result_num integer NOT NULL,
    relationship_type_num integer NOT NULL,
    related_result_num integer NOT NULL,
    version_code character varying(8),
    related_result_sequence_num integer
);
ALTER TABLE related_result OWNER TO ecdb_dev;

CREATE SEQUENCE related_result_relation_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE related_result_relation_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE related_result_relation_num_seq OWNED BY related_result.relation_num;

ALTER TABLE ONLY related_result ALTER COLUMN relation_num SET DEFAULT nextval('related_result_relation_num_seq'::regclass);
ALTER TABLE ONLY related_result ADD CONSTRAINT related_result_pkey PRIMARY KEY (relation_num);
ALTER TABLE ONLY related_result ADD CONSTRAINT uc_related_result UNIQUE (result_num, relationship_type_num, related_result_num);




-- Name: relationship_type; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE relationship_type (
    relationship_type_num integer NOT NULL,
    relationship_type_name character varying(50) NOT NULL,
    relationship_type_description character varying(2000),
	relationship_category character varying(255),
    source character varying(255),
    status integer DEFAULT 1
);
ALTER TABLE relationship_type OWNER TO ecdb_dev;

CREATE SEQUENCE relationship_type_relationship_type_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE relationship_type_relationship_type_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE relationship_type_relationship_type_num_seq OWNED BY relationship_type.relationship_type_num;

ALTER TABLE ONLY relationship_type ALTER COLUMN relationship_type_num SET DEFAULT nextval('relationship_type_relationship_type_num_seq'::regclass);
ALTER TABLE ONLY relationship_type ADD CONSTRAINT relationship_type_pkey PRIMARY KEY (relationship_type_num);
ALTER TABLE ONLY relationship_type ADD CONSTRAINT uc_relationship_type UNIQUE (relationship_type_name);




-- Name: result; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE result (
    result_num integer NOT NULL,
    result_uuid uuid NOT NULL,
    feature_action_num integer NOT NULL,
    result_type_num integer NOT NULL,
    variable_num integer NOT NULL,
    taxonomic_classifier_num integer,
    processing_level_num integer NOT NULL,
    result_date_time timestamp without time zone,
    result_date_time_utc_offset integer,
    valid_time_period character varying(512),
    status character varying(256),
    value_count integer NOT NULL,
    value_type character varying(8) NOT NULL,
    intended_observation_spacing double precision,
    reference_material_value_num integer
);


ALTER TABLE result OWNER TO ecdb_dev;
COMMENT ON COLUMN result.result_type_num IS 'Points to Measurement,Temporal Observation,Count Observation,Truth Observation,Category Observation,Time Series Coverage,Point Coverage,Profile Converage';
COMMENT ON COLUMN result.processing_level_num IS '1: Raw data, etc.';
COMMENT ON COLUMN result.value_type IS 'array,text,numeric,novalue';
COMMENT ON COLUMN result.reference_material_value_num IS 'point to normalization value table';

-- Name: result_result_num_seq; Type: SEQUENCE; Schema: earthchem; Owner: ecdb_dev
CREATE SEQUENCE result_result_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE result_result_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE result_result_num_seq OWNED BY result.result_num;

ALTER TABLE ONLY result ALTER COLUMN result_num SET DEFAULT nextval('result_result_num_seq'::regclass);
ALTER TABLE ONLY result ADD CONSTRAINT result_pkey PRIMARY KEY (result_num);
ALTER TABLE ONLY result ADD CONSTRAINT uc_result UNIQUE (feature_action_num, result_type_num, variable_num, taxonomic_classifier_num, processing_level_num, result_date_time, result_date_time_utc_offset, valid_time_period, intended_observation_spacing, reference_material_value_num);
ALTER TABLE ONLY result ADD CONSTRAINT result_result_uuid_key UNIQUE (result_uuid);
CREATE INDEX result_fa_num_idx ON result USING btree (feature_action_num);

CREATE INDEX result_v_num_idx ON result USING btree (variable_num);

CREATE INDEX result_variable_num_idx ON result USING btree (variable_num);



-- Name: result_annotation; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE result_annotation (
    result_annotation_num integer NOT NULL,
    result_num integer NOT NULL,
    annotation_num integer NOT NULL
);
ALTER TABLE result_annotation OWNER TO ecdb_dev;

CREATE SEQUENCE result_annotation_result_annotation_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE result_annotation_result_annotation_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE result_annotation_result_annotation_num_seq OWNED BY result_annotation.result_annotation_num;

ALTER TABLE ONLY result_annotation ALTER COLUMN result_annotation_num SET DEFAULT nextval('result_annotation_result_annotation_num_seq'::regclass);
ALTER TABLE ONLY result_annotation ADD CONSTRAINT result_annotation_pkey PRIMARY KEY (result_annotation_num);
ALTER TABLE ONLY result_annotation ADD CONSTRAINT uc_result_annotation UNIQUE (result_num, annotation_num);




-- Name: result_data_reduction; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE result_data_reduction (
    result_data_reduction_num integer NOT NULL,
    result_num bigint NOT NULL,
    data_reduction_num integer NOT NULL
);
ALTER TABLE result_data_reduction OWNER TO ecdb_dev;

CREATE SEQUENCE result_data_reduction_result_data_reduction_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE result_data_reduction_result_data_reduction_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE result_data_reduction_result_data_reduction_num_seq OWNED BY result_data_reduction.result_data_reduction_num;

ALTER TABLE ONLY result_data_reduction ALTER COLUMN result_data_reduction_num SET DEFAULT nextval('result_data_reduction_result_data_reduction_num_seq'::regclass);
ALTER TABLE ONLY result_data_reduction ADD CONSTRAINT result_data_reduction_pkey PRIMARY KEY (result_data_reduction_num);
ALTER TABLE ONLY result_data_reduction ADD CONSTRAINT uc_result_data_reduction UNIQUE (result_num, data_reduction_num);




-- Name: result_dataquality; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE result_dataquality (
    result_dataquality_num integer NOT NULL,
    result_num integer NOT NULL,
    dataquality_num integer NOT NULL
);
ALTER TABLE result_dataquality OWNER TO ecdb_dev;

CREATE SEQUENCE result_dataquality_result_dataquality_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE result_dataquality_result_dataquality_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE result_dataquality_result_dataquality_num_seq OWNED BY result_dataquality.result_dataquality_num;

ALTER TABLE ONLY result_dataquality ALTER COLUMN result_dataquality_num SET DEFAULT nextval('result_dataquality_result_dataquality_num_seq'::regclass);
ALTER TABLE ONLY result_dataquality ADD CONSTRAINT result_dataquality_pkey PRIMARY KEY (result_dataquality_num);
ALTER TABLE ONLY result_dataquality ADD CONSTRAINT uc_result_dataquality UNIQUE (result_num, dataquality_num);


-- Name: result_template; Type: TABLE; Schema: earthchem; Owner: system; Tablespace: 
CREATE TABLE result_template (
    result_template_num integer  NOT NULL,
    reporting_variable_name character varying(4000) NOT NULL,
    analysis_event integer NOT NULL,
    variable_num integer NOT NULL,
    unit_num integer NOT NULL,
    uncertainty_type integer,
    uncertainty_value real,
    description text
);
COMMENT ON TABLE result_template IS 'Table for supporting data entry processing from tabular input.';
ALTER TABLE result_template OWNER TO ecdb_dev;

CREATE SEQUENCE result_template_result_template_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE result_template_result_template_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE result_template_result_template_num_seq OWNED BY result_template.result_template_num;
ALTER TABLE ONLY result_template ALTER COLUMN result_template_num SET DEFAULT nextval('public.result_template_result_template_num_seq'::regclass);
ALTER TABLE ONLY result_template ADD CONSTRAINT result_template_pkey PRIMARY KEY (result_template_num);


-- Name: result_history; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE result_history (
    result_history_num integer NOT NULL,
    numeric_data_num integer NOT NULL,
    value_meas double precision NOT NULL,
    stdev double precision NOT NULL,
    stdev_type character varying(255),
    unit character varying(255),
    data_entered_date date NOT NULL,
    history_comment character varying(2000)
);
ALTER TABLE result_history OWNER TO ecdb_dev;

CREATE SEQUENCE result_history_result_history_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE result_history_result_history_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE result_history_result_history_num_seq OWNED BY result_history.result_history_num;

ALTER TABLE ONLY result_history ALTER COLUMN result_history_num SET DEFAULT nextval('result_history_result_history_num_seq'::regclass);
ALTER TABLE ONLY result_history ADD CONSTRAINT result_history_pkey PRIMARY KEY (result_history_num);
ALTER TABLE ONLY result_history ADD CONSTRAINT uc_result_history UNIQUE (numeric_data_num, data_entered_date);



-- Name: result_type; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE result_type (
    result_type_num integer NOT NULL,
    result_type_name character varying(256) NOT NULL,
    result_type_description character varying(2000) NOT NULL,
	result_category character varying(255),
    source character varying(255),
    status integer DEFAULT 1
);
ALTER TABLE result_type OWNER TO ecdb_dev;

CREATE SEQUENCE result_type_result_type_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE result_type_result_type_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE result_type_result_type_num_seq OWNED BY result_type.result_type_num;

ALTER TABLE ONLY result_type ALTER COLUMN result_type_num SET DEFAULT nextval('result_type_result_type_num_seq'::regclass);
ALTER TABLE ONLY result_type ADD CONSTRAINT result_type_pkey PRIMARY KEY (result_type_num);
ALTER TABLE ONLY result_type ADD CONSTRAINT uc_result_type UNIQUE (result_type_name);




CREATE TABLE sampling_feature (
    sampling_feature_num integer NOT NULL,
    sampling_feature_type_num integer NOT NULL,
    sampling_feature_code character varying(50) NOT NULL,
    sampling_feature_name character varying(256),
    sampling_feature_description character varying(2000),
    sampling_feature_geotype character varying(16),
    feature_geometry public.geometry,
    elevation_m double precision,
    elevation_datum character varying(256)
);
ALTER TABLE sampling_feature OWNER TO ecdb_dev;
COMMENT ON COLUMN sampling_feature.sampling_feature_geotype IS 'Eg: LINESTRING, POLYGON, MULTIPOINT,POINT';
COMMENT ON COLUMN sampling_feature.elevation_m IS 'units MUST be meter';

CREATE SEQUENCE sampling_feature_sampling_feature_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE sampling_feature_sampling_feature_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE sampling_feature_sampling_feature_num_seq OWNED BY sampling_feature.sampling_feature_num;

ALTER TABLE ONLY sampling_feature ALTER COLUMN sampling_feature_num SET DEFAULT nextval('sampling_feature_sampling_feature_num_seq'::regclass);
ALTER TABLE ONLY sampling_feature ADD CONSTRAINT sampling_feature_pkey PRIMARY KEY (sampling_feature_num);


-- Name: sampling_feature_annotation; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE sampling_feature_annotation (
    sampling_feature_annotation_num integer NOT NULL,
    sampling_feature_num integer NOT NULL,
    annotation_num integer NOT NULL
);
ALTER TABLE sampling_feature_annotation OWNER TO ecdb_dev;

CREATE SEQUENCE sampling_feature_annotation_sampling_feature_annotation_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE sampling_feature_annotation_sampling_feature_annotation_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE sampling_feature_annotation_sampling_feature_annotation_num_seq OWNED BY sampling_feature_annotation.sampling_feature_annotation_num;

ALTER TABLE ONLY sampling_feature_annotation ALTER COLUMN sampling_feature_annotation_num SET DEFAULT nextval('sampling_feature_annotation_sampling_feature_annotation_num_seq'::regclass);
ALTER TABLE ONLY sampling_feature_annotation ADD CONSTRAINT sampling_feature_annotation_pkey PRIMARY KEY (sampling_feature_annotation_num);
ALTER TABLE ONLY sampling_feature_annotation ADD CONSTRAINT uc_sampling_feature_annotation UNIQUE (sampling_feature_num, annotation_num);



-- Name: sampling_feature_extension_property; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE sampling_feature_extension_property (
    bridge_num integer NOT NULL,
    sampling_feature_num integer NOT NULL,
    extension_property_num integer NOT NULL,
    property_value double precision NOT NULL
);
ALTER TABLE sampling_feature_extension_property OWNER TO ecdb_dev;

CREATE SEQUENCE sampling_feature_extension_property_bridge_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE sampling_feature_extension_property_bridge_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE sampling_feature_extension_property_bridge_num_seq OWNED BY sampling_feature_extension_property.bridge_num;

ALTER TABLE ONLY sampling_feature_extension_property ALTER COLUMN bridge_num SET DEFAULT nextval('sampling_feature_extension_property_bridge_num_seq'::regclass);
ALTER TABLE ONLY sampling_feature_extension_property ADD CONSTRAINT sampling_feature_extension_property_pkey PRIMARY KEY (bridge_num);
ALTER TABLE ONLY sampling_feature_extension_property ADD CONSTRAINT uc_sampling_feature_extension_property UNIQUE (sampling_feature_num, extension_property_num);


-- Name: sampling_feature_external_identifier; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE sampling_feature_external_identifier (
    bridge_num integer NOT NULL,
    sample_feature_num integer NOT NULL,
    sampling_feature_external_id character varying(256) NOT NULL,
    sampling_feature_external_identifier_uri character varying(2000),
    external_identifier_system_num integer NOT NULL
);

COMMENT ON COLUMN sampling_feature_external_identifier.sampling_feature_external_id IS '';
COMMENT ON COLUMN sampling_feature_external_identifier.sampling_feature_external_identifier_uri IS '';

CREATE SEQUENCE sampling_feature_external_identifier_bridge_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE sampling_feature_external_identifier_bridge_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE sampling_feature_external_identifier_bridge_num_seq OWNED BY sampling_feature_external_identifier.bridge_num;

ALTER TABLE ONLY sampling_feature_external_identifier ALTER COLUMN bridge_num SET DEFAULT nextval('sampling_feature_external_identifier_bridge_num_seq'::regclass);

ALTER TABLE ONLY sampling_feature_external_identifier ADD CONSTRAINT sampling_feature_external_identifier_pkey PRIMARY KEY (bridge_num);
ALTER TABLE ONLY sampling_feature_external_identifier ADD CONSTRAINT uc_sampling_feature_external_identifier UNIQUE (sample_feature_num, sampling_feature_external_id, external_identifier_system_num);





-- Name: sampling_feature_taxonomic_classifier; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE sampling_feature_taxonomic_classifier (
    bridge_num integer NOT NULL,
    sampling_feature_num integer NOT NULL,
    taxonomic_classifier_num integer NOT NULL,
    citation_num integer,
	
);

COMMENT ON TABLE sampling_feature_taxonomic_classifier IS 'will contain information from classification table and more';

CREATE SEQUENCE sampling_feature_taxonomic_classifier_bridge_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE sampling_feature_taxonomic_classifier_bridge_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE sampling_feature_taxonomic_classifier_bridge_num_seq OWNED BY sampling_feature_taxonomic_classifier.bridge_num;

ALTER TABLE ONLY sampling_feature_taxonomic_classifier ALTER COLUMN bridge_num SET DEFAULT nextval('sampling_feature_taxonomic_classifier_bridge_num_seq'::regclass);
ALTER TABLE ONLY sampling_feature_taxonomic_classifier ADD CONSTRAINT sampling_feature_taxonomic_classifier_pkey PRIMARY KEY (bridge_num);
ALTER TABLE ONLY sampling_feature_taxonomic_classifier ADD CONSTRAINT uc_sampling_feature_taxonomic_classifier UNIQUE (sampling_feature_num, taxonomic_classifier_num, citation_num);



-- Name: sampling_feature_type; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE sampling_feature_type (
    sampling_feature_type_num integer NOT NULL,
    sampling_feature_type_name character varying(256) NOT NULL,
    sampling_feature_type_description character varying(2000),
    sampling_feature_type_category character varying(256) NOT NULL,
    sampling_feature_parent_type_num integer,
	source character varying(255),
    status integer DEFAULT 1
);

CREATE SEQUENCE sampling_feature_type_sampling_feature_type_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE sampling_feature_type_sampling_feature_type_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE sampling_feature_type_sampling_feature_type_num_seq OWNED BY sampling_feature_type.sampling_feature_type_num;

ALTER TABLE ONLY sampling_feature_type ALTER COLUMN sampling_feature_type_num SET DEFAULT nextval('sampling_feature_type_sampling_feature_type_num_seq'::regclass);
ALTER TABLE ONLY sampling_feature_type ADD CONSTRAINT sampling_feature_type_pkey PRIMARY KEY (sampling_feature_type_num);
ALTER TABLE ONLY sampling_feature_type ADD CONSTRAINT uc_sampling_feature_type UNIQUE (sampling_feature_type_name);



-- Name: site; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE site (
    sampling_feature_num integer NOT NULL,
    state_num integer NOT NULL,
    country_num integer NOT NULL
);

ALTER TABLE ONLY site ADD CONSTRAINT pksite PRIMARY KEY (sampling_feature_num);



-- Name: spatial_offset; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE spatial_offset (
    spatial_offset_num integer NOT NULL,
    spatial_offset_type_num integer NOT NULL,
    offset1_value double precision NOT NULL,
    offset1_unit_num integer NOT NULL,
    offset2_value double precision,
    offset2_unit_num integer,
    offset3_value double precision,
    offset3_unit_num integer
);

COMMENT ON TABLE spatial_offset IS 'depth_interval';

CREATE SEQUENCE spatial_offset_spatial_offset_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE spatial_offset_spatial_offset_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE spatial_offset_spatial_offset_num_seq OWNED BY spatial_offset.spatial_offset_num;
ALTER TABLE ONLY spatial_offset ALTER COLUMN spatial_offset_num SET DEFAULT nextval('spatial_offset_spatial_offset_num_seq'::regclass);
ALTER TABLE ONLY spatial_offset ADD CONSTRAINT spatial_offset_pkey PRIMARY KEY (spatial_offset_num);
ALTER TABLE ONLY spatial_offset ADD CONSTRAINT uc_spatial_offset UNIQUE (spatial_offset_type_num, offset1_value, offset1_unit_num, offset2_value, offset2_unit_num, offset3_value, offset3_unit_num);



-- Name: spatial_offset_type; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE spatial_offset_type (
    spatial_offset_type_num integer NOT NULL,
    spatial_offset_type_name character varying(256) NOT NULL,
    spatial_offset_type_description character varying(2000),
	spatial_offset_category character varying(255),
    source character varying(255),
    status integer DEFAULT 1
);

CREATE SEQUENCE spatial_offset_type_spatial_offset_type_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE spatial_offset_type_spatial_offset_type_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE spatial_offset_type_spatial_offset_type_num_seq OWNED BY spatial_offset_type.spatial_offset_type_num;
ALTER TABLE ONLY spatial_offset_type ALTER COLUMN spatial_offset_type_num SET DEFAULT nextval('spatial_offset_type_spatial_offset_type_num_seq'::regclass);
ALTER TABLE ONLY spatial_offset_type ADD CONSTRAINT spatial_offset_type_pkey PRIMARY KEY (spatial_offset_type_num);
ALTER TABLE ONLY spatial_offset_type ADD CONSTRAINT uc_spatial_offset_type UNIQUE (spatial_offset_type_name);



-- Name: specimen; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE specimen (
    sampling_feature_num integer NOT NULL,
    material_num integer NOT NULL,
    is_field_specimen boolean DEFAULT false
);

ALTER TABLE ONLY specimen ADD CONSTRAINT pkspecimen PRIMARY KEY (sampling_feature_num);
CREATE INDEX s_material_num_idx ON specimen USING btree (material_num);

-- Name: specimen; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE state (
    state_num integer NOT NULL,
    state_name character varying(50),
    country_num integer NOT NULL,
    state_abbrv character varying(8),
    state_code character varying(64),
    state_numeric_code integer,
    state_category character varying(32),
	source character varying(255),
	status integer DEFAULT 1
);

CREATE SEQUENCE state_state_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE state_state_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE state_state_num_seq OWNED BY state.state_num;
ALTER TABLE ONLY state ALTER COLUMN state_num SET DEFAULT nextval('state_state_num_seq'::regclass);

ALTER TABLE ONLY state ADD CONSTRAINT state_pkey PRIMARY KEY (state_num);
ALTER TABLE ONLY state ADD CONSTRAINT uc_state UNIQUE (state_name, country_num, state_abbrv, state_code, state_numeric_code, state_category);


--
-- Name: status_type; Type: TABLE; Schema: earthchem; Owner: -
CREATE TABLE status_type (
    status_type_num integer NOT NULL,
    status_type_name character varying(255) NOT NULL,
    status_type_description character varying(2000),
	status_type_category character varying(255),
    source character varying(255),
    status integer DEFAULT 1
);
COMMENT ON TABLE status_type IS 'Status_type table proposed by Steve Richard to handle deprecating/activating/proposing new entries in the EarthChem ODM2 database';
-- ******************  need to add FK constraints from status field in tables to status_type vocabulary

INSERT INTO status_type (status_type_num, status_type_name, status_type_description, status_type_category, source, status) VALUES (1, 'active', ' Item shows up in pick lists for new data entry or updates.', NULL, NULL, 1);
INSERT INTO status_type (status_type_num, status_type_name, status_type_description, status_type_category, source, status) VALUES (0, 'deprecated', ' The data item remains in database so any existing FK links will not be broken, and values will appear in reports, but won''t show up in pick lists for new data', NULL, NULL, 1);
INSERT INTO status_type (status_type_num, status_type_name, status_type_description, status_type_category, source, status) VALUES (3, 'superseded', 'data item remains, shouldn''t show up in pick lists, but newer data item should be used in new data, e.g. when someone changes their name. Ideally there should be some identifier for the superseding value...', NULL, NULL, 1);
INSERT INTO status_type (status_type_num, status_type_name, status_type_description, status_type_category, source, status) VALUES (2, 'proposed', 'Data item added by user suggestion. needs review by curator/authority to change status to 1 or replace with existing value.', NULL, NULL, 1);


-- Name: taxonomic_classifier; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE taxonomic_classifier (
    taxonomic_classifier_num integer NOT NULL,
    taxonomic_classifier_category character varying(256) NOT NULL,
    taxonomic_classifier_name character varying(256) NOT NULL,
    taxonomic_classifier_common_name character varying(2000),
    taxonomic_classifier_description character varying(2000),
    parent_taxonomic_classifier_num integer,
	source character varying(255),
    status integer DEFAULT 1
);

CREATE SEQUENCE taxonomic_classifier_taxonomic_classifier_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE taxonomic_classifier_taxonomic_classifier_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE taxonomic_classifier_taxonomic_classifier_num_seq OWNED BY taxonomic_classifier.taxonomic_classifier_num;
ALTER TABLE ONLY taxonomic_classifier ALTER COLUMN taxonomic_classifier_num SET DEFAULT nextval('taxonomic_classifier_taxonomic_classifier_num_seq'::regclass);
ALTER TABLE ONLY taxonomic_classifier ADD CONSTRAINT taxonomic_classifier_pkey PRIMARY KEY (taxonomic_classifier_num);
ALTER TABLE ONLY taxonomic_classifier ADD CONSTRAINT uc_taxonomic_classifier_name_cv UNIQUE (taxonomic_classifier_name, taxonomic_classifier_type_cv, parent_taxonomic_classifier_num);




-- Name: taxonomic_classifier_external_identifer; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE taxonomic_classifier_external_identifer (
    bridge_num integer NOT NULL,
    taxonomic_classifier_num integer NOT NULL,
    taxonomic_classifier_external_identifer character varying(256) NOT NULL,
    taxonomic_classifier_external_identifier_uri character varying(2000),
    external_identifier_system_num integer NOT NULL
);
ALTER TABLE taxonomic_classifier_external_identifer OWNER TO ecdb_dev;

CREATE SEQUENCE taxonomic_classifier_external_identifer_bridge_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE taxonomic_classifier_external_identifer_bridge_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE taxonomic_classifier_external_identifer_bridge_num_seq OWNED BY taxonomic_classifier_external_identifer.bridge_num;
ALTER TABLE ONLY taxonomic_classifier_external_identifer ALTER COLUMN bridge_num SET DEFAULT nextval('taxonomic_classifier_external_identifer_bridge_num_seq'::regclass);
ALTER TABLE ONLY taxonomic_classifier_external_identifer ADD CONSTRAINT taxonomic_classifier_external_identifer_pkey PRIMARY KEY (bridge_num);
ALTER TABLE ONLY taxonomic_classifier_external_identifer ADD CONSTRAINT uc_taxonomic_classifier_external_identifer UNIQUE (taxonomic_classifier_num, taxonomic_classifier_external_identifer, external_identifier_system_num);



-- Name: text_data; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE text_data (
    result_num integer NOT NULL,
    text_data_value character varying(2000) NOT NULL,
    text_data_note character varying(2000)
);
ALTER TABLE text_data OWNER TO ecdb_dev;
COMMENT ON COLUMN text_data.text_data_value IS 'can be color value from inclusion, can be values of horizon, color, texture, structure';
ALTER TABLE ONLY text_data ADD CONSTRAINT pktext_data PRIMARY KEY (result_num);



-- Name: unit; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE unit (
    unit_num integer NOT NULL,
    unit_type character varying(16) NOT NULL,
    unit_abbreviation character varying(16) NOT NULL,
    unit_name character varying(256) NOT NULL
);
ALTER TABLE unit OWNER TO ecdb_dev;

CREATE SEQUENCE unit_unit_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE unit_unit_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE unit_unit_num_seq OWNED BY unit.unit_num;

ALTER TABLE ONLY unit ALTER COLUMN unit_num SET DEFAULT nextval('unit_unit_num_seq'::regclass);
ALTER TABLE ONLY unit
    ADD CONSTRAINT unit_pkey PRIMARY KEY (unit_num);
ALTER TABLE ONLY unit ADD CONSTRAINT uc_unit UNIQUE (unit_type, unit_abbreviation);
ALTER TABLE ONLY unit ADD CONSTRAINT uc_unit_name UNIQUE (unit_name);

CREATE TABLE user_roles (
    user_name character varying(15) NOT NULL,
    role_name character varying(15) NOT NULL
);

CREATE TABLE users (
    user_name character varying(15) NOT NULL,
    user_pass character varying(64) NOT NULL
);

-- Name: variable; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE "variable" (
    variable_num integer NOT NULL,
    variable_code character varying(32) NOT NULL,
    variable_name character varying(2000),
    variable_definition character varying(2000),
    no_data_value boolean DEFAULT false NOT NULL,
    variable_type_num integer NOT NULL,
    source character varying(255),
    status integer DEFAULT 1
);
ALTER TABLE "variable" OWNER TO ecdb_dev;

CREATE SEQUENCE variable_variable_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE variable_variable_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE variable_variable_num_seq OWNED BY "variable".variable_num;

ALTER TABLE ONLY "variable" ALTER COLUMN variable_num SET DEFAULT nextval('variable_variable_num_seq'::regclass);

ALTER TABLE ONLY "variable"
    ADD CONSTRAINT variable_pkey PRIMARY KEY (variable_num);
ALTER TABLE ONLY "variable" ADD CONSTRAINT uc_variable UNIQUE (variable_type_num, variable_code);

CREATE INDEX v_variable_type_num_idx ON "variable" USING btree (variable_type_num);
CREATE INDEX v_variable_code_idx ON "variable" USING btree (variable_code);




-- Name: variable_type; Type: TABLE; Schema: earthchem; Owner: ecdb_dev
CREATE TABLE variable_type (
    variable_type_num integer NOT NULL,
    variable_type_code character varying(255) NOT NULL,
    variable_type_description character varying(2000),
	variable_type_category character varying(255),
    source character varying(255),
    status integer DEFAULT 1
);
ALTER TABLE variable_type OWNER TO ecdb_dev;

CREATE SEQUENCE variable_type_variable_type_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE variable_type_variable_type_num_seq OWNER TO ecdb_dev;
ALTER SEQUENCE variable_type_variable_type_num_seq OWNED BY variable_type.variable_type_num;

ALTER TABLE ONLY variable_type ALTER COLUMN variable_type_num SET DEFAULT nextval('variable_type_variable_type_num_seq'::regclass);
ALTER TABLE ONLY variable_type
    ADD CONSTRAINT variable_type_pkey PRIMARY KEY (variable_type_num);
ALTER TABLE ONLY variable_type ADD CONSTRAINT uc_variable_type_code UNIQUE (variable_type_code);

CREATE INDEX vt_variable_type_code_idx ON variable_type USING btree (variable_type_code);	


/*
********************************************************************************************
Foreign Key constraints. These need to be at the end so we're sure all tables involved
 * have already been defined
*/

ALTER TABLE ONLY action ADD CONSTRAINT fk_action_action_type FOREIGN KEY (action_type_num) REFERENCES action_type(action_type_num);

ALTER TABLE ONLY action ADD CONSTRAINT fk_action_method FOREIGN KEY (method_num) REFERENCES method(method_num);

ALTER TABLE ONLY action ADD CONSTRAINT fk_action_organization FOREIGN KEY (organization_num) REFERENCES organization(organization_num);

ALTER TABLE ONLY action_annotation ADD CONSTRAINT fk_action_annotation_action_num FOREIGN KEY (action_num) REFERENCES action(action_num);

ALTER TABLE ONLY action_annotation ADD CONSTRAINT fk_action_annotation_annotation_num FOREIGN KEY (annotation_num) REFERENCES annotation(annotation_num);

ALTER TABLE ONLY action_by ADD CONSTRAINT fk_action_by_affiliation FOREIGN KEY (affiliation_num) REFERENCES affiliation(affiliation_num);

ALTER TABLE ONLY action_by ADD CONSTRAINT fk_action_person_role_organization_action FOREIGN KEY (action_num) REFERENCES action(action_num);

ALTER TABLE ONLY action_extension_property ADD CONSTRAINT fk_action_extension_property_action FOREIGN KEY (action_num) REFERENCES action(action_num);

ALTER TABLE ONLY action_extension_property ADD CONSTRAINT fk_action_extension_property_extension_property FOREIGN KEY (extension_property_num) REFERENCES extension_property(extension_property_num);

ALTER TABLE ONLY action_external_identifier ADD CONSTRAINT action_external_identifier_action_num_fkey FOREIGN KEY (action_num) REFERENCES action(action_num);

ALTER TABLE ONLY action_external_identifier ADD CONSTRAINT action_external_identifier_external_identifier_system_num_fkey FOREIGN KEY (external_identifier_system_num) REFERENCES external_identifier_system(external_identifier_system_num);

ALTER TABLE ONLY affiliation ADD CONSTRAINT fk_affiliation_organization FOREIGN KEY (organization_num) REFERENCES organization(organization_num);

ALTER TABLE ONLY affiliation ADD CONSTRAINT fk_affiliation_person FOREIGN KEY (person_num) REFERENCES person(person_num);

ALTER TABLE ONLY annotation ADD CONSTRAINT fk_annotation_annotation_type_num FOREIGN KEY (annotation_type_num) REFERENCES annotation_type(annotation_type_num);

ALTER TABLE ONLY annotation ADD CONSTRAINT fk_annotation_data_source_num FOREIGN KEY (data_source_num) REFERENCES citation(citation_num);

ALTER TABLE ONLY array_data ADD CONSTRAINT fk_array_data_result FOREIGN KEY (result_num) REFERENCES result(result_num);

ALTER TABLE ONLY array_data ADD CONSTRAINT fk_array_data_x_unit FOREIGN KEY (x_coord_unit_num) REFERENCES unit(unit_num);

ALTER TABLE ONLY array_data ADD CONSTRAINT fk_array_data_y_unit FOREIGN KEY (y_coord_unit_num) REFERENCES unit(unit_num);

ALTER TABLE ONLY array_data ADD CONSTRAINT fk_array_data_z_unit FOREIGN KEY (z_corrd_unit_num) REFERENCES unit(unit_num);

ALTER TABLE ONLY author_list ADD CONSTRAINT fk_author_list_citation FOREIGN KEY (citation_num) REFERENCES citation(citation_num);

ALTER TABLE ONLY author_list ADD CONSTRAINT fk_author_list_person FOREIGN KEY (person_num) REFERENCES person(person_num);

ALTER TABLE ONLY citation_dataset ADD CONSTRAINT fk_citation_dataset_citation FOREIGN KEY (citation_num) REFERENCES citation(citation_num);

ALTER TABLE ONLY citation_dataset ADD CONSTRAINT fk_citation_dataset_dataset FOREIGN KEY (dataset_num) REFERENCES dataset(dataset_num);

ALTER TABLE ONLY citation_dataset ADD CONSTRAINT fk_citation_dataset_relationship_type FOREIGN KEY (relationship_type_num) REFERENCES relationship_type(relationship_type_num);

ALTER TABLE ONLY citation_external_identifier ADD CONSTRAINT fk_citation_external_identifier_citation FOREIGN KEY (citation_num) REFERENCES citation(citation_num);

ALTER TABLE ONLY citation_external_identifier ADD CONSTRAINT fk_citation_external_identifier_external_identifier FOREIGN KEY (external_identifier_system_num) REFERENCES external_identifier_system(external_identifier_system_num);

ALTER TABLE ONLY data_reduction ADD CONSTRAINT fk_data_reduction_data_reduction_type FOREIGN KEY (data_reduction_type_num) REFERENCES data_reduction_type(data_reduction_type_num);

ALTER TABLE ONLY data_reduction ADD CONSTRAINT fk_data_reduction_variable FOREIGN KEY (variable_num) REFERENCES "variable"(variable_num);

ALTER TABLE ONLY dataquality ADD CONSTRAINT fk_dataquality_dataquality_type FOREIGN KEY (dataquality_type_num) REFERENCES dataquality_type(dataquality_type_num);

ALTER TABLE ONLY dataquality ADD CONSTRAINT fk_dataquality_unit FOREIGN KEY (unit_num) REFERENCES unit(unit_num);

ALTER TABLE ONLY dataset_external_identifier ADD CONSTRAINT fk_dataset_external_identifier_dataset FOREIGN KEY (dataset_num) REFERENCES dataset(dataset_num);

ALTER TABLE ONLY dataset_external_identifier ADD CONSTRAINT fk_dataset_external_identifier_external_identifier FOREIGN KEY (external_identifier_system_num) REFERENCES external_identifier_system(external_identifier_system_num);

ALTER TABLE ONLY dataset_result ADD CONSTRAINT fk_dataset_result_dataset FOREIGN KEY (dataset_num) REFERENCES dataset(dataset_num);

ALTER TABLE ONLY dataset_result ADD CONSTRAINT fk_dataset_result_result FOREIGN KEY (result_num) REFERENCES result(result_num);

ALTER TABLE ONLY ec_log_all_table ADD CONSTRAINT fk_ec_log_all_tables_ec_user FOREIGN KEY (ec_user_num) REFERENCES ec_user(ec_user_num);

ALTER TABLE ONLY ec_status_info ADD CONSTRAINT ec_status_info_citation_num_fkey FOREIGN KEY (citation_num) REFERENCES citation(citation_num);

ALTER TABLE ONLY ec_status_info ADD CONSTRAINT fk_ec_status_control_citation FOREIGN KEY (citation_num) REFERENCES citation(citation_num);

ALTER TABLE ONLY ec_user_group ADD CONSTRAINT fk_ec_user_group_ec_group FOREIGN KEY (ec_group_num) REFERENCES ec_group(ec_group_num);

ALTER TABLE ONLY ec_user_group ADD CONSTRAINT fk_ec_user_group_ec_user FOREIGN KEY (ec_user_num) REFERENCES ec_user(ec_user_num);

ALTER TABLE ONLY ec_user_role ADD CONSTRAINT fk_use_role_user FOREIGN KEY (ec_user_num) REFERENCES ec_user(ec_user_num);

ALTER TABLE ONLY ec_user_role ADD CONSTRAINT fk_user_role_ec_role FOREIGN KEY (ec_role_num) REFERENCES ec_role(ec_role_num);

ALTER TABLE ONLY equipment ADD CONSTRAINT fk_equipment_equipment_type FOREIGN KEY (equipment_type_num) REFERENCES equipment_type(equipment_type_num);

ALTER TABLE ONLY equipment_action ADD CONSTRAINT fk_equipment_action_action FOREIGN KEY (action_num) REFERENCES action(action_num);

ALTER TABLE ONLY equipment_action ADD CONSTRAINT fk_equipment_action_equipment FOREIGN KEY (equipment_num) REFERENCES equipment(equipment_num);

ALTER TABLE ONLY extension_property ADD CONSTRAINT fk_extension_property_unit FOREIGN KEY (property_data_unit_num) REFERENCES unit(unit_num);

ALTER TABLE ONLY feature_action ADD CONSTRAINT fk_feature_action_result_action FOREIGN KEY (action_num) REFERENCES action(action_num);

ALTER TABLE ONLY feature_action ADD CONSTRAINT fk_feature_action_result_sampling_feature FOREIGN KEY (sampling_feature_num) REFERENCES sampling_feature(sampling_feature_num);

ALTER TABLE ONLY feature_of_interest ADD CONSTRAINT fk_feature_of_interest_feature_of_interest_cv FOREIGN KEY (feature_of_interest_cv_num) REFERENCES feature_of_interest_cv(feature_of_interest_cv_num);

ALTER TABLE ONLY feature_of_interest ADD CONSTRAINT fk_feature_of_interest_feature_of_interest_type FOREIGN KEY (feature_of_interest_type_num) REFERENCES feature_of_interest_type(feature_of_interest_type_num);

ALTER TABLE ONLY feature_of_interest ADD CONSTRAINT fk_feature_of_interest_sampling_feature FOREIGN KEY (sampling_feature_num) REFERENCES sampling_feature(sampling_feature_num);

ALTER TABLE ONLY feature_of_interest_annotation ADD CONSTRAINT fk_feature_of_interest_annotation_annotation_num FOREIGN KEY (annotation_num) REFERENCES annotation(annotation_num);

ALTER TABLE ONLY feature_of_interest_annotation ADD CONSTRAINT fk_feature_of_interest_annotation_feature_of_interest_num FOREIGN KEY (feature_of_interest_num) REFERENCES feature_of_interest(feature_of_interest_num);

ALTER TABLE ONLY method ADD CONSTRAINT fk_method_method_type FOREIGN KEY (method_type_num) REFERENCES method_type(method_type_num);

ALTER TABLE ONLY method ADD CONSTRAINT fk_method_organization FOREIGN KEY (organization_num) REFERENCES organization(organization_num);

ALTER TABLE ONLY numeric_data ADD CONSTRAINT fk_numeric_data_result FOREIGN KEY (result_num) REFERENCES result(result_num);

ALTER TABLE ONLY numeric_data ADD CONSTRAINT fk_numeric_data_unit FOREIGN KEY (unit_num) REFERENCES unit(unit_num);

ALTER TABLE ONLY organization ADD CONSTRAINT fk_organization_country FOREIGN KEY (country_num) REFERENCES country(country_num);

ALTER TABLE ONLY organization ADD CONSTRAINT fk_organization_organization FOREIGN KEY (parent_organization_num) REFERENCES organization(organization_num);

ALTER TABLE ONLY organization ADD CONSTRAINT fk_organization_organization_type FOREIGN KEY (organization_type_num) REFERENCES organization_type(organization_type_num);

ALTER TABLE ONLY organization ADD CONSTRAINT fk_organization_state FOREIGN KEY (state_num) REFERENCES state(state_num);

ALTER TABLE ONLY person_external_identifier ADD CONSTRAINT fk_person_external_identifier_external_identifier FOREIGN KEY (external_identifier_system_num) REFERENCES external_identifier_system(external_identifier_system_num);

ALTER TABLE ONLY person_external_identifier ADD CONSTRAINT fk_person_external_identifier_person FOREIGN KEY (person_num) REFERENCES person(person_num);

ALTER TABLE ONLY reference_material_value ADD CONSTRAINT fk_reference_material_value_citation FOREIGN KEY (citation_num) REFERENCES citation(citation_num);

ALTER TABLE ONLY reference_material_value ADD CONSTRAINT fk_reference_material_value_unit FOREIGN KEY (unit_num) REFERENCES unit(unit_num);

ALTER TABLE ONLY reference_material_value ADD CONSTRAINT fk_reference_material_value_variable FOREIGN KEY (variable_num) REFERENCES "variable"(variable_num);

ALTER TABLE ONLY related_action ADD CONSTRAINT fk_parent_action_action FOREIGN KEY (related_action_num) REFERENCES action(action_num);

ALTER TABLE ONLY related_action ADD CONSTRAINT fk_related_action_action FOREIGN KEY (action_num) REFERENCES action(action_num);

ALTER TABLE ONLY related_action ADD CONSTRAINT fk_related_action_relationship_type FOREIGN KEY (relationship_type_num) REFERENCES relationship_type(relationship_type_num);

ALTER TABLE ONLY related_feature ADD CONSTRAINT fk_current_sampling_feature_num FOREIGN KEY (sampling_feature_num) REFERENCES sampling_feature(sampling_feature_num);

ALTER TABLE ONLY related_feature ADD CONSTRAINT fk_feature_parent_spatial_offset FOREIGN KEY (spatial_offset_num) REFERENCES spatial_offset(spatial_offset_num);

ALTER TABLE ONLY related_feature ADD CONSTRAINT fk_related_feature_relationship_type FOREIGN KEY (relationship_type_num) REFERENCES relationship_type(relationship_type_num);

ALTER TABLE ONLY related_feature ADD CONSTRAINT fk_related_parent_sampling_feature_num FOREIGN KEY (related_sampling_feature_num) REFERENCES sampling_feature(sampling_feature_num);

ALTER TABLE ONLY related_result ADD CONSTRAINT fk_related_result_num_result_num FOREIGN KEY (related_result_num) REFERENCES result(result_num);

ALTER TABLE ONLY related_result ADD CONSTRAINT fk_related_result_relationship_type FOREIGN KEY (relationship_type_num) REFERENCES relationship_type(relationship_type_num);

ALTER TABLE ONLY related_result ADD CONSTRAINT fk_related_result_result FOREIGN KEY (result_num) REFERENCES result(result_num);

ALTER TABLE ONLY result ADD CONSTRAINT fk_result_feature_action FOREIGN KEY (feature_action_num) REFERENCES feature_action(feature_action_num);

ALTER TABLE ONLY result ADD CONSTRAINT fk_result_processing_level FOREIGN KEY (processing_level_num) REFERENCES processing_level(processing_level_num);

ALTER TABLE ONLY result ADD CONSTRAINT fk_result_reference_material_value FOREIGN KEY (reference_material_value_num) REFERENCES reference_material_value(reference_material_value_num);

ALTER TABLE ONLY result ADD CONSTRAINT fk_result_result_type FOREIGN KEY (result_type_num) REFERENCES result_type(result_type_num);

ALTER TABLE ONLY result ADD CONSTRAINT fk_result_taxonomic_classifier FOREIGN KEY (taxonomic_classifier_num) REFERENCES taxonomic_classifier(taxonomic_classifier_num);

ALTER TABLE ONLY result ADD CONSTRAINT fk_result_variable FOREIGN KEY (variable_num) REFERENCES "variable"(variable_num);

ALTER TABLE ONLY result_annotation ADD CONSTRAINT fk_result_annotation_annotation_num FOREIGN KEY (annotation_num) REFERENCES annotation(annotation_num);

ALTER TABLE ONLY result_annotation ADD CONSTRAINT fk_result_annotation_result_num FOREIGN KEY (result_num) REFERENCES result(result_num);

ALTER TABLE ONLY result_data_reduction ADD CONSTRAINT fk_result_data_reduction_data_reduction FOREIGN KEY (data_reduction_num) REFERENCES data_reduction(data_reduction_num);

ALTER TABLE ONLY result_data_reduction ADD CONSTRAINT fk_result_data_reduction_result FOREIGN KEY (result_num) REFERENCES result(result_num);

ALTER TABLE ONLY result_dataquality ADD CONSTRAINT fk_result_dataquality_dataquality FOREIGN KEY (dataquality_num) REFERENCES dataquality(dataquality_num);

ALTER TABLE ONLY result_dataquality ADD CONSTRAINT fk_result_dataquality_result FOREIGN KEY (result_num) REFERENCES result(result_num);

ALTER TABLE ONLY result_history ADD CONSTRAINT fk_result_history_numeric_data FOREIGN KEY (numeric_data_num) REFERENCES numeric_data(numeric_data_num) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY sampling_feature ADD CONSTRAINT fk_sampling_feature_sampling_feature_type FOREIGN KEY (sampling_feature_type_num) REFERENCES sampling_feature_type(sampling_feature_type_num);

ALTER TABLE ONLY sampling_feature_annotation ADD CONSTRAINT fk_sampling_feature_annotation_annotation_num FOREIGN KEY (annotation_num) REFERENCES annotation(annotation_num);

ALTER TABLE ONLY sampling_feature_annotation ADD CONSTRAINT fk_sampling_feature_annotation_sampling_feature_num FOREIGN KEY (sampling_feature_num) REFERENCES sampling_feature(sampling_feature_num);

ALTER TABLE ONLY sampling_feature_extension_property ADD CONSTRAINT fk_sampling_feature_extension_property_extension_property FOREIGN KEY (extension_property_num) REFERENCES extension_property(extension_property_num);

ALTER TABLE ONLY sampling_feature_extension_property ADD CONSTRAINT fk_sampling_feature_extension_property_sampling_feature FOREIGN KEY (sampling_feature_num) REFERENCES sampling_feature(sampling_feature_num);

ALTER TABLE ONLY sampling_feature_external_identifier ADD CONSTRAINT fk_sampling_feature_external_identifier_external_identifier FOREIGN KEY (external_identifier_system_num) REFERENCES external_identifier_system(external_identifier_system_num);

ALTER TABLE ONLY sampling_feature_external_identifier ADD CONSTRAINT fk_sampling_feature_external_identifier_sampling_feature FOREIGN KEY (sample_feature_num) REFERENCES sampling_feature(sampling_feature_num);

ALTER TABLE ONLY sampling_feature_taxonomic_classifier ADD CONSTRAINT fk_sampling_feature_taxonomic_classifier_sampling_feature FOREIGN KEY (sampling_feature_num) REFERENCES sampling_feature(sampling_feature_num);

ALTER TABLE ONLY sampling_feature_taxonomic_classifier ADD CONSTRAINT fk_sampling_feature_taxonomic_classifier_taxonomic_classifier FOREIGN KEY (taxonomic_classifier_num) REFERENCES taxonomic_classifier(taxonomic_classifier_num);

ALTER TABLE ONLY sampling_feature_type ADD CONSTRAINT sampling_feature_type_sampling_feature_parent_type_num_fkey FOREIGN KEY (sampling_feature_parent_type_num) REFERENCES sampling_feature_type(sampling_feature_type_num);

ALTER TABLE ONLY site ADD CONSTRAINT fk_site_country FOREIGN KEY (country_num) REFERENCES country(country_num);

ALTER TABLE ONLY site ADD CONSTRAINT fk_site_sampling_feature FOREIGN KEY (sampling_feature_num) REFERENCES sampling_feature(sampling_feature_num);

ALTER TABLE ONLY site ADD CONSTRAINT fk_site_state FOREIGN KEY (state_num) REFERENCES state(state_num);

ALTER TABLE ONLY spatial_offset ADD CONSTRAINT fk_spatial_offset_spatial_offset_type FOREIGN KEY (spatial_offset_type_num) REFERENCES spatial_offset_type(spatial_offset_type_num);

ALTER TABLE ONLY spatial_offset ADD CONSTRAINT fk_spatial_offset1_unit FOREIGN KEY (offset1_unit_num) REFERENCES unit(unit_num);

ALTER TABLE ONLY spatial_offset ADD CONSTRAINT fk_spatial_offset2_unit FOREIGN KEY (offset2_unit_num) REFERENCES unit(unit_num);

ALTER TABLE ONLY spatial_offset ADD CONSTRAINT fk_spatial_offset3_unit FOREIGN KEY (offset3_unit_num) REFERENCES unit(unit_num);

ALTER TABLE ONLY specimen ADD CONSTRAINT fk_specimen_material FOREIGN KEY (material_num) REFERENCES material(material_num);

ALTER TABLE ONLY specimen ADD CONSTRAINT fk_specimen_sampling_feature FOREIGN KEY (sampling_feature_num) REFERENCES sampling_feature(sampling_feature_num);

ALTER TABLE ONLY state ADD CONSTRAINT fk_state_country FOREIGN KEY (country_num) REFERENCES country(country_num);

ALTER TABLE ONLY taxonomic_classifier ADD CONSTRAINT fk_taxonomic_classifier_taxonomic_classifier FOREIGN KEY (parent_taxonomic_classifier_num) REFERENCES taxonomic_classifier(taxonomic_classifier_num);

ALTER TABLE ONLY taxonomic_classifier_external_identifer ADD CONSTRAINT fk_taxonomic_classifier_external_identifer_external_identifier FOREIGN KEY (external_identifier_system_num) REFERENCES external_identifier_system(external_identifier_system_num);

ALTER TABLE ONLY taxonomic_classifier_external_identifer ADD CONSTRAINT fk_taxonomic_classifier_external_identifer_taxonomic_classifier FOREIGN KEY (taxonomic_classifier_num) REFERENCES taxonomic_classifier(taxonomic_classifier_num);

ALTER TABLE ONLY text_data ADD CONSTRAINT fk_text_data_result FOREIGN KEY (result_num) REFERENCES result(result_num) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY variable ADD CONSTRAINT fk_variable_variable_type_num FOREIGN KEY (variable_type_num) REFERENCES variable_type(variable_type_num);

CREATE MATERIALIZED VIEW data_availability_vw AS
 SELECT v.variable_definition,
    vt.variable_type_description,
    count(v.variable_definition) AS count
   FROM ((((sampling_feature q
     JOIN ((feature_action fa
     JOIN action a ON ((fa.action_num = a.action_num)))
     JOIN method m ON ((a.method_num = m.method_num))) ON ((q.sampling_feature_num = fa.sampling_feature_num)))
     JOIN result r ON ((fa.feature_action_num = r.feature_action_num)))
     JOIN "variable" v ON ((v.variable_num = r.variable_num)))
     JOIN variable_type vt ON ((v.variable_type_num = vt.variable_type_num)))
  GROUP BY v.variable_definition, vt.variable_type_description
  ORDER BY v.variable_definition
  WITH NO DATA;
ALTER TABLE data_availability_vw OWNER TO ecdb_dev;



