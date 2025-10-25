CREATE OR REPLACE AGENT HOSPITAL.PUBLIC.MEDICALAGENT
COMMENT = 'This agent helps healthcare professionals by providing quick access to structured patient details and extracting key information from unstructured encounter notes, making it easier to review comprehensive patient history and recent clinical visits.'
FROM SPECIFICATION
$$
models:
  orchestration: "openai-gpt-4.1"

instructions:
  response: "Be polite. Analyze all tool outputs, create a comprehensive report based on tool response. Always give detailed response. Always at the end of the response add your suggestion based on the output. this is about healthcare of patients, provide detailed medical suggestions based on output. "
  orchestration: "This agent orchestrates patient data retrieval and enrichment for healthcare users. It integrates two primary sources:
The Patient Data table provides structured, authoritative demographic and summary information for each patient and key identifiers.
The PatientEncounter is unstructred Cortex Search captures unstructured clinical documentation, such as encounter summaries, provider notes, and other rich narrative text extracted from source documents.
The agent first uses identifiers (such as MRN or account number) to join and validate relationships between patients and their encounter records. Encounter data is regularly ingested and processed to extract key fields (e.g., Encounter ID, Account Number, MRN), ensuring unstructured notes can be surfaced, searched, and summarized alongside the parent patient’s structured information."
  sample_questions:
    - question: "How many patients live in Dallas?"
    - question: "Show me patient encounters with chief complaint as a rash."

tools:
  - tool_spec:
      type: "cortex_analyst_text_to_sql"
      name: "patient_personal_details"
      description: |
        TABLE1:
        - Database: HOSPITAL, Schema: PUBLIC
        - The PATIENTDATA table stores comprehensive patient information, including demographic details, contact information, medical history, and insurance coverage. It is designed to provide a holistic view of each patient for healthcare management and analysis.

  - tool_spec:
      type: "cortex_search"
      name: "patient_encounter_details"
      description: "This search has patient encounter details. the MRn can be linked to cortex analyst"

tool_resources:
  patient_encounter_details:
    id_column: "ENCOUNTERID"
    max_results: 4
    name: "HOSPITAL.PUBLIC.PATIENTECOUNTERSEARCH"
    title_column: "MRN"

  patient_personal_details:
    execution_environment:
      query_timeout: 120
      type: "warehouse"
      warehouse: "COMPUTE_WH"

$$;