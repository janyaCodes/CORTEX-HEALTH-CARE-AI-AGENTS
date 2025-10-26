-- ============================================================================
-- Snowflake Setup Script for Hospital Database
-- ============================================================================
-- This script creates:
-- 1. Hospital database
-- 2. Two tables for structured and unstructured health data
-- 3. Internal stage with SSE encryption
-- 4. Cortex Search service on unstructured data table
-- ============================================================================

-- Use appropriate warehouse (adjust to your warehouse name)
USE WAREHOUSE COMPUTE_WH;

-- ============================================================================
-- 1. DATABASE CREATION
-- ============================================================================

-- Create Hospital database
CREATE DATABASE IF NOT EXISTS HOSPITAL
COMMENT = 'Hospital database for storing structured and unstructured health data';

USE DATABASE HOSPITAL;

USE SCHEMA PUBLIC;

-- ============================================================================
-- 2. FILE FORMAT CREATION
-- ============================================================================

-- Create file format for CSV files
CREATE OR REPLACE FILE FORMAT CSV_FORMAT
TYPE = 'CSV'
FIELD_DELIMITER = ','
RECORD_DELIMITER = '\n'
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
TRIM_SPACE = TRUE
ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
ESCAPE = 'NONE'
ESCAPE_UNENCLOSED_FIELD = '\134'
DATE_FORMAT = 'AUTO'
TIMESTAMP_FORMAT = 'AUTO'
NULL_IF = ('NULL', 'null', 'Null', '');

-- Create file format for Excel files (handled as CSV-like or stored as binary)
CREATE OR REPLACE FILE FORMAT EXCEL_FORMAT
TYPE = 'CSV'
FIELD_DELIMITER = ','
RECORD_DELIMITER = '\n'
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
TRIM_SPACE = TRUE
ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
NULL_IF = ('NULL', 'null', 'Null', '');

-- ============================================================================
-- 3. STAGE CREATION WITH SSE ENCRYPTION
-- ============================================================================

-- Create internal stage with SSE encryption
CREATE OR REPLACE STAGE HEALTH_DATA_STAGE
FILE_FORMAT = (FORMAT_NAME = CSV_FORMAT)
ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE')
COMMENT = 'Internal stage for health data files with SSE encryption';

-- ============================================================================
-- 4. TABLE CREATION
-- ============================================================================

-- Create PATIENTS_STRUCTURED table (from patients_structured.csv)
CREATE OR REPLACE TABLE PATIENTS_STRUCTURED (
    PATIENT_ID VARCHAR(50) PRIMARY KEY,
    ACCOUNT_NUMBER VARCHAR(50),
    MRN VARCHAR(50),
    FIRST_NAME VARCHAR(100),
    LAST_NAME VARCHAR(100),
    DOB DATE,
    AGE NUMBER(3,0),
    SEX VARCHAR(20),
    ADDRESS VARCHAR(200),
    CITY VARCHAR(100),
    STATE VARCHAR(50),
    ZIP VARCHAR(20),
    PHONE VARCHAR(50),
    EMAIL VARCHAR(200),
    INSURANCE VARCHAR(100),
    PRIMARY_CARE_PROVIDER VARCHAR(200),
    ALLERGIES VARCHAR(500),
    CHRONIC_CONDITIONS VARCHAR(1000),
    LOAD_TIMESTAMP TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
)
COMMENT = 'Structured patient data from CSV file';

-- Create HEALTH_AGENT_UNSTRUCTURED table (from health_agent_unstructured.xlsx)
CREATE OR REPLACE TABLE HEALTH_AGENT_UNSTRUCTURED (
    ID NUMBER AUTOINCREMENT START 1 INCREMENT 1 PRIMARY KEY,
    UNSTRUCTURED_DATA VARCHAR(16777216),
    FILE_NAME VARCHAR(500),
    UPLOAD_DATE TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    METADATA VARIANT
)
COMMENT = 'Unstructured health agent data from Excel file for Cortex Search';

-- ============================================================================
-- 5. CORTEX SEARCH SERVICE CREATION
-- ============================================================================

-- Create Cortex Search service on unstructured data
CREATE OR REPLACE CORTEX SEARCH SERVICE HEALTH_UNSTRUCTURED_SEARCH
  ON UNSTRUCTURED_DATA
  WAREHOUSE = 'COMPUTE_WH'
  TARGET_LAG = '1 hour'
  EMBEDDING_MODEL = 'snowflake-arctic-embed-m-v1.5'
AS
  SELECT UNSTRUCTURED_DATA
  FROM HEALTH_AGENT_UNSTRUCTURED;

-- ============================================================================
-- 6. SAMPLE DATA LOADING (Optional - for reference)
-- ============================================================================

/*
-- Example: Load data from stage to PATIENTS_STRUCTURED table
COPY INTO PATIENTS_STRUCTURED
FROM @HEALTH_DATA_STAGE/patients_structured.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

-- Example: Insert sample unstructured data
INSERT INTO HEALTH_AGENT_UNSTRUCTURED (UNSTRUCTURED_DATA, FILE_NAME)
VALUES 
    ('Sample unstructured health data content', 'health_agent_unstructured.xlsx'),
    ('Medical notes and observations', 'health_agent_unstructured.xlsx');
*/

-- ============================================================================
-- 7. VIEWS FOR QUICK ACCESS (Optional)
-- ============================================================================

-- View for recent patient entries
CREATE OR REPLACE VIEW V_RECENT_PATIENTS AS
SELECT 
    PATIENT_ID,
    FIRST_NAME,
    LAST_NAME,
    DOB,
    AGE,
    CITY,
    STATE,
    PRIMARY_CARE_PROVIDER,
    CHRONIC_CONDITIONS,
    LOAD_TIMESTAMP
FROM PATIENTS_STRUCTURED
ORDER BY LOAD_TIMESTAMP DESC;

-- View for searchable unstructured content
CREATE OR REPLACE VIEW V_UNSTRUCTURED_CONTENT AS
SELECT 
    ID,
    LEFT(UNSTRUCTURED_DATA, 200) AS CONTENT_PREVIEW,
    FILE_NAME,
    UPLOAD_DATE
FROM HEALTH_AGENT_UNSTRUCTURED
ORDER BY UPLOAD_DATE DESC;

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Verify database and schema
SELECT CURRENT_DATABASE(), CURRENT_SCHEMA();

-- List all tables
SHOW TABLES;

-- List the stage
SHOW STAGES;

-- List Cortex Search services
SHOW CORTEX SEARCH SERVICES;

-- ============================================================================
-- SCRIPT COMPLETED
-- ============================================================================

