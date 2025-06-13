/*
Question: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying Data Analyst roles that are available remotely.
- Focuses on job postings with specified salaries (remove nulls).
- Why? Highlight the top-paying opportunities for Data Analysts, offering insights into te role and skills
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM    
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id -- I want to find what company each title is from so i need to connect the company dim table to the posted fact table to get that information by connecting the company_ids together
WHERE   
    job_title_short IN ('Data Analyst' , 'Business Analyst') AND
    job_location IN ('United States','Anywhere','California','Los Angles') AND --Anywhere meaning Remote
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 20

