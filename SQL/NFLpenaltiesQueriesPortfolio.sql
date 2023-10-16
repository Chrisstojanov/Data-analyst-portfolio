--Create TABLE

Create table NFLdata2022 (
	gameid int,
	gamedate date,
	quarter int,
	minute int,
	second int,
	OffenseTeam text,
	DefenseTeam text,
	Down int,
	ToGo int,
	Yardline int,
	emptycolumn text,
	seriesfirstdown int,
	emptycolumn2 text,
	nextscore int,
	description text,
	teamwin int,
	emptycolumn3 text,
	emptycolumn4 text,
	SeasonYear int,
	Yards int,
	formation text,
	playtype text,
	IsRush int,
	IsPass int,
	IsIncomplete int,
	IsTouchdown int,
	Passtype text,
	IsSack int,
	IsChallenge int, 
	IsChallengeReversed int,	
	Challenger text,
	IsMeasurement int,
	IsInterception int,
	IsFumble int,
	IsPenalty int,
	IsTwoPointConversion int,
	IsTwoPointConversionSuccessful int,
	RushDirection text,
	YardLineFixed int,
	YardLineDirection text,
	IsPenaltyAccepted int,
	PenaltyTeam text,
	IsNoPlay int,
	PenaltyType  text,
	PenaltyYards int
);

--Import CSV

copy NFLdata2022
from 'C:\Users\chris\Desktop\Dataportfolio\NFLdatadownloads\NFLdata2022.csv'
with (format csv, header);

--Combine all tables 

CREATE TABLE TotalData AS
SELECT * FROM nfldata2014
UNION ALL
SELECT * FROM nfldata2015
UNION ALL
SELECT * FROM nfldata2016
UNION ALL
SELECT * FROM nfldata2017
UNION ALL
SELECT * FROM nfldata2018
UNION ALL
SELECT * FROM nfldata2019
UNION ALL
SELECT * FROM nfldata2020
UNION ALL
SELECT * FROM nfldata2021
UNION ALL
SELECT * FROM nfldata2022;

--Total Penalties Accepted Each Year

select Seasonyear, count(ispenaltyaccepted) as Penalties from totaldata 
where ispenaltyaccepted = 1
group by seasonyear, ispenaltyaccepted

--Total Penalty Yards Each Year
select Seasonyear, ispenaltyaccepted, sum(penaltyyards) as TotalPenaltyYards from totaldata 
where ispenaltyaccepted = 1
group by seasonyear, ispenaltyaccepted

--Total Penalties Called Vs Team
select penaltyteam, count(ispenaltyaccepted) from totaldata
where ispenaltyaccepted = 1
group by penaltyteam, ispenaltyaccepted
order by count desc

--Top 5 penalties by total yards in each year
WITH PenaltyRank AS (
  SELECT
    seasonyear,
    penaltytype,
    SUM(penaltyyards) AS total_yards,
    ROW_NUMBER() OVER (PARTITION BY seasonyear ORDER BY SUM(penaltyyards) DESC) AS rn
  FROM totaldata
  GROUP BY seasonyear, penaltytype
)
SELECT
  seasonyear,
  penaltytype,
  total_yards
FROM PenaltyRank
WHERE rn <= 5
ORDER BY seasonyear, total_yards DESC;

--Top 5 occuring penalties in each year

WITH PenaltyRank AS (
  SELECT
    seasonyear, penaltytype,
    count(penaltytype) as Penalty,
    ROW_NUMBER() OVER (PARTITION BY seasonyear ORDER BY count(penaltytype) DESC) AS rn
  FROM totaldata
  GROUP BY seasonyear, penaltytype
)
SELECT
  seasonyear, penaltytype, Penalty
FROM PenaltyRank
WHERE rn <= 5
ORDER BY seasonyear DESC;


--Penalties Against Each team each year
SELECT
    seasonyear,
    penaltyteam,
    COUNT(*) AS total_accepted_penalties
FROM totaldata
WHERE ispenaltyaccepted = 1
GROUP BY seasonyear, penaltyteam
ORDER BY seasonyear, total_accepted_penalties DESC;

--Penalties on each teams Defense 
SELECT
    seasonyear,
    penaltyteam,
    COUNT(*) AS total_accepted_penalties
FROM totaldata
WHERE ispenaltyaccepted = 1
  AND defenseteam = penaltyteam
GROUP BY seasonyear, penaltyteam
ORDER BY seasonyear, total_accepted_penalties DESC;

--Penalties on each teams Defense on third down
SELECT
    seasonyear,
    penaltyteam,
    COUNT(*) AS total_accepted_penalties
FROM totaldata
WHERE ispenaltyaccepted = 1
  AND defenseteam = penaltyteam
  and down = 3
GROUP BY seasonyear, penaltyteam
ORDER BY seasonyear, total_accepted_penalties DESC;

--Which Quarter has the most penalties?
select quarter, 
count(ispenaltyaccepted) 
from totaldata
where ispenaltyaccepted = 1
group by quarter 

--Which teams have the most penalties in the 4th Quarter?
select 
	penaltyteam, 
	count(penaltyteam)
from totaldata
where quarter = 4
	and ispenaltyaccepted = 1
group by penaltyteam
order by count desc