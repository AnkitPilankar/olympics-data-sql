select * from athlete_events;
select * from noc_regions;

-- 1 How many olympics games have been held?
select count(distinct games) as total_games from athlete_events; 

/*2. List down all Olympics games held so far.*/
select distinct games,City from athlete_events;

/*3. Mention the total no of nations who participated in each olympics game?*/
select count(team),games from athlete_events
group by games;

/*4. Which year saw the highest and lowest no of countries participating in olympics*/
select games
 from   (select o.games,count(distinct(o.noc)) as total_countries
	from athlete_events o, noc_regions r
	where o.noc=r.noc
	group by games
	order by games) as x;

-- 5 Which nation has participated in all of the olympic games?
select r.region as country, count(distinct(games)) as Total_games
from athlete_events o, noc_regions r
where o.noc=r.noc
group by region
order by 2 desc;

-- 6 Identify the sport which was played in all summer olympics.
select sport, count(distinct(games)) as Total_games
from athlete_events
where season= "summer"
group by sport
having Total_games =29
order by 2 desc ;

-- 7 Which Sports were just played only once in the olympics?
select sport,count(distinct games) from athlete_events
group by sport
having count(distinct games) = 1;

-- 8 Fetch the total no of sports played in each olympic games.
select sport,count(distinct sport) as total_sport,games from athlete_events
group by games
order by total_sport desc;

-- 9 Fetch details of the oldest athletes to win a gold medal.
select * from athlete_events;

select name ,max(age) age,region,count(medal) from athlete_events a
join noc_regions b on a.noc=b.noc
where medal = 'gold'
group by name 
order by age desc
limit 1 ;
 
-- 10 Find the Ratio of male and female athletes participated in all olympic games.
select 
count(case 
when sex = 'm' then 1 end ) as male_total,
count(case 
when sex = 'f' then 1 end ) as female_total,
count(case when sex = 'm' then 1 end )/count(case when sex = 'f' then 1 end ) as ratio
from athlete_events;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

-- 11 Fetch the top 5 athletes who have won the most gold medals.
select Name,
count(
case 
when medal = 'Gold' then 1 end )as total_gold,
dense_rank() over(order by count(case when medal = 'Gold' then 1 end)desc)
from athlete_events 
group by Name
order by total_gold desc
limit 5;

select * from athlete_events;

-- 12 Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).

select name , count(medal) as total_medal,
dense_rank() over (order by count(medal) desc) as rnk from athlete_events
group by name
order by count(medal) desc
limit 5;

-- 13 Fetch the top 5 most successful countries in olympics.
-- Success is defined by no of medals won.

select region,count(medal) as total_medal,
dense_rank() over (order by count(medal) desc) as rnk from athlete_events a 
join noc_regions b on a.NOC = b.Noc 
group by region
order by count(medal) desc
limit 5;

 --  14 List down total gold, silver and bronze medals won by each country.
 
 select region,
 count(case when medal = 'gold' then 1 end) as gold_medal,
 count(case when medal = 'silver' then 1 end) as silver_medal,
 count(case when medal = 'bronze' then 1 end) as bronze_medal
 from noc_regions a 
 join athlete_events b on a.noc = b.noc
 group by region
 order by gold_medal desc;
 
--  15 List down total gold, silver and bronze medals won by each 
-- country corresponding to each olympic games.

 select region,games,
 count(case when medal = 'gold' then 1 end) as gold_medal,
 count(case when medal = 'silver' then 1 end) as silver_medal,
 count(case when medal = 'bronze' then 1 end) as bronze_medal
 from noc_regions a 
 join athlete_events b on a.noc = b.noc
 group by region,games
 order by games desc;
  
--  16 & 17 is relevant same 
 
 -- 18  Which countries have never won gold medal but have won silver/bronze medals?
 
 select region from noc_regions a 
 join athlete_events b on a.noc = b.noc
where medal = 'gold' is null
 group by region;
 
 SELECT region
FROM noc_regions a
LEFT JOIN athlete_events b ON a.noc = b.noc AND b.medal = 'Gold'
WHERE b.medal IS NULL
GROUP BY region;
 
 
select region from noc_regions a
join athlete_events b on a.noc = b.noc
where (select medal from athlete_events where medal in ('bronze','silver'))
and region not in (select region FROM athlete_events WHERE medal = 'Gold')
group by region;

select region as country,
	count(case when medal= "gold" then null end )as Gold_medal,
    count(case when medal= "silver" then "silver" end )as silver_medal,
    count(case when medal= "bronze" then "bronze" end )as bronze_medal
from athlete_events as o, noc_regions as r 
where o.noc= r.noc
group by region
order by region;

 -- 19 In which Sport/event, India has won highest medals.

select region , sport,count(medal) from athlete_events a
join noc_regions b on a.noc = b.noc
where region = 'india' 
group by sport
order by count(medal) desc;

-- 20. Break down all olympic games where India won medal for Hockey and how many medals in each olympic games

select region,sport,games,count(medal) as total_medal from athlete_events a
join noc_regions b on a.noc = b.noc
where region = 'india' and sport = 'hockey'
group by games
order by total_medal desc

