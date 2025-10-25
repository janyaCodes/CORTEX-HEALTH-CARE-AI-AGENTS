-- Use Hospital database
USE DATABASE HOSPITAL;
USE SCHEMA PUBLIC;

create or replace semantic view HOSPITAL.PUBLIC.PATIENTDATAANALYST
	tables (
		HOSPITAL.PUBLIC.PATIENTS_STRUCTURED
	)
	facts (
		PATIENTS_STRUCTURED.ACCOUNT_NUMBER as ACCOUNT_NUMBER comment='Unique identifier assigned to a patient''s account, used to track and manage their medical records and billing information.',
		PATIENTS_STRUCTURED.AGE as AGE comment='The age of the patient in years.',
		PATIENTS_STRUCTURED.MRN as MRN comment='Medical Record Number (MRN) - a unique identifier assigned to each patient to track their medical history and records within the healthcare system.',
		PATIENTS_STRUCTURED.ZIP as ZIP comment='The ZIP column represents the patient''s residential zip code, a five-digit code used by the United States Postal Service to identify a specific geographic area, allowing for the tracking of patient demographics and geographic distribution.'
	)
	dimensions (
		PATIENTS_STRUCTURED.ADDRESS as ADDRESS comment='The physical location where the patient resides.',
		PATIENTS_STRUCTURED.ALLERGIES as ALLERGIES comment='List of known allergies for each patient, with multiple allergies separated by semicolons.',
		PATIENTS_STRUCTURED.CHRONIC_CONDITIONS as CHRONIC_CONDITIONS comment='List of chronic medical conditions a patient has been diagnosed with, separated by commas.',
		PATIENTS_STRUCTURED.CITY as CITY comment='The city where the patient resides.',
		PATIENTS_STRUCTURED.DOB as DOB comment='Date of Birth of the patient.',
		PATIENTS_STRUCTURED.EMAIL as EMAIL comment='The email address of the patient.',
		PATIENTS_STRUCTURED.FIRST_NAME as FIRST_NAME comment='The first name of the patient.',
		PATIENTS_STRUCTURED.INSURANCE as INSURANCE comment='Type of insurance coverage for the patient, indicating whether they are covered by Medicaid, Medicare, or are self-pay (no insurance coverage).',
		PATIENTS_STRUCTURED.LAST_NAME as LAST_NAME comment='The patient''s last name.',
		PATIENTS_STRUCTURED.PATIENT_ID as PATIENT_ID comment='Unique identifier assigned to each patient in the healthcare system.',
		PATIENTS_STRUCTURED.PHONE as PHONE comment='The phone number of the patient.',
		PATIENTS_STRUCTURED.PRIMARY_CARE_PROVIDER as PRIMARY_CARE_PROVIDER comment='The primary care physician assigned to each patient, responsible for providing routine medical care and referrals to specialists as needed.',
		PATIENTS_STRUCTURED.SEX as SEX comment='The sex of the patient, which can be one of the following: Female (F), Nonbinary, or Male (M).',
		PATIENTS_STRUCTURED.STATE as STATE comment='The two-letter abbreviation for the state in the United States where the patient resides.'
	)
	with extension (CA='{"tables":[{"name":"PATIENTS_STRUCTURED","dimensions":[{"name":"ADDRESS","sample_values":["3757 Pine Rd","5481 Pine Rd","5255 Cedar Ln"]},{"name":"ALLERGIES","sample_values":["Aspirin, Latex, Iodine","Sulfa drugs","Latex, Iodine, Penicillin"]},{"name":"CHRONIC_CONDITIONS","sample_values":["Hypothyroidism","Asthma, Hyperlipidemia","GERD"]},{"name":"CITY","sample_values":["Austin","Irving","San Antonio"]},{"name":"DOB","sample_values":["07-02-1974","05-03-2008","09-12-1943"]},{"name":"EMAIL","sample_values":["wyatt.davis31@example.com","carter.davis82@example.com","isabella.hill371@example.com"]},{"name":"FIRST_NAME","sample_values":["Wyatt","Carter","Amelia"]},{"name":"INSURANCE","sample_values":["Medicaid","Self-pay","Medicare"]},{"name":"LAST_NAME","sample_values":["Wright","Sanchez","Walker"]},{"name":"PATIENT_ID","sample_values":["P0003","P0012","P0001"]},{"name":"PHONE","sample_values":["(805) 632-1520","(670) 346-5339","(347) 779-7566"]},{"name":"PRIMARY_CARE_PROVIDER","sample_values":["Dr. Gupta","Dr. Hughes","Dr. Taylor"]},{"name":"SEX","sample_values":["F","Nonbinary","M"]},{"name":"STATE","sample_values":["AZ","CA","FL"]}],"facts":[{"name":"ACCOUNT_NUMBER","sample_values":["7403959807","2429623708","3193008687"]},{"name":"AGE","sample_values":["81","37","51"]},{"name":"MRN","sample_values":["54716858","13676065","65258086"]},{"name":"ZIP","sample_values":["95354","21405","94269"]}]}]}');