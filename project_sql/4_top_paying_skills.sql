-- Shows which skills are linked to the highest average salaries for Data  roles.

-- FOR all data roles
SELECT
    skills_dim.skills,
    ROUND(AVG(salary_year_avg),2) AS average_salary_skill
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim on skills_dim.skill_id = skills_job_dim.skill_id
WHERE 
    salary_year_avg IS NOT NULL 
GROUP BY skills_dim.skills
ORDER BY average_salary_skill DESC
LIMIT 25;

-- For data analyst
SELECT
    skills_dim.skills,
    ROUND(AVG(salary_year_avg),2) AS average_salary_skill
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim on skills_dim.skill_id = skills_job_dim.skill_id
WHERE 
    salary_year_avg IS NOT NULL AND
    job_title_short = 'Data Analyst'
GROUP BY skills_dim.skills
ORDER BY average_salary_skill DESC
LIMIT 25;
/*
Here are three quick insights(using chatgpt):

1️ Data Analysts with AI & Machine Learning skills (like PyTorch, TensorFlow, Keras) earn significantly higher salaries.
2️ Data Analysts experienced in cloud and automation tools (Terraform, Airflow, Kafka) are among the top earners.
3️ Data Analyst roles requiring rare or niche skills (Solidity, Couchbase, DataRobot) offer premium pay due to limited expertise in the market.
*/