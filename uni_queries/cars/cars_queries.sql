--(a) The database has 13 models made by the maker VOLVO. How many actual cars have
--been made by VOLVO?
--13
select count(distinct m.id) from cars C 
inner join models M on C.modelid = M.id
inner join makers MA on MA.id=M.makerid
where MA.name like '%VOLVO'

--664
select distinct C.id from cars C 
inner join models M on C.modelid = M.id
inner join makers MA on MA.id=M.makerid
where MA.name like '%VOLVO'

--(b) Person with ID = 34 has bought cars from 7 different makers. How many different
--makers has the person with ID = 45 bought from?
select count(distinct M.makerID)
from sales S
	join cars C on S.carID = C.ID
	join models M on C.modelID = M.ID
where S.personID = 34;
-- 7

select count(distinct M.makerID)
from sales S
	join cars C on S.carID = C.ID
	join models M on C.modelID = M.ID
where S.personID = 45;
-- 7


--(c) Six different makers have produced the fewest models, or only one each. What is the
--ID of the maker which has produced the most models?
--Note: This query returns an identifier, not a count of result rows.
select makerID
from models M
group by M.makerID
having count(*) = (
	select max(cnt)
	from (
		select count(*) as cnt
		from models M
		group by makerID
	) X
);
-- 10
--(d) How many cars have been sold fewer than 2 times?
select count(*)
from (
	select C.ID
	from cars C
		left join sales S on C.ID = S.carID
	where S.carID is null
	union all -- there can be no duplicates... 
	select S.carID 
	from sales S
	group by S.carID
	having count(*) < 2
) X;
-- 818


--(e) The car with licence LX363 has been sold eleven times, according to the database.
--What is the licence of the car sold most often?
--Note: This query returns a short string.
-- helper view that groups by licence and counts sales
drop view if exists licsales;
create view licsales
as 
select C.licence, count(*) as salecount
from sales S
	join cars C on S.carID = C.id
group by C.licence;

select LS.salecount
from licsales LS
where LS.licence = 'LX363';
-- 11

select LS.licence
from licsales LS
where LS.salecount = (select max(salecount) from licsales);
-- SI998

--(f) According to the sellers table, how many people have made at least one sale alone?

select count(distinct S2.personID)
from (
	select L.saleID
	from sellers L
	group by L.saleID
	having count(*) = 1
) S1 join sellers S2 on S1.saleID = S2.saleID;
-- 544

select count(distinct personID)
from (
	select L.saleID, max(L.personID) as personID
	from sellers L
	group by L.saleID
	having count(*) = 1
) X;
-- 544
--(g) There are 23 people who have bought cars of all models made by the maker LAMBORGHINI. How many people have bought cars of all models made by VOLVO?
--Note: This is a division query; points will only be awarded if division is attempted.
select count(*)
from (
	select S.personID
	from sales S
		join cars C on S.carID = C.ID
		join models M on C.modelID = M.ID
		join makers K on M.makerID = K.ID
	where K.name = 'LAMBORGHINI'
	group by S.personID
	having count(distinct C.modelID) = (
		select count(*)
		from models M
			join makers K on M.makerID = K.ID
		where K.name = 'LAMBORGHINI'
	)
) X;
-- 23

select count(*)
from (
	select S.personID
	from sales S
		join cars C on S.carID = C.ID
		join models M on C.modelID = M.ID
		join makers K on M.makerID = K.ID
	where K.name = 'VOLVO'
	group by S.personID
	having count(distinct C.modelID) = (
		select count(*)
		from models M
			join makers K on M.makerID = K.ID
		where K.name = 'VOLVO'
	)
) X;
-- 5

--(h) The database is randomly generated, and contains very little quality control relating
--to the different -year attributes in the various tables. One problem that may arise,
--for example, is that some cars are produced before the model production started
--(Cars.prodyear < Models.firstyear ), but there are multiple other problems that might
--arise. How many different cars have some problem with one of the -year attributes?

select count(*)
from (
	select C.ID
	from cars C 
		join models M on C.modelID = M.ID
	where M.firstyear > C.prodyear 
		or M.lastyear < C.prodyear
	union
	select C.ID
	from cars C
		join sales S on S.carID = C.ID
	where S.saleyear < C.prodyear
	union 
	select C.ID
	from cars C
		join sales S on S.carID = C.ID
		join people P on S.personID = P.ID
	where S.saleyear < P.birthyear
	union
	select C.ID
	from cars C
		join sales S on S.carID = C.ID
		join sellers L on L.saleID = S.ID
		join people P on L.personID = P.ID
	where S.saleyear < P.birthyear
) X;
-- 5364