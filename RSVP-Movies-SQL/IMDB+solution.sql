USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:


SELECT 
    table_name, table_rows
FROM
    INFORMATION_SCHEMA.TABLES
WHERE
    TABLE_SCHEMA = 'imdb';

-- or

SELECT 
    COUNT(*)
FROM
    movie;
SELECT 
    COUNT(*)
FROM
    genre;
SELECT 
    COUNT(*)
FROM
    director_mapping;
SELECT 
    COUNT(*)
FROM
    role_mapping;
SELECT 
    COUNT(*)
FROM
    names;
SELECT 
    COUNT(*)
FROM
    ratings;












-- Q2. Which columns in the movie table have null values?
-- Type your code below:


SELECT 
    SUM(CASE
        WHEN id IS NULL THEN 1
        ELSE 0
    END) AS id_num_null,
    SUM(CASE
        WHEN title IS NULL THEN 1
        ELSE 0
    END) AS title_num_null,
    SUM(CASE
        WHEN year IS NULL THEN 1
        ELSE 0
    END) AS year_num_null,
    SUM(CASE
        WHEN date_published IS NULL THEN 1
        ELSE 0
    END) AS date_published_num_null,
    SUM(CASE
        WHEN duration IS NULL THEN 1
        ELSE 0
    END) AS duration_num_null,
    SUM(CASE
        WHEN country IS NULL THEN 1
        ELSE 0
    END) AS country_num_null,
    SUM(CASE
        WHEN worlwide_gross_income IS NULL THEN 1
        ELSE 0
    END) AS worlwide_gross_income_num_null,
    SUM(CASE
        WHEN languages IS NULL THEN 1
        ELSE 0
    END) AS languages_num_null,
    SUM(CASE
        WHEN production_company IS NULL THEN 1
        ELSE 0
    END) AS production_company_num_null
FROM
    movie;









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


SELECT 
    year, 
    COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY year;


SELECT 
    EXTRACT(MONTH FROM date_published) AS month_num,
    COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY EXTRACT(MONTH FROM date_published)
ORDER BY EXTRACT(MONTH FROM date_published);




/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
    year, 
    COUNT(id) AS number_of_movies_2019
FROM
    movie
WHERE
    year = '2019'
        AND (country LIKE ('%USA%')
        OR country LIKE ('%India%')); 








/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT
    (genre)
FROM
    genre;








/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:


SELECT 
    movie_genre.genre,
    MAX(movie_genre.movie_count) AS number_of_movies
FROM
    (SELECT 
        genre.genre, 
        COUNT(genre.movie_id) AS movie_count
    FROM
        movie movie
    JOIN genre genre ON movie.id = genre.movie_id
    WHERE
        MOVIE.year = '2019'
    GROUP BY genre.genre
    ORDER BY movie_count DESC) movie_genre;








/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:


SELECT 
    COUNT(*)
FROM
    (SELECT 
        COUNT(DISTINCT (genre.genre)) AS movie_genre_count
    FROM
        movie movie
    JOIN genre genre ON movie.id = genre.movie_id
    GROUP BY genre.movie_id
    HAVING movie_genre_count = 1) movie_one_genre;




/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:



SELECT 
    genre.genre, 
    AVG(movie.duration) AS avg_duration
FROM
    movie movie
        JOIN
    genre genre ON movie.id = genre.movie_id
GROUP BY genre.genre
ORDER BY avg_duration DESC;
 





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

SELECT * FROM (
SELECT 
    genre.genre, 
    count(movie.id) AS movie_count,
    rank() over (order by count(movie.id) desc) as movierank
FROM
    movie movie
        JOIN
    genre genre ON movie.id = genre.movie_id
GROUP BY genre.genre) movie_t
WHERE movie_t.genre = "Thriller";


    






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

SELECT 
    MIN(RATINGS.avg_rating) AS min_avg_rating,
    MAX(RATINGS.avg_rating) AS max_avg_rating,
    MIN(ratings.total_votes) AS min_total_votes,
    MAX(ratings.total_votes) AS max_total_votes,
    MIN(ratings.median_rating) AS min_median_rating,
    MAX(ratings.median_rating) AS max_median_rating
FROM
    ratings;





    

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
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT * FROM (
				select  movie.title,
						ratings.avg_rating as avg_rating,
						row_number() over (order by avg_rating desc) as movie_rank
				from movie movie  join ratings ratings
				  on movie.id = ratings.movie_id
				) 
movie_avg_rating
where movie_rank <= 10;




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



SELECT 
    ratings.median_rating,
    COUNT(ratings.movie_id) AS movie_count
FROM
    ratings ratings
GROUP BY ratings.median_rating
ORDER BY ratings.median_rating DESC
;







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

select * from (
				select movie.production_company,
						count(movie.id) as movie_count,
						rank() over (order by count(ratings.movie_id) desc) as prod_company_rank
				 from movie movie join ratings ratings
				   on movie.id = ratings.movie_id
				where ratings.avg_rating > 8 and movie.production_company is not null
			 group by movie.production_company
			) 
prod_company_movie
where prod_company_rank = 1
;





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


SELECT 
    genre.genre, 
    COUNT(movie.id) AS movie_count
FROM
    movie movie JOIN ratings ratings ON movie.id = ratings.movie_id
				JOIN genre genre ON movie.id = genre.movie_id
WHERE
    EXTRACT(MONTH FROM date_published) = 3
        AND movie.year = 2017
        AND country LIKE '%USA%'
        AND ratings.total_votes > 1000
GROUP BY genre.genre
order by movie_count desc;






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


SELECT 
    (movie.title), 
    ratings.avg_rating, 
    genre.genre
FROM
    movie movie
         JOIN ratings ratings ON movie.id = ratings.movie_id
         JOIN genre genre ON movie.id = genre.movie_id
WHERE
    movie.title LIKE 'The%'
        AND ratings.avg_rating > 8
ORDER BY ratings.avg_rating desc;








-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.

SELECT 
    (movie.title), 
    ratings.median_rating, 
    genre.genre
FROM
    movie movie
        JOIN ratings ratings ON movie.id = ratings.movie_id
        JOIN genre genre ON movie.id = genre.movie_id
WHERE
    movie.title LIKE 'The%'
        AND ratings.median_rating > 8
ORDER BY ratings.median_rating;



-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


SELECT 
    ratings.median_rating,
    COUNT(movie.id)
FROM
    movie movie
        JOIN ratings ratings ON movie.id = ratings.movie_id
WHERE
    movie.date_published between '2018-04-01' and '2019-04-01'
AND ratings.median_rating = 8;


      






-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


SELECT 
    total_movie_votes.languages,
    SUM(total_movie_votes.total_votes) AS total_votes
FROM
    (
			SELECT 
				movie.languages, 
				SUM(ratings.total_votes) AS total_votes
			FROM
				movie movie
			 JOIN ratings ratings ON movie.id = ratings.movie_id
			WHERE movie.languages LIKE ('%German%')
			   OR movie.languages LIKE ('%Italian%')
			GROUP BY movie.languages
    ) total_movie_votes
WHERE
    total_movie_votes.languages LIKE '%German%' 
UNION 
SELECT 
    total_movie_votes.languages,
    SUM(total_movie_votes.total_votes) AS total_votes
FROM
    (
			SELECT 
				movie.languages, 
				SUM(ratings.total_votes) AS total_votes
			FROM
				movie movie
			 JOIN ratings ratings ON movie.id = ratings.movie_id
			WHERE movie.languages LIKE ('%German%')
			   OR movie.languages LIKE ('%Italian%')
			GROUP BY movie.languages
    ) total_movie_votes
WHERE
    total_movie_votes.languages LIKE '%Italian%';






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


SELECT 
    SUM(CASE
        WHEN name IS NULL THEN 1
        ELSE 0
    END) AS name_nulls,
    SUM(CASE
        WHEN height IS NULL THEN 1
        ELSE 0
    END) AS height_nulls,
    SUM(CASE
        WHEN date_of_birth IS NULL THEN 1
        ELSE 0
    END) AS date_of_birth_nulls,
    SUM(CASE
        WHEN known_for_movies IS NULL THEN 1
        ELSE 0
    END) AS known_for_movies_nulls
FROM
    names;






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



select names.name as director_name,
		count(movie.id) as movie_count
from  names names 
join director_mapping director_mapping on names.id = director_mapping.name_id
join movie movie on movie.id = director_mapping.movie_id
join genre genre on movie.id = genre.movie_id
join ratings ratings on movie.id = ratings.movie_id
 where genre.genre in 
	 (select genre_movie_t.genre from 
				(select genre.genre,
					count(movie.id) as  movie_count,
					row_number() over (order by count(movie.id) desc) as movie_count_rank
					from movie movie join genre genre
					on movie.id = genre.movie_id
					join ratings ratings on genre.movie_id = ratings.movie_id
					where ratings.avg_rating > 8
					group by genre.genre
				) genre_movie_t
	where movie_count_rank <=3
    )
and ratings.avg_rating > 8
group by names.name
order by count(movie.id) desc limit 3
;



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


select top_actors.actor_name, 
		top_actors.movie_count from
		(select names.name as actor_name,
				count(movie.id) as movie_count,
				row_number() over(order by count(movie.id) desc ) as movie_count_row
		from movie movie join role_mapping role_mapping on movie.id = role_mapping.movie_id
		join ratings ratings on movie.id = ratings.movie_id
		join names names on role_mapping.name_id = names.id
		where ratings.median_rating >= 8
		group by role_mapping.name_id
		) top_actors
where top_actors.movie_count_row <=2;






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


select movie.production_company,
	   sum(ratings.total_votes) as vote_count,
	   rank() over( order by sum(ratings.total_votes) desc) as prod_comp_rank
from movie movie join ratings ratings
  on movie.id = ratings.movie_id
group by 
	 movie.production_company limit 3;







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


select names.name as actor_name,
		sum(ratings.total_votes) as total_votes,
        count(movie.id) as movie_count,
		round(sum(ratings.avg_rating * ratings.total_votes )/sum(ratings.total_votes),2) as actor_avg_rating,
		rank() over (order by ratings.avg_rating desc,  sum(ratings.total_votes) desc) as actor_rank
from movie movie join ratings ratings
  on movie.id = ratings.movie_id
join role_mapping role_mapping on movie.id = role_mapping.movie_id
join names names on role_mapping.name_id = names.id
where movie.country like '%India%'
group by names.name having count(movie.id) >= 5;







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

select names.name as actress_name,
		ratings.total_votes as total_votes,
		count(movie.id) as movie_count,
		round(sum(ratings.avg_rating*ratings.total_votes)/sum(ratings.total_votes),2) as actress_avg_rating,
		rank() over (order by round(sum(ratings.avg_rating*ratings.total_votes)/sum(ratings.total_votes),2) desc, sum(ratings.total_votes) desc) as actress_rank
from movie movie join ratings ratings
on movie.id = ratings.movie_id
join role_mapping role_mapping on movie.id = role_mapping.movie_id
join names names on role_mapping.name_id = names.id
where movie.country like '%India%'
  and movie.languages like '%Hindi%'
  and role_mapping.category = 'actress'
group by names.name having count(movie.id) >= 3
limit 5 ;










/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT 
    movie.title,
    ratings.avg_rating,
    CASE
        WHEN ratings.avg_rating >= 8 THEN 'Superhit movies'
        WHEN
            ratings.avg_rating >= 7
                AND ratings.avg_rating < 8
        THEN
            'Hit movies'
        WHEN
            ratings.avg_rating >= 5
                AND ratings.avg_rating < 7
        THEN
            'One-time-watch movies'
        WHEN ratings.avg_rating < 5 THEN 'Flop movies'
    END AS Movie_Category
FROM
    movie movie
        JOIN genre genre ON movie.id = genre.movie_id
        JOIN ratings ratings ON movie.id = ratings.movie_id
WHERE
    genre.genre = 'Thriller';






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

select genre.genre,
		avg(movie.duration) as avg_duration,
		sum(avg(movie.duration)) over (order by genre.genre rows unbounded preceding) as running_total_duration,
		avg(avg(movie.duration)) over (order by genre.genre rows unbounded preceding) as moving_avg_duration
from movie movie join genre genre on movie.id = genre.movie_id
group by genre.genre
order by genre.genre
;





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

with Top_3_genre as
				(	SELECT genre, 
							COUNT(ratings.movie_id) AS number_of_movies
					FROM genre genre
						JOIN movie movie ON genre.movie_id = movie.id
						JOIN ratings ratings ON movie.id = ratings.movie_id
					GROUP BY genre.genre
					ORDER BY number_of_movies DESC
					LIMIT 3
                )
, Top_5_highest_grossing as
				(	select genre,
							year,title as movie_name,
							worlwide_gross_income,
							dense_rank() over (partition by year order by worlwide_gross_income desc) as movie_rank
					from movie movie 
							join genre genre on movie.id= genre.movie_id
					where genre in (select genre from Top_3_genre)
                )
SELECT 
    *
FROM
    Top_5_highest_grossing
WHERE
    movie_rank <= 5;










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



select movie.production_company,
		count(movie.id) as movie_count,
        row_number() over(order by count(movie.id) desc) as prod_comp_rank
from movie movie join ratings ratings on
movie.id=ratings.movie_id
where ratings.median_rating >= 8 
and production_company is not null and position(',' in languages) > 0
group by production_company
limit 2;




-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select names.name as actress_name,
		sum(ratings.total_votes) as total_votes,
		count(movie.id) as movie_count,
		avg(ratings.avg_rating) as actress_avg_rating,
		rank() over (order by count(movie.id) desc) as actress_rank
from movie movie 
join ratings ratings on movie.id = ratings.movie_id
join role_mapping role_mapping on movie.id = role_mapping.movie_id
join names names on role_mapping.name_id = names.id
join genre genre on movie.id = genre.movie_id
where role_mapping.category = 'actress'
and ratings.avg_rating > 8
and genre.genre = 'Drama' 
group by names.name
limit 3;







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


with date_information as
		(
			select director_mapping.name_id, name, 
				   director_mapping.movie_id,movie.date_published, 
				   lead(date_published, 1) over 
				   (partition by director_mapping.name_id order by date_published, director_mapping.movie_id) as next_movie_date
			from director_mapping director_mapping
				 join names names on director_mapping.name_id = names.id 
				 join movie movie on director_mapping.movie_id = movie.id
		),
date_diff as
		(
			 select *, datediff(next_movie_date, date_published) as diff
			 from date_information
		 ),
         
 avg_inter_days as
		 (
			 select name_id, avg(diff) as avg_inter_movie_days
			 from date_diff
			 group by name_id
		 ),
 final_table as
		 (
			 select director_mapping.name_id as director_id,
				 name as director_name,
				 count(director_mapping.movie_id) as number_of_movies,
				 round(avg_inter_movie_days) as inter_movie_days,
				 round(avg(avg_rating),2) as avg_rating,
				 sum(total_votes) as total_votes,
				 min(avg_rating) as min_rating,
				 max(avg_rating) as max_rating,
				 sum(duration) as total_duration,
				 row_number() over(order by count(director_mapping.movie_id) desc) as director_row_rank
			 from
				 names names join director_mapping director_mapping on names.id=director_mapping.name_id
				 join ratings ratings on director_mapping.movie_id=ratings.movie_id
				 join movie movie on movie.id=ratings.movie_id
				 join avg_inter_days a on a.name_id=director_mapping.name_id
			 group by director_id
		 )
 select director_id,
		director_name, 
        number_of_movies, 
        inter_movie_days, 
        avg_rating, t
        otal_votes, 
        min_rating,
		max_rating, 
        total_duration
 from final_table limit 9;







