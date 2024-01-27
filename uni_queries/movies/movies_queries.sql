--1.The person relation contains 4 entries with a registered death date on ‘2010-03-17’. 
--How many entries do not have a registered death date?
SELECT COUNT(*) from person
WHERE deathdate IS NULL

--2.In the database, there are 279 movies in the French language for which the average
--height of all the people involved is greater than 175 centimeters (ignoring people with
--unregistered height). What is the number of movies in the French language for which
--the average height of all people involved is greater than 185 centimeters?

select count(*) from (select distinct(mo.id),mo.title,max(per.height)  from movie mo
inner join involved i on i.movieid = mo.id
inner join person per on per.id = i.personid
where mo.language = 'French'
group by mo.id,mo.title
having 185 <(select(avg(per.height)))
order by mo.id) s


--3.The movie genre relation does not have a primary key, which can lead to a movie
--having more than one entry with the same genre. As a result, there are 3 movies
--in movie genre that have the genre ‘Crime’ assigned to them more than once. How
--many movies in movie genre have the genre ‘Action’ assigned to them more than
--once? 
SELECT COUNT(movieid)
FROM (
    SELECT movieid
    FROM movie_genre
    WHERE genre = 'Action'
    GROUP BY movieid
    HAVING COUNT(*) > 1
) AS duplicate_actions;

--4 According to the information in the database, 7689 different people acted in movies
--directed by ‘Quentin Tarantino’. How many different people acted in movies directed
--by ‘Ingmar Bergman’?


SELECT COUNT(DISTINCT i.personid) AS num_actors
FROM involved i
INNER JOIN movie m ON m.id = i.movieid
INNER JOIN person p ON p.id = i.personid
WHERE m.id IN (
    SELECT DISTINCT i.movieid
    FROM involved i
    INNER JOIN person p ON p.id = i.personid
    INNER JOIN movie m ON m.id = i.movieid
    INNER JOIN role r ON r.role = i.role
    WHERE p.name = 'Ingmar Bergman'
    AND r.role = 'director'
);



--5.Of all the movies produced in 2002, there are 11 that have only one actor involved
--in them. How many movies produced in 2010 have only one actor involved in them?

SELECT COUNT(*) FROM
(select mo.id as movieid,mo.title,mo.year,i.role,count(i.personid) as number_of_actors from movie mo
inner join involved i on i.movieid = mo.id
where year = 2010 and i.role = 'actor'
GROUP BY mo.id, mo.title, mo.year, i.role
having count(i.personid) = 1 
order by movieid) as movies_with_one_actor

--6. ?? In the database, there are 16 cases where a specific actor and director have collaborated together 
--on 12 movies. How many are the cases where a specific actor and
--director collaborated together in more than 12 movies?

SELECT COUNT(*)
FROM (
    SELECT I1.personId, I2.personId, count(*)
    FROM involved I1
    JOIN involved I2 ON I1.movieId = I2.movieId AND I1.personId <> I2.personId
    WHERE I1.role = 'actor' AND I2.role = 'director'
    GROUP BY I1.personId, I2.personId
    HAVING COUNT(*) = 12
) X;

--7. Of all the movies produced in 2010, there are 237 that have entries registered in
--involved for all roles defined in the roles relation. How many movies produced in
--2000 have entries registered in involved for all roles defined in the roles relation?

SELECT COUNT(*) AS movies_with_actor_and_director
FROM (
    SELECT mo.id, mo.title
    FROM movie mo
    INNER JOIN involved i ON i.movieid = mo.id
    WHERE year = 2000 AND i.role IN ('actor', 'director')
    GROUP BY mo.id, mo.title
    HAVING COUNT(DISTINCT i.role) = 2
) AS subquery;


--8. The number of people who have played a role in movies of all genres in the category
--‘Misc’ is 543. How many people have played a role in movies of all genres in the
--category ‘Popular’?

SELECT COUNT(*)
FROM(
    SELECT DISTINCT(personid)
    FROM involved i
    JOIN movie_genre mg ON i.movieid = mg.movieid
    JOIN genre g ON mg.genre = g.genre
    WHERE g.category = 'Popular'
    GROUP BY personid
    HAVING COUNT(DISTINCT(g.genre)) = (
        SELECT COUNT(DISTINCT(g.genre))
        FROM genre g
        WHERE g.category = 'Popular')) f;



