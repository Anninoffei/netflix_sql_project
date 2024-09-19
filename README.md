# Netflix Movies and TV shows Data Analysis using PostgreSQL

![Netflix logo](https://github.com/Anninoffei/netflix_sql_project/blob/main/Netflix_Logo_RGB.png)


## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using PostgreSQL. The end goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings and conclusions.

## Project Goals

* Examine the distribution of content types (movies vs. TV shows).
* Identify the most prevalent ratings for movies and TV shows.
* Analyze content based on release years, countries, and durations.
* Explore and categorize content using specific criteria and keywords.


## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT * 
FROM netflix
WHERE release_year = 2020;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT * 
FROM
(
    SELECT 
        UNNEST(STRING_TO_ARRAY(country, ',')) AS country,
        COUNT(*) AS total_content
    FROM netflix
    GROUP BY 1
) AS t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT 
    *
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

**Objective:** Identify TV shows with more than 5 seasons.

### 7. Count the Number of Content Items in Each Genre

```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;
```

### 8. Find each year and the average numbers of content release in United States on netflix. return top 5 year with highest avg content release !

```sql
SELECT
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as date,
	COUNT(*) as yearly_content,
	ROUND(
	COUNT(*):: numeric / (SELECT COUNT (*) FROM netflix WHERE country = 'United States') * 100 
	,2) as avg_content
FROM netflix
WHERE country = 'United States'
GROUP BY 1
```

**Objective:** Calculate and rank years by the average number of content releases by United States.

### 9. List All Movies that are Documentaries

```sql
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';
```

**Objective:** Retrieve all movies classified as documentaries.

### 10. Find All Content Without a Director

```sql
SELECT * 
FROM netflix
WHERE director IS NULL;
```

## Key Findings and Conclusions

* **Content Diversity:** The dataset showcases a wide array of movies and TV shows, catering to diverse tastes and preferences.
* **Rating Trends:** The most common ratings provide valuable insights into the content's target audience and overall appeal.
* **Geographical Focus:** The analysis reveals a strong emphasis on Indian content, indicating Netflix's efforts to cater to regional audiences.
* **Content Categorization:** Categorizing content based on specific keywords offers a deeper understanding of the available content and potential themes.

These findings provide a comprehensive overview of Netflix's content landscape, offering valuable insights for content strategy and decision-making.



## Author - Michael Annin-Offei

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

