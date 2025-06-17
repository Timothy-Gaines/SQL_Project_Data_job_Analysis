# Introduction
 Diving into the data job market! Focusing on data analyst and Business Analyst roles, In this project I explore the top-paying jobs, in-demand skills, and where high demand meets high salary in data analytics

SQL queries? Check them out here [Project_SQL folder](/Project_SQL/)

# Background
Driven by trying to improve my SQL skills and leanr more about the data analyst job market, this project aims to pinpoint top paid and in-demand skills.

### Main Questions I was focused on answering 

1. What are the top paying data analyst and business analyst jobs?
2. What skilld are required for these top paying jobs?
3. What skills are most in demand for data and business analyst?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL:** The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code:** My go-to for database management and executing SQL queries.
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis

## 1. Top Paying Jobs
Each query for this project was aimed at looking into specific areas and aspects of the data analyst job market. 

To identify the highest paying roles I filtered data analyst and business analyst positions by average yearly salary, location, and job schedual, focusing on jobs located in the United states and California

```sql
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
LIMIT 20;
``` 
- **Salary Distribution:** Ranges from $170 000 to $650 000, with an average of $231 103 and a median of $201 000
- **Top-Paying Employers & Sectors:*** Highest-paying jobs at Mantys ($650 000), Meta ($336 500), AT&T ($255 830), and Pinterest ($232 423) — spanning SaaS startups, social media, telecommunications, and digital advertising.
- **Job Title Variety:** There is a high diversity in job titles, from Data Analyst to Director of Analystics, reflecting varied roles and specializations within data analystics and Business analyst.

![Top Paying Roles](Assets\output.png)
*Bar graph visulizing the salary for the top 10 salariers for Data Analyst and Business Analyst. 

## 2. Skills for Top Paying jobs
To Understand what skills are required for the top paying jobs I joined the job postings with the skills data. Providing insights into what employers value for high paying roles.

```sql
WITH top_paying_jobs AS (

    SELECT
        job_id,
        job_title,
        salary_year_avg,
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
)

SELECT
    top_paying_jobs.*,-- selects all the columns from that table
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY 
    salary_year_avg DESC
```


The top in demand skills across the top-paying Data Analyst and Business Analyst roles:

- **Python** appears in 13 of the top 20 postings

-**SQL** in 12 postings

-**Tableau** in 9 postings

-**R** in 6 postings

-**Excel** and Power BI each in 5 postings

-**Pandas**, Jira, Snowflake, and Atlassian in 3 postings each

![Top Paying Skills](Assets\Top_skills.png)
*Bar graph visulizing the most frequent skills found in the highest paying roles for Data Analyst and Business Analyst. 

## 3. In-Demand Skills
To gauge which skills are most frequently requested for Data Analyst and Business Analyst roles, we counted occurrences of each skill across relevant postings:

```sql
Copy
Edit
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short IN ('Data Analyst', 'Business Analyst')
    AND job_location IN ('United States','Anywhere','California','Los Angles')
    AND job_country = 'United States'
    AND job_schedule_type = 'Full-time'
GROUP BY
    skills
ORDER BY 
    demand_count DESC
LIMIT 5;
```
-**SQL** leads demand with 2,831 postings

-**Excel** follows at 2,028 postings

-**Tableau** appears in 1,587 postings

-**Python** appears in 1,456 postings

-**SAS** appears in 976 postings

| Skill   | Demand Count |
|---------|--------------|
| SQL     | 2,831        |
| Excel   | 2,028        |
| Tableau | 1,587        |
| Python  | 1,456        |
| SAS     |   976        |


## 4. Skills Based on Salary
To identify which skills carry the highest average salaries, we averaged salary_year_avg per skill:

```sql
Copy
Edit
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short IN ('Data Analyst', 'Business Analyst')
    AND salary_year_avg IS NOT NULL
    AND job_location IN ('United States','Anywhere','California','Los Angles')
    AND job_country = 'United States'
    AND job_schedule_type = 'Full-time'
GROUP BY
    skills
ORDER BY 
    avg_salary DESC
LIMIT 20;
```
-**PyTorch** commands the highest average at $220,000

-**PySpark** averages $208,172

-**Bitbucket** averages $189,155

-**Couchbase and Watson** both average $160,515

-**GitLab** averages $154,500

| Skill         | Avg Salary |
|---------------|-----------:|
| PyTorch       |   220,000  |
| PySpark       |   208,172  |
| Bitbucket     |   189,155  |
| Couchbase     |   160,515  |
| Watson        |   160,515  |
| GitLab        |   154,500  |
| Swift         |   153,750  |
| Jupyter       |   152,777  |
| Chef          |   152,500  |
| Pandas        |   151,821  |
| Elasticsearch |   145,000  |
| Golang        |   145,000  |
| NumPy         |   143,513  |
| Airflow       |   141,379  |
| Databricks    |   137,106  |
| Linux         |   136,508  |
| Kubernetes    |   132,500  |
| Atlassian     |   131,162  |
| GCP           |   127,500  |
| Twilio        |   127,000  |


## 5. Most Optimal Skills to Learn
To balance both high demand and strong pay, we joined demand counts with average salaries and filtered for skills with at least 11 postings:

```sql
Copy
Edit
WITH skills_demand AS (
    SELECT 
        sd.skill_id,
        sd.skills,
        COUNT(sjd.job_id) AS demand_count
    FROM job_postings_fact jf
    INNER JOIN skills_job_dim sjd ON jf.job_id = sjd.job_id
    INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
    WHERE
        jf.job_title_short IN ('Data Analyst', 'Business Analyst')
        AND jf.job_location IN ('United States','Anywhere','California','Los Angles')
        AND jf.job_country = 'United States'
        AND jf.salary_year_avg IS NOT NULL
        AND jf.job_schedule_type = 'Full-time'
    GROUP BY
        sd.skill_id, sd.skills
), average_salary AS (
    SELECT 
        sjd.skill_id,
        ROUND(AVG(jf.salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact jf
    INNER JOIN skills_job_dim sjd ON jf.job_id = sjd.job_id
    WHERE
        jf.job_title_short IN ('Data Analyst', 'Business Analyst')
        AND jf.salary_year_avg IS NOT NULL
        AND jf.job_location IN ('United States','Anywhere','California','Los Angles')
        AND jf.job_country = 'United States'
        AND jf.job_schedule_type = 'Full-time'
    GROUP BY
        sjd.skill_id
)
SELECT 
    sd.skill_id,
    sd.skills,
    sd.demand_count,
    asalary.avg_salary
FROM skills_demand sd
INNER JOIN average_salary asalary ON sd.skill_id = asalary.skill_id
WHERE 
    sd.demand_count > 10
ORDER BY
    asalary.avg_salary DESC,
    sd.demand_count DESC
LIMIT 25;
```

-**Hadoop:** 22 postings, avg $118,237

-**Go:** 26 postings, avg $116,547

-**BigQuery:** 14 postings, avg $116,464

-**Snowflake:** 36 postings, avg $112,584

-**AWS:** 27 postings, avg $112,049

| Skill       | Demand Count | Avg Salary |
|-------------|-------------:|-----------:|
| Hadoop      |           22 |    118,237 |
| Go          |           26 |    116,547 |
| BigQuery    |           14 |    116,464 |
| Snowflake   |           36 |    112,584 |
| AWS         |           27 |    112,049 |
| Azure       |           32 |    111,786 |
| Confluence  |           13 |    110,601 |
| Looker      |           54 |    107,628 |
| SSIS        |           11 |    106,382 |
| DAX         |           12 |    105,417 |
| Java        |           17 |    104,681 |
| Qlik        |           13 |    104,465 |
| Jira        |           20 |    104,168 |
| Oracle      |           40 |    103,468 |
| NoSQL       |           15 |    102,624 |
| Python      |          245 |    102,334 |
| Spark       |           13 |    101,962 |
| Tableau     |          239 |    101,135 |
| R           |          150 |    100,912 |
| Redshift    |           14 |    100,392 |
| SAS         |           68 |     99,969 |
| SSRS        |           14 |     99,279 |
| Power BI    |          113 |     97,674 |
| SQL Server  |           36 |     97,527 |



# What I Learned
Here are 3 main bullet points that summarize the majority of your learning:

- **Learned how to write and structure SQL queries** learned the basics of structuring a query and to extract, filter, group, and order data based on real-world questions like salary trends and skill demand.

- **Gained experience joining multiple tables** using INNER JOIN, LEFT JOIN, and WITH (CTEs) to combine job postings, skills, and companies into more complex insights.

- **Improved data analysis and interpretation skills** by transforming raw query results into clear insights and visual summaries, then documenting everything using Markdown.

# Conclusions

- **1. Top Paying Data Analyst Jobs**  
  The highest-paying roles ranged from $170K to $650K annually, with top titles like *Director of Analytics* and *Associate Director of Data Insights*. Major employers included Mantys, Meta, AT&T, and Pinterest, showing that both startups and tech giants are offering high compensation.

- **2. Skills for Top Paying Jobs**  
  The most common skills among top-paying jobs were Python (65%), SQL (60%), Tableau, R, and Excel. This suggests that a blend of programming, data visualization, and traditional tools are still highly valued at the executive level.

- **3. Most In-Demand Skills**  
  SQL leads the job market with over 2,800 postings, followed by Excel (2,000+), Tableau, Python, and SAS. These foundational tools are essential for most entry- to mid-level data analyst roles across industries.

- **4. Skills with Higher Salaries**  
  Niche or technical tools like PyTorch ($220K), PySpark ($208K), and Bitbucket ($189K) were associated with the highest average salaries. These are often tied to advanced data engineering or ML-related positions.

- **5. Optimal Skills for Job Market Value**  
  Skills like Hadoop, Go, BigQuery, and Snowflake strike a strong balance between demand and salary, making them high-value investments for learning. Python and Tableau also remain competitive due to their wide use and solid salary backing.
