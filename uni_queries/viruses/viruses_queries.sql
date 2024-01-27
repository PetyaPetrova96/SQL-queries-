-- 1.(a) There are 2,586 tests that have detected the ‘delta’ variant. How many tests have
--detected the ‘omicron’ variant?
-- 25919
select count(*) from variants v
inner join tests te on te.variantid = v.id
where name ='omicron'

--1.(b) There are 6 variants with an unknown risk level. 
--How many variants have never been
--detected with a test?
-- 1		 
SELECT COUNT(*)  as variants_not_detected 
FROM (
	select * from tests te
	full outer join variants v on v.id=te.variantid
	where te.variantid is NULL
) AS sqt;

--1.(c) How many different variants of the ‘extreme’ risk level have been detected in 2021
--by a tester called ‘Kent Lauridsen’ using a kit produced by ‘JJ’?
--1

SELECT COUNT(distinct sqt2)  AS extr_2021_KL_JJ
	FROM (
	select * from variants v
	inner join risks r on  v.riskid = r.id
	inner join tests te on te.variantid = v.id
	inner join testers tes on tes.id = te.testerid
	inner join kits ki on ki.id =te.kitid
	where level = 'extreme' AND extract(year from te.time) = 2021 and tes.name = 'Kent Lauridsen' 
		and ki.producer = 'JJ'
) AS sqt2

--1.(d) There are 7 variants that can be detected by some kit with at least 80% accuracy.
--How many variants cannot be detected by any kit with more than 50% accuracy?
--2
select count(*)
from Variants V
where V.ID not in (
	select distinct D.variantID
	from Detects D
	where D.accuracy >= 50
);

--1.(e) The best average accuracy for any kit is about 59.89%. What is the lowest average
--accuracy for any variant which is detected by more than one kit?
--17.500
select min(score)
from(
	select avg(d.accuracy) as score from detects d
	group by d.variantid
	having count(*)>1
)x;

--1.(f) The tester with ID = 68 has performed 287 tests. What is the ID of the tester that
--has performed the most tests with the kit produced by ‘JJ’?
--111
SELECT te.id, COUNT(ki.id) AS tests_jj
FROM testers te
INNER JOIN tests ts ON ts.testerid = te.id
INNER JOIN kits ki ON ki.id = ts.kitid
WHERE ki.producer = 'JJ'
GROUP BY te.id
ORDER BY tests_jj DESC
LIMIT 1;


--1.(g) There are 3 testers that have detected all variants with a known risk level. How
--many testers have detected all variants with risk level ‘mild’?
--??
select te.testerid,v.id from risks r 
inner join variants v on v.riskid = r.id
inner join tests te on te.variantid = v.id
where r.level = 'mild'
group by v.id,te.testerid



--I dont get it
select count(*)
from (
	select T.testerID, count(distinct T.variantID)
	from Tests T
		join Variants V on T.variantID = V.ID
		join Risks R on V.riskID = R.ID
	where R.level = 'mild'
	group by T.testerID
	having count(distinct T.variantID) = (
		select count(*)
		from Variants V
			join Risks R on V.riskID = R.ID
		where R.level = 'mild'
	)
) X;

--1.(h) Write a query that returns the timestamp for the last time a detection was made
--of a variant with risk level ‘extreme’ using a kit that has < 10% accuracy for that
--variant.
-- "2022-12-28 15:29:00"
select max(te.time) 
from tests te 
	inner join kits ki on ki.id = te.kitid
	inner join detects de on de.kitid = ki.id
	inner join variants v on v.id = te.variantid
	inner join risks ri on ri.id = v.riskid
	where ri.level = 'extreme' and de.accuracy <10;