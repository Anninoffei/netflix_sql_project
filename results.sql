DROP TABLE IF EXISTS netflix;


CREATE TABLE netflix (
    show_id VARCHAR(6),
    type VARCHAR(10),
    title VARCHAR(150),
    director VARCHAR(208),
    casts VARCHAR(1000),
    country VARCHAR(150),
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(15),
    duration VARCHAR(15),
    listed_in VARCHAR(150),
    description VARCHAR(250)
);

SELECT 
	COUNT(*) as total_content 
FROM netflix;

SELECT 
	DISTINCT type
FROM netflix;





-- 1. Count the number of Movies vs TV Shows

SELECT 
	type,
	COUNT(*)as total_content
FROM netflix
GROUP BY type;

-- 2.find the most common rating for movies and tv shows

SELECT 
	type,
	rating
FROM
	
(SELECT 
	type,
	rating,
	COUNT(*),
	RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
FROM netflix
GROUP BY 1, 2
	) as t1
WHERE 
	ranking = 1
--ORDER BY 1, 3 DESC


3. List all movies released in a SPECIFIC YEAR (e.g., 2020)

SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND 
	release_year = 2020
	

4. Find the top 5 countries with the most content on netflix

SELECT 

	UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

5. Identify the longest movie?

SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND 
	duration = (SELECT MAX (duration)FROM netflix)

	
6. Find content added in the last 5 years 
	
SELECT 
	*
FROM netflix
WHERE 
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'

SELECT CURRENT_DATE - INTERVAL '5 years'
	

7. count the number of content items in each genre

SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY 1

8. Find each year and the average numbers of content release in United States on netflix. return top 5 year with highest avg content release !
	
SELECT
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as date,
	COUNT(*) as yearly_content,
	ROUND(
	COUNT(*):: numeric / (SELECT COUNT (*) FROM netflix WHERE country = 'United States') * 100 
	,2) as avg_content
FROM netflix
WHERE country = 'United States'
GROUP BY 1


9. List all movies that are documentries

SELECT * FROM netflix
WHERE
listed_in ILIKE '%documentaries%'


10. Find all content without a director

SELECT * FROM netflix
WHERE
director IS NULL














