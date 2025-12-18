/*
This query retrieves the top 10 highest yearly salaries for data analysts
who work remotely only, and includes the companies they are employed by.
*/

SELECT
    job_id,
    job_title,
    job_country,
    job_posted_date,
    name AS company_name,
    salary_year_avg
FROM job_postings_fact
LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_location = 'Anywhere'
ORDER BY salary_year_avg DESC
LIMIT 10;


