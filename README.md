# Netflix SQL Data Analysis Project 🎬

## Overview

This project demonstrates advanced SQL analysis performed on the Netflix dataset using PostgreSQL.

The main objective of this project is to solve real-world business problems using advanced SQL concepts such as:

- Common Table Expressions (CTEs)
- Window Functions
- String Manipulation
- Aggregation
- Data Cleaning
- Analytical Queries

This project is useful for:
- Data Analyst Interview Preparation
- SQL Practice
- PostgreSQL Learning

---

# Database Schema

```sql
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
```

---

# Some SQL Queries

## 1. Most Common Rating for Movies and TV Shows

### Problem
Find the most frequently used rating for each content type.

### Concepts Used
- CTE
- Window Functions
- ROW_NUMBER()
- Aggregation

```sql
WITH rating_detail AS (
    SELECT 
        format,
        rating,
        COUNT(*) AS total_count,
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
```

---

## 2. Genre-Based Content Analysis

### Problem
Count total content available in each genre.

### Concepts Used
- STRING_TO_ARRAY()
- UNNEST()
- Aggregation

```sql
WITH new_data AS (
    SELECT 
        UNNEST(
            STRING_TO_ARRAY(listed_in, ',')
        ) AS genre
    FROM netflix
)

SELECT 
    TRIM(genre) AS genre_name,
    COUNT(*) AS total_content
FROM new_data
GROUP BY genre_name
ORDER BY total_content DESC;
```

---

## 3. Top 10 Actors in Indian Netflix Movies

### Problem
Find actors with the highest appearances in Indian Netflix movies.

### Concepts Used
- CTE
- String Manipulation
- Aggregation
- Filtering

```sql
WITH new_data AS (
    SELECT 
        TRIM(
            UNNEST(
                STRING_TO_ARRAY(casts, ',')
            )
        ) AS actor_name,
        country
    FROM netflix
    WHERE format = 'Movie'
)

SELECT 
    actor_name,
    COUNT(*) AS movie_count
FROM new_data
WHERE actor_name IS NOT NULL
AND country ILIKE '%India%'
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 10;
```

---

## 4. Content Categorization using CASE Statement

### Problem
Categorize content as 'Good' or 'Bad' based on keywords in the description.

### Concepts Used
- CASE Statement
- Pattern Matching
- Aggregation

```sql
WITH categorized_content AS (
    SELECT 
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
    COUNT(*) AS total_content
FROM categorized_content
GROUP BY category;
```

---

# SQL File

All queries are included in:

```bash
netflix_analysis.sql
```

---

# Advanced SQL Concepts Covered

| Concept | Usage |
|----------|--------|
| CTEs | Query Structuring |
| Window Functions | Ranking & Analytics |
| ROW_NUMBER() | Ranking Results |
| STRING_TO_ARRAY() | Splitting Values |
| UNNEST() | Array Expansion |
| CASE Statement | Conditional Logic |
| Aggregation | Data Analysis |
| Pattern Matching | Text Filtering |

---

# Tech Stack

- PostgreSQL
- SQL
- Netflix Dataset (CSV)

---

# Key Learnings

Through this project, I improved my understanding of:

- Writing analytical SQL queries
- Handling real-world datasets
- Using PostgreSQL advanced functions
- Performing data cleaning in SQL
- Solving interview-level SQL problems

---

# Author

## Prateek Yadav


If you liked this project, consider giving it a ⭐ on GitHub.
