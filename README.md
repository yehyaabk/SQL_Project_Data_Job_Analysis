# Introduction

In this project, I explore the data job market by focusing on data analyst roles. I analyze top-paying positions, in-demand skills, and how salary and demand intersect in data analytics.

The SQL queries used for this analysis are available here: [project_sql folder](./project_sql/)

# Data Source

The data used in this analysis comes from Luke BAROUSSE [SQL Course](https://lukebarousse.com/sql/), which provides detailed insights into job titles, salaries, locations, and essential skills.

# Tools I Used
To conduct this analysis of the data analyst job market, I relied on several key tools:

- **SQL:** The core of the analysis, used to query the database and extract meaningful insights.
- **PostgreSQL:** The database management system used to store and manage the job posting data.
- **Visual Studio Code:** The primary environment for writing, managing, and executing SQL queries.
- **Git & GitHub:** Used for version control and sharing SQL scripts and analysis, enabling collaboration and project tracking.
# The Analysis
Each query in this project focuses on exploring a specific aspect of the data analyst job market. Below is an overview of how each question was approached.

### 1. Top-Paying Data Analyst Jobs

To identify the highest-paying roles, I filtered data analyst positions based on average yearly salary and location, with a focus on remote roles. This analysis highlights the most lucrative opportunities available in the field.
```sql
SELECT
    job_id,
    job_title,
    job_country,
    job_posted_date,
    name AS company_name,
    salary_year_avg
FROM job_postings_fact
LEFT JOIN company_dim 
ON company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_location = 'Anywhere'
ORDER BY salary_year_avg DESC
LIMIT 10;
```
### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
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
```
### 3. In-Demand Skills for Data Analysts
This set of queries analyzes the most in-demand skills across data roles by examining overall demand, role-specific requirements (Data Analyst, Data Engineer, Data Scientist), and geographic differences for Data Analyst positions in France and the United States.

```sql
-- For all data roles
SELECT
    skills,
    count(*) AS skill_count
FROM
    job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
GROUP BY
    skills
ORDER BY
    skill_count DESC
LIMIT
    5;

-- For data analysts roles
SELECT
    skills,
    count(*) AS skill_count
FROM
    job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    skill_count DESC
LIMIT
    5;

-- For data engineer roles
SELECT
    skills,
    count(*) AS skill_count
FROM
    job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Engineer'
GROUP BY
    skills
ORDER BY
    skill_count DESC
LIMIT
    5;

-- for data scientist roles
SELECT
    skills,
    count(*) AS skill_count
FROM
    job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Scientist'
GROUP BY
    skills
ORDER BY
    skill_count DESC
LIMIT
    5;

-- for data  Analyst roles in france 
SELECT
    skills,
    count(*) AS skill_count
FROM
    job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_country = 'France'
    and job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    skill_count DESC
LIMIT
    5;

-- for data  analyst in USA
SELECT
    skills,
    count(*) AS skill_count
FROM
    job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_country = 'United States'
    and job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    skill_count DESC
LIMIT
    5;
```
### 4. Skills Based on Salary

Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
-- These queries find the top-paying skills

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
```


### 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
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
```


# What I Learned
Throughout this project, I significantly strengthened my SQL skills by working with real-world data and complex queries. Key takeaways include:

- **Advanced SQL Querying:** Gained hands-on experience writing complex queries using joins and `WITH` clauses (CTEs) to structure and simplify multi-step analyses.
- **Data Aggregation:** Improved my ability to summarize data using `GROUP BY` and aggregate functions such as `COUNT()` and `AVG()` to extract meaningful insights.
- **Analytical Thinking:** Enhanced my problem-solving skills by translating business and career-related questions into clear, actionable SQL queries.

## Conclusions

### Key Insights

Based on the analysis, several important insights emerged:

1. **Top-Paying Data Analyst Jobs:** Remote data analyst roles offer a wide salary range, with the highest-paying positions reaching up to **$650,000 per year**.
2. **Skills for Top-Paying Roles:** High-paying data analyst positions consistently require strong proficiency in **SQL**, highlighting it as a critical skill for earning top salaries.
3. **Most In-Demand Skills:** SQL is also the most frequently requested skill across data analyst job postings, making it essential for job seekers.
4. **Skills Linked to Higher Salaries:** Specialized skills such as **SVN** and **Solidity** are associated with higher average salaries, suggesting a premium for niche expertise.
5. **Optimal Skills for Market Value:** SQL stands out as one of the most valuable skills to learn, combining high demand with strong salary potential for data analysts.

### Closing Thoughts

This project strengthened my SQL skills and provided practical insights into the data analyst job market. The findings can help guide skill development and job search strategies by highlighting which skills offer the greatest return in terms of demand and salary. Overall, the analysis underscores the importance of continuous learning and staying adaptable in a rapidly evolving data analytics landscape.


