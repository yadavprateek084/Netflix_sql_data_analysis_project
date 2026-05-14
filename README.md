🎬 Netflix SQL Data Analysis Project
<div align="center">






Advanced SQL Analytics using PostgreSQL
</div>
📌 Project Overview

This project focuses on solving advanced business problems using SQL on the Netflix dataset.

The analysis demonstrates practical usage of:

Common Table Expressions (CTEs)
Window Functions
String Manipulation
Aggregation Techniques
Data Cleaning
Analytical Queries

The project is designed to strengthen real-world SQL problem-solving skills commonly used in:

Data Analyst Roles
MIS Analyst Interviews
Business Intelligence Projects
SQL Assessments
🏗 Database Schema
CREATE TABLE netflix 
(
    show_id        VARCHAR(10),
    format         VARCHAR(10),
    type           VARCHAR(250),
    director       VARCHAR(500),
    casts          VARCHAR(1000),
    country        VARCHAR(1000),
    date_added     VARCHAR(10),
    release_year   VARCHAR(10),
    rating         VARCHAR(10),
    duration       VARCHAR(20),
    listed_in      VARCHAR(100),
    description    VARCHAR(250)
);
🚀 Top 4 Advanced SQL Queries
1️⃣ Most Common Rating for Movies & TV Shows
📌 Objective

Find the most frequently used rating for each content type.

🔍 Concepts Used
CTE
Window Functions
ROW_NUMBER()
Aggregation
WITH rating_detail AS (
    SELECT 
        format,
        rating,
        COUNT(*) AS countings,
        ROW_NUMBER() OVER(
            PARTITION BY format
            ORDER BY COUNT(*) DESC
        ) AS ranking
    FROM netflix
    GROUP BY format, rating
)

SELECT *
FROM rating_detail
WHERE ranking = 1;
2️⃣ Genre-Based Content Analysis
📌 Objective

Analyze total content available across genres.

🔍 Concepts Used
STRING_TO_ARRAY()
UNNEST()
Aggregation
WITH new_data AS (
    SELECT *,
           UNNEST(
               STRING_TO_ARRAY(listed_in, ',')
           ) AS new_genre
    FROM netflix
)

SELECT 
    new_genre,
    COUNT(*) AS counter
FROM new_data
GROUP BY 1
ORDER BY 2 DESC;
3️⃣ Top 10 Actors in Indian Netflix Movies
📌 Objective

Find actors with the highest appearances in Indian Netflix movies.

🔍 Concepts Used
CTE
String Cleaning
Aggregation
Pattern Matching
WITH new_data AS (
    SELECT *,
           TRIM(
               UNNEST(
                   STRING_TO_ARRAY(casts, ',')
               )
           ) AS new_casts
    FROM netflix
    WHERE format = 'Movie'
)

SELECT 
    new_casts,
    COUNT(*) AS counter
FROM new_data
WHERE new_casts IS NOT NULL
AND country ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
4️⃣ Content Categorization using CASE Statements
📌 Objective

Categorize content as Good or Bad based on keywords.

🔍 Concepts Used
CASE Statement
Pattern Matching
Conditional Logic
Aggregation
WITH new_data AS (
    SELECT *,
           CASE
               WHEN description ILIKE '%kill%'
                 OR description ILIKE '%violence%'
               THEN 'Bad'
               ELSE 'Good'
           END AS category
    FROM netflix
)

SELECT 
    category,
    COUNT(*)
FROM new_data
GROUP BY 1;
📂 SQL File Included

The project also contains a dedicated SQL file with all queries:

netflix_analysis.sql

This file includes:

Database Schema
Data Analysis Queries
Advanced SQL Problems
PostgreSQL Functions & Techniques
🧠 Advanced SQL Concepts Covered
Concept	Purpose
CTEs	Query Structuring
Window Functions	Ranking & Analytics
ROW_NUMBER()	Ranking Results
UNNEST()	Array Expansion
STRING_TO_ARRAY()	String Splitting
CASE Statements	Conditional Logic
Aggregation	Data Summarization
Pattern Matching	Text Analysis
🛠 Tech Stack
Technology	Usage
PostgreSQL	Database
SQL	Data Analysis
Netflix Dataset	Data Source
📈 Key Learnings
Solving real-world analytical SQL problems
Working with messy datasets
Using PostgreSQL advanced functions
Performing business-driven data analysis
Writing optimized SQL queries
👨‍💻 Author
Prateek Yadav
