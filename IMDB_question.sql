USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- ===============================
-- Data Exploration
/* 1. Missiing Values
2. duplication of Data
3. Understanding shape of data
4. understanding descriptive stats - mean, median and mode(categorical), standard deviation, variance

*/
-- missing values :-
delimiter // 
CREATE PROCEDURE miss_value(IN col TEXT)
BEGIN
	SELECT col from director_mapping
    where col is NULL;
End //
DELIMITER ;

CALL miss_value("movie_id");
CALL miss_value("name_id");

delimiter // 
CREATE PROCEDURE miss_value_genre(IN col TEXT)
BEGIN
	SELECT col from genre
    where col is NULL;
End //
DELIMITER ;
drop procedure miss_value_genre;
CALL miss_value_genre("movie_id");
CALL miss_value_genre("genre");

delimiter // 
CREATE PROCEDURE miss_value_movie(IN col TEXT)
BEGIN
	SELECT col from movie
    where col is NULL;
End //
DELIMITER ;
drop procedure miss_value_movie;
CALL miss_value_movie("id");
CALL miss_value_movie("title");
CALL miss_value_movie("year");
CALL miss_value_movie("date_published");
CALL miss_value_movie("duration");
call miss_value_movie("worlwide_gross_income");
call miss_value_movie("languages");
call miss_value_movie("duration");


delimiter // 
CREATE PROCEDURE miss_value_names(IN col TEXT)
BEGIN
	SELECT col from names
    where col is NULL;
End //
DELIMITER ;
drop procedure miss_value_names;
call miss_value_names("id");
call miss_value_names("names");
call miss_value_names("height");
call miss_value_names("date_of_birth");
call miss_value_names("known_for_movies");

delimiter // 
CREATE PROCEDURE miss_value_ratings(IN col TEXT)
BEGIN
	SELECT col from ratings
    where col is NULL;
End //
DELIMITER ;
drop procedure miss_value_ratings;
call miss_value_ratings("movie_id");
call miss_value_ratings("avg_rating");
call miss_value_ratings("total_votes");
call miss_value_ratings("median_rating");

delimiter // 
CREATE PROCEDURE miss_value_role_mapping(IN col TEXT)
BEGIN
	SELECT col from role_mapping
    where col is NULL;
End //
DELIMITER ;
drop procedure miss_value_role_mapping;

-- Segment 1:
SELECT COUNT(*)
FROM movie
WHERE worlwide_gross_income IS NULL;


SELECT
    worlwide_gross_income,
    REPLACE(worlwide_gross_income, '$ ', '') AS cleaned_value
FROM movie;
UPDATE movie
SET worlwide_gross_income = REPLACE(worlwide_gross_income, '$ ', '');
UPDATE movie
SET worlwide_gross_income = REPLACE(worlwide_gross_income, 'INR ', '');
SET SQL_SAFE_UPDATES = 0;
ALTER TABLE movie
MODIFY worlwide_gross_income BIGINT;

SELECT (COUNT(*)/COUNT(WORLWIDE_GROSS_INCOME)) AS "missing_percetage" FROM MOVIE
WHERE WORLWIDE_GROSS_INCOME IS NULL;

-- Mean
select avg(WORLWIDE_GROSS_INCOME) from movie;-- '24648317.6801'

update movie  -- handling missing value using mean of column WORLWIDE_GROSS_INCOME
set WORLWIDE_GROSS_INCOME = 24648317.6801
where WORLWIDE_GROSS_INCOME is null;

-- median
select (count(*)+1)/2 from movie;

select WORLWIDE_GROSS_INCOME,DURATION 
from movie where id = "tt1826956" 
order by WORLWIDE_GROSS_INCOME asc;
-- here no id 3999
-- using window function

ALTER TABLE movie
drop COLUMN NEW_ID ;

-- WINDOW FUNCTION
SELECT ID,
row_number() OVER() -- 'tt1826956'
FROM MOVIE
ORDER BY WORLWIDE_GROSS_INCOME;
-- there are no duplicates available as primary key constraint is applied

set sql_safe_updates = 0; -- '103.8936'
select avg(duration) from movie;

update movie  -- handling missing value using mean of column WORLWIDE_GROSS_INCOME USING MEDIAN VALUE
set duration = 99
where duration = 103.8936;

SELECT * from movie where country is null;
set sql_safe_updates = 0;
update movie
set country = "NR"
where country is null;

update movie
set languages = "NR"
where languages is null;

update movie
set production_company = "NR"
where production_company is null;

select * from movie where country = "null";

-- checking the data integrity
Describe movie;
-- =========================================================
Describe director_mapping;
-- director_maping has no null values
-- =========================================================
Describe genre; -- genre has no null values
-- =========================================================
Describe names;
select count(*) from names where height is null;
select (count(*)/(select count(*) from names))* 100
from names where height is null; -- 67.35%
select avg(height) from names;
select (count(*) +1)/2 from names;

-- WINDOW FUNCTION
SELECT ID,
row_number() OVER() -- 'nm0817240 median id'
FROM names
ORDER BY height;
-- taking median value but median value of height is null
select height from names where id = "nm0817240";
select count(*) from names where known_for_movies is null;
-- here all columns contain null values greater than 50%

update names
set date_of_birth = "1878-01-01"
where date_of_birth is null;

update names
set known_for_movies = "No data"
where known_for_movies is null;

/* total counts 25735 median value id 12868 median id nm0817240
	name has no null
    no of null in height 17335/25735 67.35% avg 161.54
    
    if date of birth is not available then rigght first january date
*/
Describe ratings;
/*
avg_ratings,total_votes,median_rating
*/
Describe role_mapping;

-- descriptive stats
select avg(worlwide_gross_income), avg(duration) from movie;
select min(worlwide_gross_income), min(duration) from movie;
select max(worlwide_gross_income), max(duration) from movie;
select count(*) from movie 
	where worlwide_gross_income is null ;




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
select count(*) from movie;








-- Q2. Which columns in the movie table have null values?
-- Type your code below:









-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select monthname(DATE_PUBLISHED) AS "Name_of_Month", COUNT(ID) as "Number of movies" FROM MOVIE
GROUP BY monthname(DATE_PUBLISHED)
ORDER BY COUNT(ID) DESC;

-- march 824



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

select year(DATE_PUBLISHED) as "Year", count(id) as "Noof movies", country from movie
where year(DATE_PUBLISHED) = 2019 and country = "USa" or country = "India"
group by year(DATE_PUBLISHED),country
order by year(DATE_PUBLISHED) desc;








/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
select distinct(count(genre)) from genre;
select genre, count(movie_id) from genre 
group by genre;








/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

select genre, count(movie_id) from genre 
group by genre
order by count(movie_id) desc
limit 1;









/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
select genre, count(movie_id) as "No of movies" from genre 
group by genre
order by count(movie_id) desc;


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

select * from movie;
select * from genre;

select g.genre, avg(m.duration)
from genre g
inner join movie m 
on g.movie_id = m.id
group by g.genre
order by avg(m.duration) desc;


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:









/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
select genre, count(movie_id) as "No of movie" ,
Rank() over(order by count(movie_id)) as "genre_rank" 
from genre
group by genre;









/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

select min(avg_rating), max(avg_rating), min(total_votes), max(total_votes), min(median_rating), max(median_rating)
from ratings;





    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)



select m.title, r.avg_rating, r.median_rating
from movie m
left join ratings r
on m.id = r.movie_id;






/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
select median_rating, count(movie_id)
from ratings
group by median_rating
order by median_rating;









/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

select m.production_company, Count(m.id)
from movie m
join ratings r
on m.id = r.movie_id
where avg_rating > 8
group by m.production_company;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

 -- How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?-- 
select g.genre, count(g.movie_id) as "movie_count"
from genre g
left join movie m
on g.movie_id = m.id
join ratings r 
on g.movie_id = r.movie_id
where r.total_votes > 1000 and m.year = 2017 and m.country = "USA"
group by g.genre
order by movie_count;

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?


select m.title, r.avg_rating, g.genre
from movie m
join genre g
on m.id= g.movie_id
join ratings r
on m.id = r.movie_id
where avg_rating >8 and m.title like "The%"
order by avg_rating;



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

select m.id, m.title, r.median_rating
from movie m
join ratings r
on m.id = r.movie_id
where r.median_rating > 8 and m.date_published BETWEEN '2018-04-01' AND '2019-04-01';
-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
select m.country, sum(r.total_votes)
from movie m
join ratings r 
on m.id = r.movie_id
where m.country in ("Germany","Italy")
group by m.country
order by  m.country;

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/
-- Segment 3:
-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Who are the top three directors in the top three genres whose movies have an average rating > 8?
SELECT g.genre, d.name_id, AVG(r.avg_rating) AS avg_genre_rating
FROM genre g
JOIN ratings r
ON g.movie_id = r.movie_id
JOIN director_mapping d 
ON r.movie_id = d.movie_id
GROUP BY g.genre, d.name_id
HAVING AVG(r.avg_rating) > 8
ORDER BY avg_genre_rating DESC
LIMIT 3;


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Q20. Who are the top two actors whose movies have a median rating >= 8?
select n.name,r.median_rating
from names n
join ratings r 
on n.id = r.movie_id
where median_rating>8
order by median_rating;

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
select m.production_company, sum(r.total_votes),
RANK() OVER (ORDER BY SUM(r.total_votes) DESC) AS prod_comp_rank
from movie m
join ratings r 
on m.id = r.movie_id
group by m.production_company
order by sum(r.total_votes) desc;


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
SELECT 
    n.name AS actor_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(DISTINCT r.movie_id) AS movie_count,
    AVG(r.avg_rating) AS actor_avg_rating,
    RANK() OVER (ORDER BY AVG(r.avg_rating) DESC) AS actor_rank
FROM names n
JOIN role_mapping rm ON n.id = rm.name_id
JOIN movie m ON rm.movie_id = m.id
JOIN ratings r ON m.id = r.movie_id
WHERE m.country = 'India'
GROUP BY n.name
ORDER BY actor_avg_rating DESC;
-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT 
    n.name AS actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(DISTINCT m.id) AS movie_count,
    SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) AS actress_avg_rating,
    RANK() OVER (
        ORDER BY 
            SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) DESC,
            SUM(r.total_votes) DESC
    ) AS actress_rank
FROM names n
JOIN role_mapping rm ON n.id = rm.name_id
JOIN movie m ON rm.movie_id = m.id
JOIN ratings r ON m.id = r.movie_id
WHERE m.country = 'India'
  AND m.languages LIKE '%Hindi%'
  AND rm.category = 'actress'
GROUP BY n.name
HAVING COUNT(DISTINCT m.id) >= 3
ORDER BY actress_rank
LIMIT 5;







/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:

SELECT 
    m.title AS movie_name,
    CASE
        WHEN r.avg_rating > 8 THEN 'Superhit'
        WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit'
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch'
        ELSE 'Flop'
    END AS movie_category
FROM movie m
JOIN ratings r ON m.id = r.movie_id
JOIN genre g ON m.id = g.movie_id
WHERE g.genre = 'Thriller'
  AND r.total_votes >= 25000
ORDER BY r.avg_rating DESC;







/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT 
    g.genre,
    AVG(m.duration) AS avg_duration,
    SUM(AVG(m.duration)) OVER (ORDER BY g.genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
    AVG(AVG(m.duration)) OVER (ORDER BY g.genre ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_duration
FROM movie m
JOIN genre g ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY g.genre;
-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
WITH top_genres AS (
    SELECT g.genre
    FROM genre g
    GROUP BY g.genre
    ORDER BY COUNT(*) DESC
    LIMIT 3
)
SELECT 
    g.genre,
    m.year,
    m.title AS movie_name,
    m.worlwide_gross_income,
    RANK() OVER (
        PARTITION BY g.genre, m.year 
        ORDER BY m.worlwide_gross_income DESC
    ) AS movie_rank
FROM movie m
JOIN genre g ON m.id = g.movie_id
JOIN top_genres tg ON g.genre = tg.genre
WHERE m.worlwide_gross_income IS NOT NULL
ORDER BY g.genre, m.year, movie_rank
LIMIT 15;  -- 3 genres × 5 movies each

show tables;
select * from director_mapping;
select * from genre;
select * from movie;
select * from names;
select * from ratings;
select * from role_mapping;










-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    m.production_company,
    COUNT(m.id) AS movie_count,
    RANK() OVER (ORDER BY COUNT(m.id) DESC) AS prod_comp_rank
FROM movie m
JOIN ratings r ON m.id = r.movie_id
WHERE r.median_rating >= 8
  AND POSITION(',' IN m.languages) > 0   -- multilingual check
  AND m.production_company IS NOT NULL
GROUP BY m.production_company
ORDER BY movie_count DESC
LIMIT 2;






-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:
SELECT 
    n.name AS actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(DISTINCT m.id) AS movie_count,
    SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) AS actress_avg_rating,
    RANK() OVER (
        ORDER BY 
            SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) DESC,
            SUM(r.total_votes) DESC,
            n.name ASC
    ) AS actress_rank
FROM names n
JOIN role_mapping rm ON n.id = rm.name_id
JOIN movie m ON rm.movie_id = m.id
JOIN ratings r ON m.id = r.movie_id
WHERE r.avg_rating > 8
  AND rm.category = 'actress'
  AND EXISTS (
      SELECT 1 
      FROM genre g 
      WHERE g.movie_id = m.id 
        AND g.genre = 'Drama'
  )
GROUP BY n.name
ORDER BY actress_rank
LIMIT 3;







/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH director_movies AS (
    SELECT 
        d.name_id AS director_id,
        n.name AS director_name,
        m.id AS movie_id,
        m.date_published,
        r.avg_rating,
        r.total_votes,
        m.duration
    FROM director_mapping d
    JOIN names n ON d.name_id = n.id
    JOIN movie m ON d.movie_id = m.id
    JOIN ratings r ON m.id = r.movie_id
),
inter_movie AS (
    SELECT 
        director_id,
        director_name,
        movie_id,
        DATEDIFF(
            LEAD(date_published) OVER (PARTITION BY director_id ORDER BY date_published),
            date_published
        ) AS gap_days,
        avg_rating,
        total_votes,
        duration
    FROM director_movies
)
SELECT 
    director_id,
    director_name,
    COUNT(movie_id) AS number_of_movies,
    AVG(gap_days) AS avg_inter_movie_days,
    AVG(avg_rating) AS avg_rating,
    SUM(total_votes) AS total_votes,
    MIN(avg_rating) AS min_rating,
    MAX(avg_rating) AS max_rating,
    SUM(duration) AS total_duration
FROM inter_movie
GROUP BY director_id, director_name
ORDER BY number_of_movies DESC
LIMIT 9;





