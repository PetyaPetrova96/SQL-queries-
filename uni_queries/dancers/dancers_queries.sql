--Q3 →How many records in DancerAward have an award that does not exist?
--6
select * from award aw
right join danceraward  da on aw.id = da.awardid
where aw.id is null
--or

select * from danceraward  da 
left join award aw on da.awardid=aw.id 
where aw.id  is null

--Q5-> How many dancers have an email address with hotmail.com?
--75
select count(*) from dancer
where email like '%@hotmail.com'

--Q7--> How many distinct dancers have a rank and an award in some contest organized by “DR’?
--11
select count(distinct Rank.dancerid)
from rank
join danceraward DA on Rank.dancerId = DA.dancerid
join Award A on DA.awardID = A.id
where rank.contestId = A.contestId
and Rank.contestId in (select id from contest where organizer like 'DR')

--Q9--How many pairs of contests have the same name?
--5
select count(*)
from(
select * from contest c1
inner join contest  c2 on c1.id > c2.id
where c1.name = c2.name) as z

--Q11 How many distinct dancers have an award, but not a rank, in a contest?
--486
select count(distinct dancerID)
from dancerAward DA
join Award A on DA.awardID = A.id
where not exists(
select * from rank r 
where da.dancerid = r.dancerid
and a.contestid = r.contestid)

--Q13 How many records have a rank lower than the average rank of all records in the relation?
--969
select count(level)
from rank
where rank<(select avg(rank) from rank)

--Q15 How many dancers have participated in all contests editions named “Dance Forever”?

select count(*)
from(
select dancerid from rank
where contestid in 
	(select id from contest where name like 'Dance Forever')
	group by dancerID
	having count(contestID)= (select count(*) from contest where name = 'Dance Forever'))x

--Q17 How many contest names are used by two different organizers?
--5
select count(*)
from (
	select count(distinct organizer)
	from contest 
	group by name
	having count(distinct organizer) = 2
) X

