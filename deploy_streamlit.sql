-- ============================================================================
-- Snowflake Streamlit App Deployment Script
-- ============================================================================
-- This script creates a Streamlit app in Snowflake for the Medical Agent Chatbot
-- ============================================================================

-- Use Hospital database
USE DATABASE HOSPITAL;
USE SCHEMA PUBLIC;

-- Create the Streamlit app
-- Note: You need to upload the app.py file to a Snowflake stage first
-- Replace 'your_stage_name' with your actual stage name

CREATE OR REPLACE STREAMLIT MEDICAL_CHATBOT
FROM '@your_stage_name/app.py'
MAIN_FILE = 'app.py'
QUERY_WAREHOUSE = 'COMPUTE_WH'
COMMENT = 'Medical Agent Chatbot for healthcare professionals';

-- Grant usage to appropriate roles/users
-- GRANT USAGE ON STREAMLIT MEDICAL_CHATBOT TO ROLE your_role;

-- Show the Streamlit app details
SHOW STREAMLITS;

-- To get the URL for your Streamlit app, use:
-- SELECT SYSTEM$GET_STREAMLIT_URL('HOSPITAL.PUBLIC.MEDICAL_CHATBOT');
