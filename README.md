# 🏥 Medical Agent Chatbot

A simple Streamlit chatbot that runs **inside Snowflake** and integrates with Snowflake's Medical Agent to provide healthcare professionals with quick access to patient data and medical insights.

## Features

- 🤖 **Interactive Chat Interface**: Clean, user-friendly chat interface
- 🏥 **Medical Agent Integration**: Direct integration with Snowflake's Medical Agent
- 📊 **Patient Data Access**: Query structured patient information and unstructured encounter notes
- 💡 **Sample Questions**: Pre-built sample questions to get started quickly
- ☁️ **Native Snowflake**: Runs directly in Snowflake using Streamlit-in-Snowflake

## 📋 Prerequisites

- A Snowflake account (free trial available)
- Basic understanding of SQL (helpful but not required)
- No local software installation needed!

## 🚀 Complete Setup Guide for New Snowflake Users

### Step 1: Create a Snowflake Account

1. **Sign up for Snowflake**:
   - Go to [https://signup.snowflake.com/](https://signup.snowflake.com/)
   - Choose "Start for Free" to get a 30-day free trial
   - Fill in your details and verify your email

2. **Choose your cloud provider and region**:
   - Select AWS, Azure, or Google Cloud
   - Choose a region close to your location
   - Your account URL will be: `https://[account].snowflakecomputing.com`

3. **Complete account setup**:
   - Set up your username and password
   - Choose your account name (this becomes your account identifier)

### Step 2: Access Snowflake Web Interface

1. **Log into Snowflake**:
   - Go to your account URL
   - Use your username and password to log in

2. **Navigate to Worksheets**:
   - Click on "Worksheets" in the left sidebar
   - This is where you'll run SQL commands

### Step 3: Set Up Your Environment

1. **Create a Warehouse** (if not already created):
   ```sql
   CREATE WAREHOUSE IF NOT EXISTS COMPUTE_WH
   WAREHOUSE_SIZE = 'X-SMALL'
   AUTO_SUSPEND = 60
   AUTO_RESUME = TRUE
   INITIALLY_SUSPENDED = TRUE;
   ```

2. **Use the warehouse**:
   ```sql
   USE WAREHOUSE COMPUTE_WH;
   ```

### Step 4: Set Up the Hospital Database

1. **Run the database setup script**:
   - Copy the contents of `setup_hospital_db.sql`
   - Paste it into a new worksheet
   - Click "Run" to execute the script
   - This creates the HOSPITAL database and required tables

2. **Verify the setup**:
   ```sql
   USE DATABASE HOSPITAL;
   USE SCHEMA PUBLIC;
   SHOW TABLES;
   ```

### Step 5: Load Sample Data

1. **Upload CSV files to Snowflake**:
   - In the Snowflake UI, go to "Data" → "Databases"
   - Navigate to HOSPITAL → PUBLIC → Tables
   - Click on "PATIENTS_STRUCTURED" table
   - Click "Load Data" and upload `data/patients_structured.csv`

2. **Upload unstructured data**:
   - Navigate to "HEALTH_AGENT_UNSTRUCTURED" table
   - Click "Load Data" and upload `data/health_agent_unstructured.xlsx`
   - Or manually insert sample data:
   ```sql
   INSERT INTO HEALTH_AGENT_UNSTRUCTURED (UNSTRUCTURED_DATA, FILE_NAME)
   VALUES 
       ('Patient John Doe visited with chest pain. Vital signs stable. Ordered EKG and chest X-ray.', 'sample_encounter.txt'),
       ('Patient Jane Smith follow-up for diabetes management. Blood sugar levels improved.', 'sample_encounter.txt');
   ```

### Step 6: Create Semantic View

1. **Run the semantic view script**:
   - Copy the contents of `semantic_view.sql`
   - Paste it into a new worksheet
   - Click "Run" to execute

2. **Verify the semantic view**:
   ```sql
   SHOW SEMANTIC VIEWS;
   ```

### Step 7: Create the Medical Agent

1. **Run the agent creation script**:
   - Copy the contents of `createagent.sql`
   - Paste it into a new worksheet
   - Click "Run" to execute

2. **Verify the agent**:
   ```sql
   SHOW AGENTS;
   ```

### Step 8: Enable Streamlit in Snowflake

1. **Check if Streamlit is available**:
   ```sql
   SHOW PARAMETERS LIKE 'ENABLE_STREAMLIT';
   ```

2. **If not enabled, contact your Snowflake administrator** to enable Streamlit-in-Snowflake feature

### Step 9: Deploy the Streamlit App

1. **Create a stage for your files**:
   ```sql
   CREATE OR REPLACE STAGE my_streamlit_stage;
   ```

2. **Upload the app.py file**:
   - Go to "Data" → "Databases" → "HOSPITAL" → "PUBLIC" → "Stages"
   - Click on your stage
   - Click "Upload Files" and select `app.py`

3. **Create the Streamlit app**:
   ```sql
   CREATE OR REPLACE STREAMLIT MEDICAL_CHATBOT
   FROM '@my_streamlit_stage'
   MAIN_FILE = 'app.py'
   QUERY_WAREHOUSE = 'COMPUTE_WH'
   COMMENT = 'Medical Agent Chatbot for healthcare professionals';
   ```

4. **Get the app URL**:
   ```sql
   SELECT SYSTEM$GET_STREAMLIT_URL('HOSPITAL.PUBLIC.MEDICAL_CHATBOT');
   ```

### Step 10: Access Your Chatbot

1. **Open the Streamlit app**:
   - Copy the URL from the previous step
   - Open it in a new browser tab
   - You should see the Medical Agent Chatbot interface

2. **Test the chatbot**:
   - Try asking: "How many patients live in Dallas?"
   - Use the sample questions in the sidebar
   - Verify the agent responds with patient data

## 🎯 Quick Start Commands

If you're familiar with Snowflake, here are the essential commands:

```sql
-- 1. Set up warehouse
USE WAREHOUSE COMPUTE_WH;

-- 2. Run setup scripts (in order)
-- Execute: setup_hospital_db.sql
-- Execute: semantic_view.sql  
-- Execute: createagent.sql

-- 3. Create Streamlit app
CREATE STREAMLIT MEDICAL_CHATBOT
FROM '@my_stage/app.py'
MAIN_FILE = 'app.py';

-- 4. Get app URL
SELECT SYSTEM$GET_STREAMLIT_URL('HOSPITAL.PUBLIC.MEDICAL_CHATBOT');
```

## 💡 Sample Questions to Try

Once your chatbot is running, try these questions:

- "How many patients live in Dallas?"
- "Show me patient encounters with chief complaint as a rash"
- "What are the chronic conditions of patients over 60?"
- "Which patients have allergies to penicillin?"
- "Show me patients with Medicare insurance"
- "Find patients with diabetes and their primary care providers"

## 🔧 Troubleshooting

### Common Issues for New Users

1. **"Warehouse not found"**:
   - Make sure you've created and are using the COMPUTE_WH warehouse
   - Check that the warehouse is running (not suspended)

2. **"Database HOSPITAL not found"**:
   - Run the `setup_hospital_db.sql` script first
   - Verify you're in the correct account/region

3. **"Agent not found"**:
   - Ensure you've run `createagent.sql` successfully
   - Check that all prerequisites (tables, semantic view) are created

4. **"Streamlit not available"**:
   - Streamlit-in-Snowflake might not be enabled in your account
   - Contact Snowflake support or your administrator

5. **"No data in tables"**:
   - Upload the sample data files from the `data/` folder
   - Or insert sample data manually using SQL INSERT statements

### Getting Help

- **Snowflake Documentation**: [https://docs.snowflake.com/](https://docs.snowflake.com/)
- **Streamlit in Snowflake**: [https://docs.snowflake.com/en/user-guide/streamlit](https://docs.snowflake.com/en/user-guide/streamlit)
- **Snowflake Community**: [https://community.snowflake.com/](https://community.snowflake.com/)

## 📁 Project Structure

```
health agent/
├── app.py                          # Main Streamlit application
├── requirements.txt                # Python dependencies
├── setup_hospital_db.sql           # Database setup script
├── semantic_view.sql               # Semantic view creation
├── createagent.sql                 # Medical agent creation
├── deploy_streamlit.sql            # Streamlit deployment script
└── data/                          # Sample data files
    ├── patients_structured.csv     # Structured patient data
    └── health_agent_unstructured.xlsx # Unstructured medical data
```

## 🔒 Security & Best Practices

- **Data Privacy**: All data stays within your Snowflake environment
- **Access Control**: Use Snowflake's built-in role-based access control
- **Resource Management**: The warehouse auto-suspends to save credits
- **Backup**: Snowflake automatically handles data backup and recovery

## 📈 Next Steps

Once you have the basic chatbot running, consider:

1. **Adding more data**: Upload additional patient records
2. **Customizing questions**: Modify the sample questions for your use case
3. **Enhancing the agent**: Add more tools or modify the agent instructions
4. **Sharing access**: Grant appropriate users access to the Streamlit app
5. **Monitoring usage**: Track warehouse usage and optimize costs

## 📄 License

This project is for educational and demonstration purposes. Feel free to modify and use for your healthcare applications.

---


**Need help?** If you're stuck on any step, check the troubleshooting section above or refer to the Snowflake documentation. Happy coding! 🚀

