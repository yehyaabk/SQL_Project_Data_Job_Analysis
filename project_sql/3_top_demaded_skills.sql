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