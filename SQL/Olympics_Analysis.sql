
#1.HOW MANY OLYMPICS GAMES HAVE BEEN HELD?

select count (distinct games) as total_olympic_games from olympics_history
 
 
#2.LIST ALL OLYMPICS GAMES HELD SO FAR.

select distinct year, season, city from olympics_history
order by year

#3.MENTION THE TOTAL # OF NATIONS WHO PARTICIPATED IN EACH OLYMPICS GAME?

select games, count (distinct noc) as total_countries from olympics_history
group by games

#4.WHICH YEAR SAW THE HIGHEST AND LOWEST NO OF COUNTRIES PARTICIPATING IN OLYMPICS?

select games, count (distinct noc) from olympics_history
group by games
order by count desc limit 5

select games, count (distinct noc) from olympics_history
group by games
order by count asc limit 5

#5.WHICH NATION HAS PARTICIPATED IN ALL OF THE OLYMPIC GAMES?

with t1 as
(select count (distinct games) as total_olympic_games from olympics_history),
t2 as 
(select distinct noc, games from olympics_history
	order by games),
t3 as 
(select noc, count(games) as no_of_games_played from t2
	group by noc)
select * from t3
order by no_of_games_played desc

--This query is using subqueries (also known as derived tables or common table expressions) to extract information from the olympics_history table. The subqueries are then combined to produce the final result.

	--The first subquery t1 calculates the total number of unique games in the olympics_history table by using the COUNT function with the DISTINCT keyword on the games column.

		--The second subquery t2 selects the distinct noc (National Olympic Committee) and games columns from olympics_history and orders the result by games.

			--The third subquery t3 calculates the number of games played by each noc by using the COUNT function on the games column and grouping the result by noc.

				--	Finally, the main query selects all columns from t3. This means that the final result will show the noc and the number of games played by each noc.



#6.IDENTIFY THE SPORT WHICH WAS PLAYED IN ALL SUMMER OLYMPICS.

with t1 as 
	(select count( distinct games) as total_summer_games from olympics_history
	where season = 'Summer'),
t2 as 
	(select distinct sport, games from olympics_history
	where season = 'Summer' order by games),	
t3 as 
	(select sport, count(games) as no_of_games from t2
	group by sport)
select * from t3
join t1 on t1.total_summer_games = t3.no_of_games;

#7.WHICH SPORTS WERE PLAYED ONLY ONCE IN THE OLYMPICS?

with t1 as
          	(select distinct games, sport
          	from olympics_history),
          t2 as
          	(select sport, count(1) as no_of_games
          	from t1
          	group by sport)
      select t2.*, t1.games from t2
      join t1 on t1.sport = t2.sport
      where t2.no_of_games = 1
      order by t1.sport
	  
	  
--The first subquery t1 uses the SELECT DISTINCT statement to get the unique pairs of games and sport from the table olympics_history. 
--The DISTINCT keyword is used to ensure that duplicates are removed and only unique pairs are returned.

	--The second subquery t2 then uses the results from t1 to count the number of games for each sport using the GROUP BY clause and the COUNT aggregate function. 
	--The GROUP BY clause is used to group the results by sport, and the COUNT function returns the number of rows in each group. This gives us the number of games for each sport.

		--The final step is to join the two subqueries t1 and t2 on the sport column. 
		--This allows us to combine the information from both subqueries into a single result set. The JOIN clause is used to specify the join between the two subqueries.

		--The final result is then filtered to only show those sports that have only one game associated with them, using the WHERE clause to specify this condition.
		--The results are finally ordered by the sport column using the ORDER BY clause.
	  
#8.FETCH THE TOTAL NO OF SPORTS PLAYED IN EACH OLYMPIC GAMES.

select games, count(distinct sport) as no_of_sports from olympics_history
group by games
order by no_of_sports desc

#9.FETCH DETAILS OF THE OLDEST ATHLETES TO WIN A GOLD MEDAL.

SELECT name, sex, age, team, games, city, sport, event, medal =
FROM olympics_history
WHERE medal = 'Gold' and age != 'NA'
ORDER BY age DESC
limit 5



#10.FETCH THE TOP 5 ATHLETES WHO HAVE WON THE MOST GOLD MEDALS.

select name, noc, count(medal) as total_gold_medals from olympics_history
where medal = 'Gold'
group by name, noc
order by total_gold_medals desc
limit 5

#11.FETCH THE TOP 5 ATHLETES WHO HAVE WON THE MOST MEDALS (GOLD/SILVER/BRONZE).

select name, team, count(medal) as total_medals from olympics_history
where medal in('Gold','Silver', 'Bronze')
group by name, team
order by total_medals desc
limit 5



#12.FETCH THE TOP 5 MOST SUCCESSFUL COUNTRIES IN OLYMPICS. SUCCESS IS DEFINED BY NO OF MEDALS WON.

-- This query retrieves the top five regions with the highest number of medals won in the Olympics based on data in the tables "olympics_history" and "noc_regions".

with t1 as
	(select region, count(1) as total_medals from olympics_history 
	join noc_regions
	on olympics_history.noc = noc_regions.noc 
	where medal in ('Gold', 'Silver', 'Bronze')
	group by region
	order by total_medals desc),
	
-- Create temporary table "t1" by joining "olympics_history" and "noc_regions" on "noc", counting medals, grouping by region, and ordering by medal count.
	
t2 as 
	(select *, dense_rank() over(order by total_medals desc) as rnk
	from t1)
	
-- Create temporary table "t2" by selecting all columns from "t1" and adding a rank based on medal count using the "dense_rank()" function.
	
select * from t2
where rnk <= 5;
	
-- Select the top five regions based on their assigned rank in "t2". The results show the region name, medal count, and rank.

It first creates a temporary table "t1" by joining the two tables on the "noc" column, filtering for only gold, silver, and bronze medals, grouping the results by region, and counting the total number of medals for each region. 
It then orders the results in descending order by the total number of medals.

The query then creates another temporary table "t2" by selecting all columns from "t1" and adding a new column "rnk" which uses the "dense_rank()" function to assign a rank to each region based on the total number of medals they have won. 
The "dense_rank()" function assigns the same rank to regions with the same total number of medals, and leaves gaps in the ranks for regions with no medals.

Finally, the query selects all columns from "t2" and filters the results to show only the top five regions with the highest number of medals, based on their assigned rank in the "rnk" column. 
The results of the query show the region name, total number of medals won, and the assigned rank for each of the top five regions.



#13 WHAT ARE THE TOP FIVE REGIONS FOR MOST MEDALS WON?

-- This query retrieves the top five regions with the highest number of medals won in the Olympics based on data in the tables "olympics_history" and "noc_regions".

with t1 as
(
    -- Create temporary table "t1" by joining "olympics_history" and "noc_regions" on "noc", counting medals, grouping by region, and ordering by medal count.
    select region, count(1) as total_medals
    from olympics_history 
    join noc_regions
    on olympics_history.noc = noc_regions.noc 
    where medal in ('Gold', 'Silver', 'Bronze')
    group by region
    order by total_medals desc
),

t2 as 
(
    -- Create temporary table "t2" by selecting all columns from "t1" and adding a rank based on medal count using the "dense_rank()" function.
    select *, dense_rank() over(order by total_medals desc) as rnk
    from t1
)

-- Select the top five regions based on their assigned rank in "t2". The results show the region name, medal count, and rank.
select *
from t2
where rnk <= 5;


	This query finds the top 5 regions based on the number of medals won in the Olympics.

Create a subquery named "t1" that counts the number of medals won by each region and groups them by region. It also filters out any rows where the medal type is not 'Gold', 'Silver', or 'Bronze'.

Create a subquery named "t2" that assigns a dense rank to each region based on the total number of medals won. The dense rank is calculated using the "dense_rank()" window function and is ordered in descending order based on the total_medals column.

Finally, the main query selects all rows from t2 where the rank (rnk) is less than or equal to 5. This returns the top 5 regions based on the number of medals won.


