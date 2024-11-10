use netflix_adv_project;

create table netflix_data (
 
  show_id varchar(6),
  Type varchar(10) ,
  Title varchar(180),
  direction varchar(250),
  casts varchar(1000),
  country varchar (200),
  date_add varchar(30),
  Release_year year,
  Rating varchar(25),
  Duration varchar(20),
  listed_in varchar(90),
  Description varchar(260)
  

);

drop table netflix_data;
SHOW VARIABLES LIKE 'secure_file_priv';
SELECT User, Host FROM mysql.user;

GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;

FLUSH PRIVILEGES;

SET GLOBAL local_infile = 1;

LOAD DATA  INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/netflix_titles.csv'  # USED '/'
INTO TABLE netflix_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

select * 
from netflix_data;

select count(show_id)
from netflix_data;

select distinct(Type)
from netflix_data;

SELECT  DISTINCT STR_TO_DATE(date_add, '%M %d, %Y') AS converted_date
FROM netflix_data;

SELECT * FROM netflix_data
WHERE date_add IS NULL;


-- ------------------BUSINES RELATED QUESTION ------------------------------------
#1.	Count the number of Movies vs. TV Shows.
SELECT 
TYPE,
COUNT(*)
FROM netflix_data
GROUP BY TYPE ;


#2.	Find the most common rating for movies and TV shows.
SELECT 
TYPE ,
RATING,
COUNT(SHOW_ID )
FROM netflix_data
GROUP BY 1,2;

#3.	List all movies released in a specific year (e.g., 2020).
SELECT *
FROM netflix_data
where TYPE = 'Movie' and Release_year= 2020 ;

#4.	Find the top 5 countries with the most content on Netflix.
-- 1. SPLIT THE COUNTRY WHERE THEY ARE COMBINED 

select DISTINCT(COUNTRY) AS COUNTRY, COUNT(SHOW_ID) AS NO_OF_CONTENT 
From  netflix_data
group by COUNTRY
ORDER BY NO_OF_CONTENT DESC;


WITH RECURSIVE CountrySplit AS (
    -- Step 1: Start with the first country in each row
    SELECT 
        SHOW_id, 
        TRIM(SUBSTRING_INDEX(Country, ',', 1)) AS Country,
        TRIM(SUBSTRING(Country, LENGTH(SUBSTRING_INDEX(Country, ',', 1)) + 2)) AS RemainingCountries
    FROM netflix_data

    UNION ALL

    -- Step 2: Continuously split the remaining countries
    SELECT 
        SHOW_id, 
        TRIM(SUBSTRING_INDEX(RemainingCountries, ',', 1)) AS Country,
        TRIM(SUBSTRING(RemainingCountries, LENGTH(SUBSTRING_INDEX(RemainingCountries, ',', 1)) + 2)) AS RemainingCountries
    FROM CountrySplit
    WHERE RemainingCountries != ''
)

-- Step 3: Count each country and get the top 5
SELECT Country, COUNT(*) AS ContentCount
FROM CountrySplit
GROUP BY Country
ORDER BY ContentCount DESC;



#5.	Identify the longest movie or TV show duration.
SELECT 
    Title,
    Type,
    Duration
FROM 
    netflix_data
ORDER BY 													   -- SUBSTRING_INDEX(Duration, ' ', 1) extracts the part of the Duration column before the first space, which is expected to be a number representing the seasons (e.g., "5 seasons" would return "5").
    CAST(SUBSTRING_INDEX(Duration, ' ', 1) AS UNSIGNED) DESC   -- CAST(... AS UNSIGNED) converts that string (e.g., "5") into a number so it can be treated as an integer.
    LIMIT 1;                                                   -- By using UNSIGNED, you're ensuring that the number is always non-negative, which is appropriate for counting seasons.


#6.	Find content added in the last 5 years.

select date_add from netflix_data WHERE CURDATE() - INTERVAL 5 YEAR;
SELECT *
FROM netflix_data
WHERE STR_TO_DATE(date_add,'%M %d, %Y') >= CURDATE() - INTERVAL 5 YEAR;


#7.	Find all movies/TV shows by director "Rajiv Chilaka."
select * 
from netflix_data
where direction like '%Rajiv Chilaka%';



#8.	List all TV shows with more than 5 seasons.
select type , duration 
from netflix_data
where type ='TV Show' 
order by CAST(SUBSTRING_INDEX(Duration, ' ', 1) AS UNSIGNED) DESC;

#9.	Count the number of content items in each genre.
select * from netflix_data ;

WITH RECURSIVE ContentSplit AS (
    -- Step 1: Start with the first genre in each row
    SELECT 
        SHOW_id, 
        TRIM(SUBSTRING_INDEX(listed_in, ',', 1)) AS genre,
        TRIM(SUBSTRING(listed_in, LENGTH(SUBSTRING_INDEX(listed_in, ',', 1)) + 2)) AS RemainingGenre
    FROM netflix_data

    UNION ALL

    -- Step 2: Continuously split the remaining genres
    SELECT 
        SHOW_id, 
        TRIM(SUBSTRING_INDEX(RemainingGenre, ',', 1)) AS genre,
        TRIM(SUBSTRING(RemainingGenre, LENGTH(SUBSTRING_INDEX(RemainingGenre, ',', 1)) + 2)) AS RemainingGenre
    FROM ContentSplit
    WHERE RemainingGenre != ''
)

-- Step 3: Count each genre and get the top 5
SELECT genre, COUNT(*) AS ContentCount
FROM ContentSplit
GROUP BY genre
ORDER BY ContentCount DESC
LIMIT 5;

#10.Find the average release year for content produced in a specific country.

select Release_year ,country , count(*)
from netflix_data
where country='India'
group by Release_year ;

SELECT extract(year from STR_TO_DATE(date_add, '%M %d, %Y')) as year,count(*)
FROM netflix_data
WHERE country = 'India'
group by 1;

SELECT 
    EXTRACT(YEAR FROM STR_TO_DATE(date_add, '%M %d, %Y')) AS year,
    COUNT(*) AS contentcount,
    COUNT(*) / (SELECT COUNT(*) FROM netflix_data WHERE country = 'India') AS normalized_contentcount
FROM netflix_data
WHERE country = 'India'
GROUP BY year
ORDER BY year;



#11.List all movies that are documentaries.

 
 select * 
 from netflix_data
 where listed_in like '%Documentaries%';

#12.Find all content without a director.

select * 
from netflix_data
where direction is NULL;

#13.Find how many movies actor "Salman Khan" appeared in over the last 10 years.
-- movie which Release in Netflix .
select 
	* 
FROM netflix_data
where 
	casts like '%Salman Khan%' 
	and Type ='Movie'
	and  Release_year >= curdate()-interval 10 year;

-- Movies in which Salman Khan acted in last 10 Years 
SELECT COUNT(*) AS Salman_Khan_Movie_Count
FROM netflix_data
WHERE casts LIKE '%Salman Khan%' 
    AND type = 'Movie'
    AND STR_TO_DATE(date_add, '%M %d, %Y') >= CURDATE() - INTERVAL 10 YEAR;

#14.Find the top 10 actors who have appeared in the highest number of movies.

WITH RECURSIVE CastSplit AS (
    SELECT 
        SHOW_id, 
        TRIM(SUBSTRING_INDEX(casts, ',', 1)) AS cast,
        TRIM(SUBSTRING(casts, LENGTH(SUBSTRING_INDEX(casts, ',', 1)) + 2)) AS Remainingcast
    FROM netflix_data
	where Country like '%India%'


    UNION ALL

    SELECT 
        SHOW_id, 
        TRIM(SUBSTRING_INDEX(Remainingcast, ',', 1)) AS cast,
        TRIM(SUBSTRING(Remainingcast, LENGTH(SUBSTRING_INDEX(Remainingcast, ',', 1)) + 2)) AS Remainingcast
    FROM CastSplit
    WHERE Remainingcast != ''
)

SELECT cast, COUNT(*) AS CastCount
FROM CastSplit
GROUP BY cast
ORDER BY CastCount DESC
LIMIT 5;

WITH RECURSIVE CastSplit AS (
    SELECT 
        SHOW_id, 
        TRIM(SUBSTRING_INDEX(casts, ',', 1)) AS cast,
        TRIM(SUBSTRING(casts, LENGTH(SUBSTRING_INDEX(casts, ',', 1)) + 2)) AS Remainingcast
    FROM netflix_data
	


    UNION ALL

    SELECT 
        SHOW_id, 
        TRIM(SUBSTRING_INDEX(Remainingcast, ',', 1)) AS cast,
        TRIM(SUBSTRING(Remainingcast, LENGTH(SUBSTRING_INDEX(Remainingcast, ',', 1)) + 2)) AS Remainingcast
    FROM CastSplit
    WHERE Remainingcast != ''
)

SELECT cast, COUNT(*) AS CastCount
FROM CastSplit
GROUP BY cast
ORDER BY CastCount DESC
LIMIT 5;


#15.Categorize content based on keywords "kill" and "violence" in the description field as "Bad" and all other content as "Good." Count how many items fall into each category.


