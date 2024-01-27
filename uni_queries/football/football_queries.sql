--(a) The database has one club from the city named Copenhagen. How many clubs are
--from the city named London?

--1
select count(*) from cities ci
inner join clubs  cl on cl.cityid = ci.id
where ci.name = 'Copenhagen'

--6
select count(*) from cities ci
inner join clubs  cl on cl.cityid = ci.id
where ci.name = 'London'

--(b) In the signedwith table, there are three different clubID values that no longer exist
--in the clubs table. How many players signed with those clubs?
--7
select count(*)
from(
	select  distinct clubid,s.playerid from signedwith s
	left join clubs cl on s.clubid = cl.id
	where cl.id is null) as x;

--(c) The club named Liverpool has a total of 243 away wins, while the highest number
--of away wins by any club happens to be 260. How many different clubs jointly have
--the most away wins?
--243
select count(*) from (
	select * from clubs cl 
	inner join  matches ma on  cl.id = ma.awayid
	where name = 'Liverpool' and awaywin is true
) as x ;

--
create view counting as 
select cl.id,count(awaywin) from clubs cl 
inner join  matches ma on  cl.id = ma.awayid
where  awaywin is true
group by cl.id
order by count(awaywin) DESC

--2
select count(*) from counting 
where count = (select max(count) from counting)
		
--(d) During the playing career of Andrea Pirlo, he was involved with 319 home goals. As
--outlined above, this means that while he was signed with different clubs, they scored
--a total of 319 home goals. How many away goals was Steven Gerrard involved with?


--62
select sum(M.awaygoals)
from players P
	join signedwith W on W.playerID = P.ID
	join matches M on W.clubID = M.awayID and W.seasonID = M.seasonID
where P.name = 'Steven Gerrard';



--(e) During his illustrious playing career, Bjorn signed with 7 different clubs. Write a
--query to output the name(s) of the player(s) who signed with the largest number of
--different clubs.
--Note: The output of this query is a set of one or more player names.
--7
select count(distinct clubid) from players pl
inner join signedwith si on si.playerid = pl.id
where pl.name like '%Bjorn%'
group by pl.id

drop view if exists counting2
create view counting2 as
select  pl.name,pl.id, count(distinct clubid) as nmb from players pl
inner join signedwith si on si.playerid = pl.id
group by pl.id
order by  count(distinct clubid) desc

--Ruud van Nisterlrooy
select name from counting2
where nmb = (SELECT MAX(nmb) FROM counting2);



--(f) How many players never signed with a club from the city named London?
-- 22

select count(*)
from (
	select P.ID
	from players P
	except
	select distinct W.playerID
	from signedwith W 
		join clubs C on W.clubID = C.ID
		join cities T on C.cityID = T.ID
	where T.name = 'London'
) X;



--(g) London clubs are defined here as clubs from the city named London. All 14 nonLondon clubs have beaten all London clubs away (meaning that the London club
--was the home team) during some season registered in the database. How many
--non-London clubs have beaten all London clubs away in a single season?
--Note: This is a division query; points will only be awarded if division is attempted.

--14
select count(*)
from (
	select M.awayID, count(distinct M.homeID)
	from matches M
		join clubs C on M.homeID = C.ID
		join cities T on C.cityID = T.ID
	where T.name = 'London'
		and M.awaywin
	group by M.awayID
	having count(distinct M.homeID) = (
		select count(*)
		from clubs C join cities T on C.cityID = T.ID
		where T.name = 'London'
	)
) X;

--2
select count(*)
from (
	select M.awayID, M.seasonID, count(distinct M.homeID)
	from matches M
		join clubs C on M.homeID = C.ID
		join cities T on C.cityID = T.ID
	where T.name = 'London'
		and M.awaywin
	group by M.awayID, M.seasonID
	having count(distinct M.homeID) = (
		select count(*)
		from clubs C join cities T on C.cityID = T.ID
		where T.name = 'London'
	)
) X;








