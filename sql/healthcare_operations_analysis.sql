/* ==========================================================================
						HEALTHCARE OPERATIONS ANALYSIS
                        
Objective:
Analyze patient demographics, hospital utilization, operational efficiency,
and billing trends using SQL.

Tools:
• Excel (Data Cleaning)
• MySQL (Data Analysis)
• Tableau (Data Visualization)

Dataset:
55,500 Healthcare Records
============================================================================= */

/* =================================
		DATABASE SETUP
==================================== */

CREATE DATABASE healthcare_operations;
USE healthcare_operations;

/* =================================
		DATA VALIDATION
==================================== */

/* Review table structure */

DESCRIBE healthcare_data;

/* Inspect sample records */

SELECT * 
FROM healthcare_data 
LIMIT 10;

/* Validate total records */

SELECT 
	COUNT(*) AS total_records
FROM healthcare_data;

/* Validate key numeric fields */

SELECT
	MIN(age) AS min_age,
    MAX(age) AS max_age,
    ROUND(AVG(age), 2) AS avg_age,
    MIN(billing_amount) AS min_billing,
    MAX(billing_amount) AS max_billing
FROM healthcare_data;

/* =================================
   EXECUTIVE KPIs
==================================== */

SELECT 
	COUNT(*) AS total_patients, 
	ROUND(AVG(age), 2) AS avg_age,
	ROUND(AVG(length_of_stay_days), 2) AS avg_los,
    ROUND(AVG(billing_amount), 2) AS avg_billing,
	ROUND(
		SUM(CASE WHEN admission_type = 'Emergency' THEN 1 ELSE 0 END) * 100.00 
        / COUNT(*), 2) AS emergency_admission_pct
FROM healthcare_data;

/* =================================
   PATIENT DEMOGRAPHICS
==================================== */

/* Question:
Which age groups represent the largest population? 
*/

SELECT 
	age_group,
    COUNT(*) AS patient_count
FROM healthcare_data
GROUP BY age_group
ORDER BY patient_count DESC;

/* Question:
What is the gender distribution of patients? 
*/

SELECT 
	gender,
    COUNT(*) AS patient_count
FROM healthcare_data
GROUP BY gender
ORDER BY patient_count DESC;

/* Question:
Which medical conditions are most common? 
*/

SELECT 
	medical_condition,
    COUNT(*) AS patients
FROM healthcare_data
GROUP BY medical_condition
ORDER BY patients DESC;

/* =================================
   ADMISSION TRENDS
==================================== */

/* Question:
How do admission types compare in terms of patient 
volume, average length of stay, and average billing? 
*/

SELECT 
	admission_type,
    COUNT(*) AS patients,
    ROUND(AVG(length_of_stay_days), 2) AS avg_los,
    ROUND(AVG(billing_amount), 2) AS avg_billing
FROM healthcare_data
GROUP BY admission_type;

/* Question:
How has patient admission volume changed over time?
 */

SELECT 
	DATE_FORMAT(date_of_admission,'%Y-%m') AS admission_month,
    COUNT(*) AS admissions
FROM healthcare_data
GROUP BY admission_month
ORDER BY admission_month;

/* Question:
What is the distribution of patients across insurance providers?
*/

SELECT 
	insurance_provider, 
    COUNT(*) AS admissions
FROM healthcare_data
GROUP BY insurance_provider
ORDER BY admissions DESC;

/* =================================
   OPERATIONAL EFFICIENCY
==================================== */

/* Question:
Which admission types have the longest LOS? 
*/

SELECT 
	admission_type,
    COUNT(*) AS patient_count,
    ROUND(AVG(length_of_stay_days), 2) AS avg_los
FROM healthcare_data
GROUP BY admission_type
ORDER BY avg_los DESC;

/* Question:
Which conditions have the longest LOS? 
*/

SELECT 
	medicaL_condition,
    COUNT(*) AS patient_count,
    ROUND(AVG(length_of_stay_days), 2) AS avg_los
FROM healthcare_data
GROUP BY medical_condition
ORDER BY avg_los DESC;

/* Question:
How does LOS vary by age group? 
*/

SELECT 
	age_group,
    COUNT(*) AS patient_count,
    ROUND(AVG(length_of_stay_days), 2) AS avg_los
FROM healthcare_data
GROUP BY age_group
ORDER BY avg_los DESC;

/* Question:
How has LOS changed over time? 
*/

SELECT 
	YEAR(date_of_admission) AS admission_year,
    COUNT(*) AS patient_count,
    ROUND(AVG(length_of_stay_days), 2) AS avg_los
FROM healthcare_data
GROUP BY admission_year
ORDER BY avg_los DESC;

/* =================================
   FINANCIAL ANALYSIS
==================================== */

/* Question:
Which conditions have the highest average billing? 
*/

SELECT 
	medicaL_condition,
    COUNT(*) AS patient_count,
    ROUND(AVG(billing_amount), 2) AS avg_billing
FROM healthcare_data
GROUP BY medical_condition
ORDER BY avg_billing DESC;

/* Question:
Which conditions exceed the overall average billing? 
*/

SELECT
	medical_condition,
    ROUND(AVG(billing_amount), 2) AS avg_billing
FROM healthcare_data
GROUP BY medical_condition
HAVING avg_billing > (
	SELECT AVG(billing_amount)
    FROM healthcare_data)
ORDER BY avg_billing;

/* =================================
   KEY FINDINGS
==================================== */

/*

• Emergency admissions had the longest average length of stay.
• Asthma patients experienced the longest average length of stay.
• Patients aged 55+ represented the largest patient population.
• Asthma, Diabetes, and Obesity generated above-average billing.
• Elective admissions produced the highest average billing

These findings suggest opportunities to improve patient throughput, monitor 
resource utilization, and prioritize workflow improvements.

*/

/* =================================
   RECOMMENDATIONS
==================================== */

/*

1. Review emergency admission workflows to identify opportunties
   to reduce length of stay.

2. Investigate asthma-related admissions to better understand
   factors contributing to longer hospital stays. 

3. Evaluate resource allocation for high-cost medical conditions
   to improve operational efficiency.

4. Monitor admission trends and insurance mix to support
   capacity planning and financial forecasting. 

*/

/* =================================
          END OF ANALYSIS
==================================== */