SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        When job_location = 'Anywhere' THEN 'Remote'
        When job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_catergory
From 
    job_postings_fact
WHERE
    job_title_short ='Data Analyst'
GROUP BY
    location_catergory;