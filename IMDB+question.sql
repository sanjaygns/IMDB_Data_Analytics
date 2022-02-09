USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT COUNT(*)
FROM director_mapping;
-- 3867

SELECT COUNT(*)
FROM genre;
-- 14662

SELECT COUNT(*)
FROM movie;
-- 7997

SELECT COUNT(*)
FROM names;
-- 25735

SELECT COUNT(*)
FROM ratings;
-- 7997

SELECT COUNT(*)
FROM role_mapping;
-- 15615


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
select 
    sum(case when country is null then 1 else 0 end) as country, 
    sum(case when date_published is null then 1 else 0 end) as date_published, 
    sum(case when duration is null then 1 else 0 end) as duration,
    sum(case when id is null then 1 else 0 end) as id,
    sum(case when languages is null then 1 else 0 end) as languages,
    sum(case when production_company is null then 1 else 0 end) as production_company,
    sum(case when title is null then 1 else 0 end) as title,
    sum(case when worlwide_gross_income is null then 1 else 0 end) as worlwide_gross_income,
    sum(case when year is null then 1 else 0 end) as year
    
FROM movie



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

SELECT year as Year, COUNT(id) as number_of_movies
from movie
GROUP by year
ORDER by year;




SELECT month(date_published) as month_num, COUNT(id) as number_of_movies
from movie
GROUP by month_num
ORDER by month_num;



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT country, COUNT(id) as number_of_movies
from movie
WHERE country in ('India', 'USA') 
GROUP by country;



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT(genre)
from genre


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:


SELECT G.genre, COUNT(M.id) as number_of_movies
from genre G
INNER JOIN movie M
on M.id=G.movie_id
GROUP by G.genre
ORDER by number_of_movies DESC
LIMIT 1

-- Drama genre had the highest number of movies produced overall which is 4285.



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH group123 as (
SELECT  movie_id, count(genre) as number_of_genre
from genre
GROUP by movie_id
    ) SELECT COUNT(number_of_genre) from group123
    WHERE number_of_genre=1


-- 3289 movies belong to only one genre

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


SELECT G.genre, round(AVG(M.duration)) as avg_duration
from genre G
INNER JOIN movie M
on M.id=G.movie_id
GROUP by G.genre
ORDER by avg_duration DESC




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

SELECT G.genre, COUNT(M.id) as number_of_movies, 
RANK() OVER( ORDER by COUNT(M.id) DESC) as genre_rank
from genre G
INNER JOIN movie M
on M.id=G.movie_id
GROUP by G.genre
ORDER by number_of_movies DESC
LIMIT 2, 1




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
MIN(avg_rating) as min_avg_rating,
MAX(avg_rating) as max_avg_rating,
MIN(total_votes) as min_total_votes,
MAX(total_votes) as max_total_votes,
MIN(median_rating) as min_median_rating,
MAX(median_rating) as max_median_rating        
FROM ratings



    

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

WITH top_table as (
    SELECT M.title, R.avg_rating,
	RANK() OVER(ORDER BY R.avg_rating DESC) as movie_rank
	FROM ratings R
	INNER JOIN movie M
	ON R.movie_id=M.id )
    SELECT *
    FROM top_table
    WHERE movie_rank<=10;



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

SELECT median_rating, COUNT(movie_id) as movie_count
from ratings
GROUP BY median_rating;




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


SELECT M.production_company, count(M.id) as movie_count,
RANK() OVER(order by count(M.id) DESC) as prod_company_rank
FROM ratings R
INNER JOIN movie M
ON R.movie_id=M.id
where R.avg_rating>8 and M.production_company is not NULL
GROUP by M.production_company
ORDER by prod_company_rank
LIMIT 1


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

SELECT G.genre, COUNT(M.id) as movie_count
FROM movie M
INNER JOIN genre G
ON M.id=G.movie_id
INNER JOIN ratings R
ON M.id=R.movie_id
WHERE M.country='USA' AND M.year=2017 AND month(M.date_published)=3 AND R.total_votes>1000
GROUP BY G.genre
ORDER BY movie_count DESC




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

SELECT M.title, R.avg_rating,  G.genre
FROM movie M
INNER JOIN genre G
ON M.id=G.movie_id
INNER JOIN ratings R
ON M.id=R.movie_id AND M.title LIKE 'The%'
WHERE R.avg_rating>8







-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT COUNT(M.id)
FROM movie M 
INNER JOIN ratings R
ON M.id=R.movie_id
WHERE R.median_rating=8 AND M.date_published BETWEEN '2018-04-01' AND  '2019-04-01'







-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


-- German Votes - 4421525
-- Italian Votes - 2559540

FROM movie M 
INNER JOIN ratings R
ON M.id=R.movie_id
WHERE M.languages LIKE '%German%' ),
italian as (
SELECT 'Votes' as Italian, SUM(R.total_votes) as votes
FROM movie M 
 JOIN ratings R
ON M.id=R.movie_id
WHERE M.languages LIKE '%Italian%'
    ) SELECT * from 
    german G INNER JOIN italian I ON G.German=I.Italian



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


select 
    sum(case when name is null then 1 else 0 end) as name_nulls, 
    sum(case when height is null then 1 else 0 end) as height_nulls, 
    sum(case when date_of_birth is null then 1 else 0 end) as date_of_birth_nulls,
    sum(case when known_for_movies is null then 1 else 0 end) as known_for_movies_nulls
FROM names





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


WITH genre_selection 
AS
(
WITH top_genre 
AS
(
    SELECT genre, 
    COUNT(title) AS movie_count,
        RANK() OVER(ORDER BY COUNT(title) DESC) as genre_rank
    FROM
		movie AS m
        INNER JOIN ratings as rt
        ON rt.movie_id=m.id
        INNER JOIN genre as gn
        ON gn.movie_id=m.id
	WHERE avg_rating > 8
    GROUP BY genre)
         SELECT genre
         FROM top_genre
         WHERE genre_rank <4
),
top_director AS 
(
SELECT n.name AS director_name,
COUNT(g.movie_id)  AS movie_count,
      RANK() OVER(ORDER BY COUNT(g.movie_id) DESC) AS director_rank
FROM names AS n
      INNER JOIN director_mapping AS dm 
      ON n.id=dm.name_id
      INNER JOIN genre as g
      ON dm.movie_id=g.movie_id
      INNER JOIN ratings r 
      ON r.movie_id=g.movie_id,
      genre_selection
WHERE g.genre IN (genre_selection.genre) AND avg_rating > 8
GROUP BY director_name
ORDER BY movie_count DESC
)
SELECT *
FROM top_director
WHERE director_rank <=3
LIMIT 3






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


SELECT N.name as actor_name,  COUNT(R.movie_id) as movie_count
FROM names N
INNER JOIN role_mapping RO 
on RO.name_id=N.id
INNER JOIN ratings R 
ON RO.movie_id=R.movie_id
WHERE RO.category='actor' AND R.median_rating>=8
GROUP BY N.id
ORDER BY COUNT(R.movie_id) DESC
LIMIT 2





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



SELECT M.production_company, SUM(R.total_votes) as vote_count,
RANK() OVER(ORDER BY SUM(R.total_votes) DESC) as prod_comp_rank
FROM movie M 
INNER JOIN ratings R 
ON M.id=R.movie_id
GROUP BY M.production_company
ORDER BY prod_comp_rank ASC
LIMIT 3






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

SELECT name AS actor_name, SUM(total_votes) AS total_votes, COUNT(m.id) AS movie_count, 
	ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actor_avg_rating, 
	RANK() OVER(ORDER BY SUM(avg_rating*total_votes)/SUM(total_votes) DESC) AS actor_rank
FROM movie AS m 
	INNER JOIN ratings AS r ON m.id=r.movie_id 
	INNER JOIN role_mapping AS rm ON m.id=rm.movie_id 
	INNER JOIN names AS n ON rm.name_id=n.id
WHERE category='actor' AND country= 'india'
GROUP BY name
HAVING COUNT(m.id)>=5
ORDER BY actor_rank
-- limit 1 is optional to answer Which actor is at the top of the list








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


SELECT name AS actress_name, SUM(total_votes) AS total_votes, COUNT(m.id) AS movie_count, 
	ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating, 
	RANK() OVER(ORDER BY SUM(avg_rating*total_votes)/SUM(total_votes) DESC) AS actress_rank
FROM movie AS m 
	INNER JOIN ratings AS r ON m.id=r.movie_id 
	INNER JOIN role_mapping AS rm ON m.id=rm.movie_id 
	INNER JOIN names AS n ON rm.name_id=n.id
WHERE category='Actress' AND country= 'india'
GROUP BY name
HAVING COUNT(m.id)>=3
ORDER BY actress_rank
limit 5






/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:



SELECT *, CASE 
WHEN R.avg_rating>8 then 'Superhit movies'
WHEN  R.avg_rating BETWEEN 7 and 8 then 'Hit movies'
WHEN R.avg_rating BETWEEN 5 and 7 then 'One-time-watch movies'
ELSE 'Flop movies' 
END AS movie_category
FROM ratings R 
INNER JOIN genre G 
on G.movie_id=R.movie_id
WHERE G.genre='thriller'





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


SELECT genre,
            ROUND(AVG(duration), 2) AS avg_duration,
            SUM(ROUND(AVG(duration), 2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
            AVG(ROUND(AVG(DURATION), 2)) OVER(ORDER BY genre ROWS 10 PRECEDING) AS moving_avg_duration
FROM movie AS m
INNER JOIN genre as gn
ON m.id=gn.movie_id
GROUP BY genre
ORDER BY genre;






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

WITH genre_selection 
AS
(
    WITH top_genre 
	AS
	(
    	SELECT genre, 
    	COUNT(title) AS movie_count,
        RANK() OVER(ORDER BY COUNT(title) DESC) as genre_rank
    	FROM
		movie AS m
        INNER JOIN ratings as rt
        ON rt.movie_id=m.id
        INNER JOIN genre as gn
        ON gn.movie_id=m.id
    	GROUP BY genre
    )
    SELECT genre
    FROM top_genre
    WHERE genre_rank <4
),
top_movies AS 
(
	SELECT GN.genre, M.year, M.title as movie_name, M.worlwide_gross_income, 
    RANK() OVER(ORDER BY (cast(substr(replace( replace(M.worlwide_gross_income, 'INR', ''), '$', '' ), 2, length(replace( replace(M.worlwide_gross_income, 'INR', ''), '$', '' ))-1) as int) ) DESC)  as movie_rank
	FROM
    movie M 
    INNER JOIN genre GN
    ON GN.movie_id=M.id,
    genre_selection
	WHERE GN.genre IN (genre_selection.genre)
	ORDER BY movie_rank
)
SELECT *
FROM top_movies
LIMIT 5








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

SELECT m.production_company, COUNT(r.movie_id) as movie_count,
RANK() OVER(ORDER BY COUNT(r.movie_id) DESC) prod_company_rank
FROM movie as m
INNER JOIN ratings as r
ON m.id = r.movie_id
WHERE r.avg_rating > 8  and m.production_company is NOT Null AND m.languages LIKE '%,%'
GROUP BY m.production_company
ORDER BY prod_company_rank
LIMIT 2






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

SELECT  n.name as actress_name , r.total_votes , COUNT(r.movie_id) as movie_count, 
r.avg_rating as actress_avg_rating, 
RANK() OVER(ORDER BY COUNT(r.movie_id) DESC) as actress_rank
FROM names n
INNER JOIN role_mapping rm
ON n.id = rm.name_id
INNER JOIN movie m
ON rm.movie_id = m.id
INNER JOIN ratings r
ON m.id = r.movie_id
INNER JOIN genre g
ON g.movie_id = r.movie_id
WHERE r.avg_rating > 8 AND g.genre = 'Drama' AND rm.category ='actress'
GROUP BY n.name, r.total_votes
LIMIT 3






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


SELECT D.name_id, N.name, COUNT(M.id) as number_of_movies, IFNULL(TIMESTAMPDIFF(DAY, MIN(M.date_published), MAX(M.date_published)) / NULLIF(COUNT(*) - 1, 0), 0) as avg_inter_movie_days, round(AVG(R.avg_rating), 2) AS avg_rating, sum(R.total_votes) as total_votes, min(R.avg_rating) as min_rating, max(R.avg_rating) as max_rating, SUM(M.duration) AS total_duration
FROM director_mapping D 
INNER JOIN names N 
ON N.id=D.name_id
INNER JOIN ratings R
ON R.movie_id=D.movie_id
INNER JOIN movie M 
On D.movie_id=M.id
GROUP by D.name_id
ORDER BY count(M.id) DESC
LIMIT 9




