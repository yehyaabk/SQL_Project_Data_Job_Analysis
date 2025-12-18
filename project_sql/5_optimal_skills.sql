-- Purpose: Determine which skills offer the best combination of high market demand and high salaries.

WITH demandSkills AS(
SELECT
    skills_job_dim.skill_id,
    COUNT(*) AS skill_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON  skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_postings_fact.job_title = 'Data Analyst' AND
    job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY skills_job_dim.skill_id
), averageSalaryBySkill AS(
SELECT
    skills_job_dim.skill_id,
    ROUND(AVG(job_postings_fact.salary_year_avg)) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON  skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_postings_fact.job_title = 'Data Analyst' AND
    job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY skills_job_dim.skill_id
)


SELECT 
    skills_dim.skills,
    demandSkills.skill_count,
    averageSalaryBySkill.average_salary
FROM demandSkills
INNER JOIN averageSalaryBySkill ON  demandSkills.skill_id = averageSalaryBySkill.skill_id
INNER JOIN skills_dim on demandSkills.skill_id = skills_dim.skill_id
ORDER BY 
        demandSkills.skill_count DESC,
        averageSalaryBySkill.average_salary DESC

