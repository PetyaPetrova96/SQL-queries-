--(a) There are 8 different plants that are missing the family information. How many
--plants belong to the family “Thespesia”?
--8
select familyid,name from plants
where familyid is null

--18
select count(*) from plants P
inner join families  F on F.id = P.familyid
where F.name like '%Thespesia'


--(b) Of the people in the database, 11 have not planted anything. How many of those,
--who have not planted anything, have the position “Planter”?
--11
select count(*) from people P
left join plantedin PL on P.id = PL.planterid
where PL.planterid is null

--9
select count(*) from people P
left join plantedin PL on P.id = PL.planterid
where PL.planterid is null and P.position = 'Planter'


--(c) The total area of the family “Thespesia” is 66.62 (the unit is square meters; on my
--machine, the exact number is 66.62000000000003). What is the total area of the
--family “Vicia”?
--Note: The result needs only be accurate to two digits after the decimal point.
--66,62
select sum(size*percentage/100) as sq_meters from plantedin PL
inner join flowerbeds FL on PL.flowerbedid = FL.id
inner join plants P on P.id = pl.plantid
inner join families f on f.id = P.familyid
where f.name = 'Thespesia'

--27,3
select sum(size*percentage/100) as sq_meters from plantedin PL
inner join flowerbeds FL on PL.flowerbedid = FL.id
inner join plants P on P.id = pl.plantid
inner join families f on f.id = P.familyid
where f.name = 'Vicia'



--(d) The most overfilled flowerbed is planted to 105% capacity. What are the ID(s) of the
--flowerbed(s) with the most overfilled capacity?
--Note: The output of this query could contain more than one identifier.
--Create a view 
drop view if exists bedperc;
create view bedperc 
as
select I.flowerbedID as ID, sum(I.percentage) as perc
from plantedin I
group by I.flowerbedID;

--105
select max(BP.perc)
from bedperc BP;

--243
select BP.ID
from bedperc BP
where BP.perc = (
	select max(BP.perc)
	from bedperc BP
);


--(e) There are 9 flowerbeds that are planted to more than 100% capacity. How many
--flowerbeds are planted to less than 100% capacity.
--9
select count(*)
from bedperc BP
where BP.perc > 100;

--273
select count(*)
from flowerbeds B
where B.ID not in (
	select BP.ID
	from bedperc BP
	where BP.perc >= 100
);



--(f) How many flowerbeds are planted to less than 100% capacity, and have a plant of
--the type “shrub” planted in them?
--150
select count(*)
from bedperc BP
where BP.perc < 100
 	and BP.ID in (
		select I.flowerbedID
	  	from plantedin I
	  		join plants P on I.plantID = P.ID
			join families F on P.familyID = F.ID
			join types T on F.typeID = T.ID
		where T.name = 'herb'
);

--(g) There are 354 families that are planted in at least one flowerbed in all the parks from
--the database. How many flowerbeds have at least one plant of all types from the
--database.

--354
select count(*)
from (
	select F.ID  --,  count(*), count(distinct B.ID), count(distinct B.parkID) -- use these for debugging
	from families F
		join plants P on F.ID = P.familyID
		join plantedin I on P.ID = I.plantID
		join flowerbeds B on B.ID = I.flowerbedID
	group by F.ID
	having count(distinct B.parkID) = (
		select count(*)
		from parks K
	) 
) X;




