create table netflix 
(
	show_id	varchar(10),
	format varchar(10),
	type varchar(250),
	director varchar(500),
	casts varchar(1000),
	country varchar(1000),
	date_added varchar(10),
	release_year varchar(10),
	rating varchar(10),
	duration varchar(20),
	listed_in varchar(100),
	description varchar(250)
);

ALTER TABLE netflix
ALTER COLUMN release_year TYPE VARCHAR(50);

select * from netflix

-- 1. Count the number of Movies vs TV Shows

select format,count(*)
from netflix
group by format

-- 2. Find the most common rating for movies and TV shows
with rating_detail as (
select 
	format,
	rating,
	count(*) as countings,
	row_number() over(partition by format order by count(*) desc) as ranking
from 
	netflix
group by 
	format,
	rating
)
select *
from rating_detail
where ranking=1

-- 3. List all movies released in a specific year (e.g., 2020)

select * 
from netflix
where release_year = '2020' and format = 'Movie' 

-- 4. Find the top 5 countries with the most content on Netflix

with new_table as (
select unnest(string_to_array(country,',')) as new_country
from netflix 
where format = 'Movie'
)
select new_country,count(*) as counter
from new_table 
group by 1 
order by counter desc

-- 5. Identify the longest movie

with new_data as
(
select *,split_part(duration, ' ', 1)::int as new_duration
from netflix
where format='Movie' and duration is not null)

select show_id,new_duration
from new_data
order by new_duration desc

-- 6. Find content added in the last 5 years

select *
from netflix 
where date_added::date >= current_date - interval '6 years'
order by date_added::date 

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
with new_data as
(select *,unnest(string_to_array(director,',')) as new_director
from netflix )

select * 
from new_data
where new_director = 'Rajiv Chilaka'

-- 8. List all TV shows with more than 5 seasons

with new_data as
(
select *,split_part(duration, ' ', 1)::int as new_duration
from netflix
where format = 'TV Show'
)

select *
from new_data
where new_duration > 5

-- 9. Count the number of content items in each genre

with new_data as
(
select *,unnest(string_to_array(listed_in,',')) as new_genre
from netflix
)

select new_genre , count(*) as counter
from new_data
group by 1
order by 2 desc

-- 10.Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release!

with new_data as
(select *,unnest(string_to_array(country,',')) as new_country 
from netflix)

select release_year::int,count(*) as counter,round(avg(count(*))over(),2) as avg_count
from new_data
where new_country = 'India'
group by 1
order by 2 desc
limit 5

-- 11. List all movies that are documentaries

select *
from netflix 
where listed_in = 'Documentaries' and format = 'Movie'

-- 12. Find all content without a director

select *
from netflix 
where director is null

-- 13. Find how many movies actor 'Salman Khan' appeared in last 15 years!

with new_data as
(
select *,trim(unnest(string_to_array(casts,','))) as new_casts
from netflix
)

select *
from new_data
where new_casts = 'Salman Khan' and release_year::int >= extract(YEAR from current_date) - 15

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

with new_data as
(
select *,trim(unnest(string_to_array(casts,','))) as new_casts
from netflix
where format = 'Movie'
)

select new_casts,count(*) as counter
from new_data
where new_casts is not null and country ILIKE '%India%'
group by 1
order by 2 desc
limit 10

-- 15.
-- Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.

with new_data as
(
select * , 
	case 
		when description ILIKE '%kill%' or description ILIKE '%violence%' then 'Bad'
		else 'Good'
		end as category
from netflix
)

select *,count(category)over(partition by category) from new_data

--or 

with new_data as
(
select * , 
	case 
		when description ILIKE '%kill%' or description ILIKE '%violence%' then 'Bad'
		else 'Good'
		end as category
from netflix
)

select category,count(*) from new_data group by 1