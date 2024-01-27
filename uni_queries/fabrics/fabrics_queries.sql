--(a) The chiffon fabric consists of 9 different elements. How many different elements does
--the cashmere fabric consist of?
--2
select count(distinct e_element) from gfabrics f 
inner join gelements e on e.f_id = f.f_id
where f_name = 'cashmere'


--(b) There are 84 countries that have more than one designer. How many countries have
--more than two designers?
select count( distinct d_country)from (
	select d_country,count(distinct d_id) as numb_of_designers from gdesigners
	group by d_country
	having count(distinct d_id) > 2 
) As X;

--(c) In the database, 12609 garments have a price that is higher than the average garment
--price. How many garments have a price that is lower than the average garment price?

--There are NULL values, so we gotta exclude them
select * from ggarments
where g_price is NULL
--15561

SELECT COUNT(g_id) FROM gGarments
WHERE g_id NOT IN (
    SELECT g_id FROM gGarments 
    WHERE g_price >= (SELECT AVG(g_price) FROM gGarments)
);

--(d) How many garments with missing price values have a type of importance equal to
--six?
--33
select count(distinct gg.g_id) from ghastype gh
inner join ggarments  gg on gg.g_id = gh.g_id
where g_price is NULL and ht_importance = 6


--(e) How many main designers have designed garments in all categories that exist in the
--database? Note that in this query you should only consider the main designers, not
--co-designers.
--8
select count(*) 
from (
	select distinct de.d_id,count(distinct ty.t_id) as count from gdesigners  de
	inner join ggarments ga on de.d_id = ga.d_id
	inner join ghastype gh on gh.g_id = ga.g_id
	inner join gtypes ty on  ty.t_id = gh.t_id
	group by ga.d_id,de.d_id
	having count(distinct ty.t_category) = (SELECT COUNT(DISTINCT t_category)FROM gtypes )
)as x 

--(f) The designer with d ID of 200 has collaborated, either as the main designer or as the
--co-designer, with 11 other designers from 7 different countries. How many designers
--have collaborated with other designers from 14 different countries?


create view get_d_id_co_id as 
select * from ggarments
where d_id= 200 or co_id =200

select distinct(d_id,co_id) from get_d_id_co_id


select distinct(d_id) from get_d_id_co_id
select distinct(co_id) from get_d_id_co_id



CREATE VIEW distinct_numbers_view AS
SELECT DISTINCT number
FROM (
    SELECT d_id AS number
    FROM get_d_id_co_id
    WHERE d_id != 200
    UNION
    SELECT co_id AS number
    FROM get_d_id_co_id
    WHERE co_id != 200
) AS subquery;

select distinct(d_country) from gdesigners G
inner join distinct_numbers_view  D on D.number = G.d_id

