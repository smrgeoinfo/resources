--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.3
-- Dumped by pg_dump version 10.0

-- Started on 2017-11-15 11:41:01

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
-- TOC entry 211 (class 1259 OID 85974)
-- Name: keyword_nsidc; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE keyword_nsidc (
    id text NOT NULL,
    keyword_id text,
    keyword_type_id text,
    keyword_description text,
    keyword_label text
);


ALTER TABLE keyword_nsidc OWNER TO postgres;

--
-- TOC entry 2583 (class 0 OID 0)
-- Dependencies: 211
-- Name: TABLE keyword_nsidc; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE keyword_nsidc IS 'keywords from AGDS, not used for DataCite or ISO metadata in geoportal';


--
-- TOC entry 2584 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN keyword_nsidc.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN keyword_nsidc.id IS 'original id column from USAP database, leave for backward compatibility. This value will be copied into label; label may subsequently be edited to reduce duplication';


--
-- TOC entry 2585 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN keyword_nsidc.keyword_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN keyword_nsidc.keyword_id IS 'add in the original usap keyword table, for consistency';


--
-- TOC entry 2578 (class 0 OID 85974)
-- Dependencies: 211
-- Data for Name: keyword_nsidc; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('10 m temperature', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ablation', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('accumulation', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Accumulation processes', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('accumulation rates', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('active layer observations', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Active Layer Thickness', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Admundsen-Scott Station', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Aerogeophysics', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Aerosols', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('AGDC', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('AGDC-project', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Airborne geophysical survey of the Amundsen Sea Embayment, Antarctica (AGASEA)', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Airborne Laser Altimeters', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Airborne Laser Altimetry', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Airborne Radar Sounding', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Air Temperature', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Air Temperatures', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Alley Ice Stream', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Altimetry', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Aluminum-26', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ammonium (NH4)', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Amundsen Basin', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Amundsen Sea Embayment', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Annual Layer Thickness', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Antarctic', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Antarctica', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('ANTARCTIC GLACIATIONS', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Antarctic Ice Sheet', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Antarctic Peninsula', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Aqua', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Argon Isotopes', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Atmospheric Chemistry', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Atmospheric CO2', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Atmospheric Gases', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('atmospheric humidity measurements', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Atmospheric Pressure', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('atmospheric pressure measurements', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Atmospheric Surface Winds', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Automated Weather Stations', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Automatic Weather Stations', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('AVHRR', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('AWS', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('AWS Byrd Station', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('AWS Climate Data', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('AWS Lettau', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('AWS Lynn', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('AWS Siple', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Basal Debris', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Basal Freeze-on', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Basal freezing', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Basal Ice', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Basal Shear Stress', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Basal Water', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('bed and surface elevation deviatoric stresses', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('bed elevations', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Bed Geometry', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Bed Reflectivity', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Bedrock Elevation', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Beryllium-10', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Bindschadler Ice Stream', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('biogenic sulfur', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Borehole', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Boreholes', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Borehole Temperatures', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Borehole Video', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('borehole video camera', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Breakup', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Brimstone Peak', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Brown Glacier', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('bubble', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Bubble Number-Density', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Byrd Polar Research Center', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Calcium (CA)', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Calving', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Calving Rate', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Carbon', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('CARBON-13', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Carbon Dioxide', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('carbon disulfide', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('CARBON ISOTOPES', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('carbonyl sulfide', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Casertz', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('CH4 concentrations', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('chemical composition', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Chloride (CL)', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Chlorine', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Chlorine-36', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('chromatography', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Climate', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Climate Change', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Climate Research', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Climate Variation', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('CO2', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('CO2 concentrations', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('CO2 Uncertainty', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Coastal', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Conservative Temperature', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('CONTINENTAL ICE SHEET', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Cosmogenic nuclide', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('CRREL', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Cryosphere', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('d18O', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('DAAC', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('delta 13C', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('deltaD', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('delta deuterium', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Dem', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('DEMs-project', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('densification', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Density', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Depth', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('depth to ice-cemented ground', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Deuterium', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Deuterium Excess', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Deuterium Isotopes', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Digital Elevation Model', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Dry Permafrost', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('East Antarctic', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('East  Antarctic Plateau', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('electrical', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Electron Backscatter Diffraction', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Elemental Ratios', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Elevation', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Emissivity Modeling', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Engelhardt Ridge', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('englacial', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Environmental Modeling', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('EOSDIS', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Erosion', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('ethane', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('EXPLORATIONS', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Exposure age', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('fabric', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('FEI XL30 Environmental Scanning Electron Microscope - Field Emission Gun (ESEM - FEG)', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Field Investigations', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Filchner Ice Shelf', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Firn', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('firn air', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('firn air chemistry', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Firn Air Isotope Measurements', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Firn Air Isotopes', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('firn air samples', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('firn core', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Firn Isotopes', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Firn Permeability', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Firn Temperature', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Firn Temperature Measurements', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Floating Ice', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Flux', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Gas Age', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('GAS CHROMATOGRAPHY', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Gas Isotopes', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('gas measurement', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('gas record', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Geochemistry', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('GEODETIC GPS DATA', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Glacier', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('glaciers', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Glacier Surface', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Glacier Surface Ablation', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Glacier Surface Ablation Rate', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Glaciology', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Glass Shards', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Glass spherules', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Global Positioning Systems', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('GPR', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('GPS', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('GPS data', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('GPS OBSERVATIONS', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Greenhouse Gases', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Greenland', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Greenland Ice Cap', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Greenland Ice Sheet Project 2', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ground Ice', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ground ice thickness', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('grounding line', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('ground penetrating radar', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('horizontal ice core', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Hydrogen Peroxide', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Hydrology', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Acceleration', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Age', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Analysis', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Iceberg', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('iceberg kinetic engergy', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Icebergs', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('iceberg velocity', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Breakup', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('ICE CAP', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('ice chemistry', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Core', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Core Chemistry', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Core Data', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Core Depth', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('ice core dust', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Core Gas Age', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Core Gas Composition', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Core Gas Records', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Core Interpretation', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Cores', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Core Stratigraphy', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Cover', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Deformation', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Dynamic', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Extent', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('ice fabric', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Floe', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Flow', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Melt', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Motion', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Movement', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Penetrating Radar', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Position', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('ice radar', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('ICESat', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Sheet', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Sheet Elevation', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('ice sheets', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Sheet Thickness', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Shelf', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice shelf meltwater', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Shelf Temperature', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Shelves', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Stratigraphy', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Stream', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Stream C Velocities', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Stream Flow', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Stream Margins', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('ice stream motion', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('ICE STREAMS', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Surface', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Surface Elevation', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Surface Temperature', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Surveys', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Temperature', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Thickness', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Thickness Distribution', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('ice velocities', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Velocity', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('ICE VELOCITY DATA', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Inland', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Interior', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Internal Layer Geometry', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('internal layering', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('interplanetary dust', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ion Chemistry', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ion Chromatograph', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ions', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Iron Oxide', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Isotope', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('ISOTOPES', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Isotopic Anomalies', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Isotopic History', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('ITASE', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Jacobel', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Kamb Ice Stream', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Krypton', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Laboratory investigation', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Laboratory investigations', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Lake Vostok', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('LANDSAT', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Larsen Ice Shelf', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Latitude', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('layers', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Lead-210 Profile', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('MacAyeal Ice Stream', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Magnesium', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Magnesium Oxide', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Manganese Oxide', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('MAPPING GPS DATA', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Mass Balance', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Mass Spectrometer', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('mass spectrometers', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Mass Spectrometry', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('measurements', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Megadunes', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Melt', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Methane', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('methane concentration', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('methane isotopes', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Methanesulfonate', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Methane Sulfonic Acid', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('METHYL BROMIDE', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('METHYL CHLORIDE', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Micrometeorites', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('microparticles', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('microparticles size', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Microstructure', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Model', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Modeling', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Model Input Data', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('MODEL OUTPUT', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('MODELS', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('MODIS', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('MODIS-related project', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('MSA', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Mt. DeWitt', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('NASA', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('n-butane', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Near-surface Air Temperatures', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Nickel Oxide', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Nitrate', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Nitrate (NO3)', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Nitrogen', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Nitrogen Isotopes', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('NSF', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('NSIDC', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('NSIDC-0098', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('NSIDC-0099', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('NSIDC-0100', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('NSIDC-0106', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('NSIDC-0107', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('NSIDC-0108', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('NSIDC-0110', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('NSIDC-0113', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('NSIDC-0255', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('NSIDC-0263', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('NSIDC-0264', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('NSIDC-0269', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('NSIDC-0279', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('NSIDC > National Snow and Ice D', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('NSIDC > National Snow and Ice Data Center', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ocean Depth', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ocean Melt Rate', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('ocean temperature', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Office of Polar Programs', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('OPP-0126343', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('OPP-9316564', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('OPP9615167', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('OPP-9615167', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Oxygen', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('oxygen isotope', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Oxygen Isotopes', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('OZONE DEPLETION', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Paleoclimate', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Paleoenvironments', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Paleotemperature', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Passive Microwave Brightness Temperatures', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Photographs', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Photos', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('PICO', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Pine Island Glacier', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Polar', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Polar Firn Air', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Potassium Dioxide', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Potassium (K)', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Pressure', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('propane', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Radar', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Radar Altimetry', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Radar Echo Sounders', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Radar Echo Sounding', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('radioactive decay', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('RAMP', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('RAMP-project', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Raymond Ridge', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Remote Sensing', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('ROCK SAMPLES', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ronne Ice Shelf', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ross-Amundsen Divide', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ross Embayment', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ross Ice Shelf', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Satellite', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Satellite Imagery', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Satellite Radar Data', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Satellites', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Scanning Multichannel Microwave Radiometer', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('sea ice mass balance', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Sea Ice Temperatures', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Sea Ice Thickness', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Sea Ice Velocity', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Sea Level Rise', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Seasonal Snow Cover', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Seasonal Temperature Changes', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Seasonal Temperature Gradients', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Seismic, gps, geodetic', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('seismology', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('seismometer', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('SEM/EMAX', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Shabtaie Ridge', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('shallow core', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Shallow Firn Air', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Silicon Dioxide', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Simple Dome', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Siple', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Siple Coast', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Siple Dome', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Snow', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Snow Accumulation', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Snow Chemistry', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Snow Densification', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Snow Density', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Snow Depth', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Snowfall', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('snow grain size', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Snow Melt', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Snow Permeability', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Snow Pit', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Snow Pits', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Snow Properties', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Snow Samples', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Snow Stratigraphy', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Snow Temperature', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('snow temperature measurements', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('snow temperatures', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Snow Water Equivalent', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('SOAR > Support Office for Aerogeophysical Research', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Sodium (NA)', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Solar Radiation', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('South Pole', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('South Pole Water Well', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Special Sensor Microwave/Imager', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('SSM/I', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('SSMR', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Stable Isotopes', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('stratigraphy', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('subglacial', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('subglacial and supraglacial water depth', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Subglacial Observations', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Subglacial Topography', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Sublimation Rate', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Sulfate', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Sulfate (SO4)', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Sulfur Dioxide', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Surface Accumulation Rate', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Surface Elevation', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('SURFACE EXPOSURE DATES', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Surface Geometry', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Surface mass balance', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Surface Melt Rate', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Surface Morphology', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('surface temperature measurements', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Surface Temperatures', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Surface Winds', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('surface wind speed measurements', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Synthetic Aperture Radar Imagery', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Taylor Dome', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Taylor Glacier', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Tbs', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Temperature', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Temperature Profiles', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Tephra', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Terminus', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Terra', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Terrain Elevation', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('thermal conductivity', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Thermal Diffusion', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Thermal Fractionation', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('thermometry', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Thwaites Glacier', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Titanium Dioxide', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Total Ice Area', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Total Ice Volume', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('trace elements', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Trapped Air Bubbles', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Trapped Gases', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Traverses', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Unicorn', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('USITASE', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('U.S. ITASE', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('US ITASE', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('VELMAP', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Velocity Measurements', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Vertical motions', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Vertical Strain Rate', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Visual Observations', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Volcanic', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('volcanic deposits', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Vostok', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('WAIS', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('WAISCORES', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('WAIS Divide', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('weddell sea', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('West Antarctica', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('West Antarctic Ice Sheet', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('West Antarctic Ice Sheet Instability', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Western Divide Core', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Whillans Ice Stream', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Wind Direction', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Wind Speed', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Xenon', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Atmospheric boundary layer', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('atmospheric chemistry', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('bedrock ice core', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Biomass burning', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('black carbon (BC) aerosols', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('climate variability', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('CTD profiles', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('diving behavior', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Eddy-covariance measurements', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Holocene', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('ice core', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Ice Station Weddell', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('multi-disciplinary', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('paleoclimate', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Radiative fluxes (surface level)', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('raised beaches', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('satellite tracking', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('sea level', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Turbulent surface fluxes', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('WAIS project', NULL, NULL, NULL, NULL);
INSERT INTO keyword_nsidc (id, keyword_id, keyword_type_id, keyword_description, keyword_label) VALUES ('Weddell seal', NULL, NULL, NULL, NULL);


--
-- TOC entry 2440 (class 2606 OID 90903)
-- Name: keyword_nsidc keyword_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY keyword_nsidc
    ADD CONSTRAINT keyword_pkey PRIMARY KEY (id);


-- Completed on 2017-11-15 11:41:02

--
-- PostgreSQL database dump complete
--

