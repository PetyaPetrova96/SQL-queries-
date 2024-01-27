--1.(a) A total of 410 chefs have created at least one recipe. 
--How many have not created
--any recipes?
--6

select count(*) from recipes re
right join chefs ch on re.created_by = ch.id 
where  re.created_by is null


--1.(b) The chef ‘Foodalicious’ has mastered 56 recipes that have some ingredient(s) of type
--‘spice’. How many recipes that have some ingredient(s) of type ‘spice’ has the chef
--‘Spicemaster’ mastered?
--57

select distinct(ma.recipe_id) from chefs ch
inner join master ma on ch.id = ma.chef_id
inner join use us on ma.recipe_id= us.recipe_id
inner join ingredients ing on us.ingredient_id = ing.id
where ch.name = 'Spicemaster' and ing.type = 'spice'

--1.(c) There are 1,257 recipes in the database with 10 or more steps registered. How many
--recipes have 3 or fewer steps registered?
--1139
select count(*) from(
	select recipe_id ,count(step)
	from steps 
	group by recipe_id
	having count(distinct step) <=3) as x

-- Correct Ans:
--1149
select count(*)
from recipes
where id not in (
	select S.recipe_id
	from steps S
	group by S.recipe_id
	having count(distinct S.step) > 3
);

--1.(d) How many recipes belong to the same cuisine as at least one of their ingredients?
--882
select count(distinct R.id)
from recipes R
	join use U on R.id = U.recipe_id
	join belong_to B on B.ingredient_id = U.ingredient_id
where R.belong_to = B.cuisine_id;

--1.(e) The recipe with name ‘Fresh Tomato Salsa Restaurant-Style’ has the most steps of
--all recipes, or 38. What is/are the name of the recipe/s with the most different
--ingredients of all recipes?
-- 1st part for Fresh Tomato Salsa,38
CREATE VIEW recipe_step_counts AS
SELECT r.id, r.name, COUNT(s.step) AS step_count
FROM recipes r
INNER JOIN steps s ON r.id = s.recipe_id
GROUP BY r.id, r.name
ORDER BY step_count DESC;

SELECT name, step_count
FROM recipe_step_counts
WHERE step_count = (SELECT MAX(step_count) FROM recipe_step_counts);
---
--2nd part for "Dinengdeng" 111
CREATE VIEW recipe_ingredients_counts AS
select R.name,count(distinct ingredient_id) AS count_ingr from recipes R
inner join use U on U.recipe_id = R.id
group by R.id
order by count_ingr DESC

SELECT name, count_ingr
FROM recipe_ingredients_counts
WHERE count_ingr = (SELECT MAX(count_ingr) FROM recipe_ingredients_counts);



--1.(f) We define the spice ratio of a cuisine as the number of ingredients that belong to it
--that are of type ‘spice’ divided by the total number of ingredients that belong to the
--cuisine. Here we consider only cuisines that actually have spices. The highest spice
--ratio is 1.0, and this sppice ratio is shared by 8 cuisines. How many cuisines share the
--lowest spice ratio?
--7
-- Create a view to count the number of spicy ingredients for each cuisine
CREATE VIEW spice_count AS
SELECT CU.id as cuisine_id, COUNT(*) AS spice_count
FROM cuisines CU
    JOIN belong_to B ON CU.id = B.cuisine_id
    JOIN ingredients I ON B.ingredient_id = I.id
WHERE I.type = 'spice'
GROUP BY CU.id;

-- Create a view to count the total number of ingredients for each cuisine
CREATE VIEW all_count AS
SELECT CU.id as cuiseine_id, COUNT(*) AS all_count, SC.spice_count, 1.0 * SC.spice_count / COUNT(*) AS ratio
FROM cuisines CU
    JOIN belong_to B ON CU.id = B.cuisine_id
    JOIN ingredients I ON B.ingredient_id = I.id
    JOIN spice_count SC ON CU.id = SC.id
GROUP BY CU.id, SC.spice_count;

-- Find the number of cuisines with the lowest spice ratio
SELECT COUNT(*)
FROM all_count
WHERE ratio = (SELECT MIN(ratio) FROM all_count);


--1.(g)There are 4,169 recipes that contain some ingredient of all ingredient types. How
--many recipes contain some ingredient of all ingredient types in the same step?
--1st part 
--4169
select count(recipe_id) 
from(
	select U.recipe_id,count(distinct I.type) as nm_of_types_inrecipe from use U 
	inner join ingredients I on U.ingredient_id = I.id
	group by U.recipe_id
	HAVING COUNT(DISTINCT I.type) = (SELECT COUNT(DISTINCT type) FROM ingredients)
	) as X;
	
--2nd part 
--2722
select count(distinct recipe_id) 
from (
	select U.recipe_id, U.step, count(*), count(distinct I.type) from use U
	inner join  ingredients I on U.ingredient_id = I.id
	group by U.recipe_id,U.step
	having count(distinct I.type) = (select count(distinct type)from ingredients I) 
)X;

--1.(h) Write a query that outputs the id and name of chefs, and total ingredient quantity
(--regardless of units), in order of decreasing quantity, for chefs that have created
--recipes in a cuisine with ‘Indian’ in the name, but only considering ingredients that
--belong to a cuisine with ‘Thai’ in the name.

drop view if exists indian_chefs;
create view indian_chefs as
select distinct C.id, C.name
from chefs C
     join recipes R on R.created_by = C.id
     join cuisines CU on CU.id = R.belong_to
where CU.name like '%Indian%';

select C.id, C.name, sum(quantity)
from indian_chefs C
     join recipes R on R.created_by = C.id
     join use U on U.recipe_id = R.id --18m
     join belong_to B on B.ingredient_id = U.ingredient_id
     join cuisines CU on CU.id = B.cuisine_id
where CU.name like '%Thai%'
group by C.id, C.name
order by sum(quantity) desc
