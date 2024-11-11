# Netflix Movies and TV Shows Data Analysis Using SQL
![image](https://github.com/user-attachments/assets/2b6a4fb6-3a7f-4033-abe8-e8dc1ba54a16)



## Overview
This project analyzes Netflix's movie and TV show data using SQL to uncover insights and answer key questions about the content. 
This README provides a summary of the project's objectives, dataset, SQL queries, and findings.

## Objectives
Analyze content distribution (movies vs. TV shows).
Identify the most common ratings for movies and TV shows.
Review content by release year, country, and duration.
Categorize content based on keywords.

## Dataset
The dataset is sourced from Kaggle and includes details about Netflix's content, such as type, title, director, cast, country, release year, and description.

```
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
```
## *****15 Business Problems*****
1. Count the number of Movies vs TV Shows
2. Find the most common rating for movies and TV shows
3. List all movies released in a specific year (e.g., 2020)
4. Find the top 5 countries with the most content on Netflix
5. Identify the longest movie
6. Find content added in the last 5 years
7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
8. List all TV shows with more than 5 seasons
9. Count the number of content items in each genre.
10. Find the average release year for content produced in a specific country.
11. List all movies that are documentaries
12. Find all content without a director
13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.


## Languages Used

This repository contains code and projects written in the following languages:

- **SQL**: Used for querying and analyzing Netflix's movies and TV shows data.
- **MySQL**: Used as the database management system for executing SQL queries.




