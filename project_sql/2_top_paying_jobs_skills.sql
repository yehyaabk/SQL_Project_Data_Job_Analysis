/*
Retrieves the top 10 highest-paying remote Data Analyst jobs
along with the specific skills required for each role.
*/
WITH top_paying_jobs AS(
    SELECT
        job_id,
        job_title,
        job_country,
        name AS company_name,
        salary_year_avg
    FROM job_postings_fact
    LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_location = 'Anywhere'
    ORDER BY salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills_dim.skills
FROM top_paying_jobs
INNER JOIN skills_job_dim on skills_job_dim.job_id = top_paying_jobs.job_id
INNER JOIN skills_dim on skills_dim.skill_id  = skills_job_dim.skill_id


/*  
SQL + Python is the industry’s strongest and most demanded combination
Visualization tools (Tableau/Power BI) are critical for top salaries
*/



