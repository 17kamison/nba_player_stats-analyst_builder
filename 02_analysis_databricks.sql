-- Databricks notebook source
SELECT 
  * 
FROM 
  workspace.nba_proj.nba_season_stats
Limit 5

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Player Performance Analysis

-- COMMAND ----------

-- Select scoring title winners (highest pts per season) with key stats
SELECT
  player_name,
  age,
  team_abbreviation AS team,
  pts,
  usg_pct,
  ts_pct,
  season,
  experience
FROM
  (
    -- Rank players by points per season
    SELECT
      *,
      RANK() OVER (PARTITION BY season ORDER BY pts DESC) AS rnk
    FROM
      workspace.nba_proj.nba_season_stats
  ) AS n
WHERE
  n.rnk = 1 -- Filter for top scorer each season
ORDER BY
  season DESC; -- Most recent seasons first

-- COMMAND ----------

-- Summary stats for scoring title winners (highest pts per season)
-- Counts unique players, averages age, experience, points, usage rate, and true shooting percentage
SELECT
  COUNT(DISTINCT player_name) AS unique_players,
  ROUND(AVG(age), 1) AS avg_age,
  ROUND(AVG(experience), 1) AS avg_experience,
  ROUND(AVG(pts), 1) AS avg_pts,
  ROUND(AVG(usg_pct) * 100.0, 1) AS avg_usg_pct,
  ROUND(AVG(ts_pct) * 100.0, 1) AS avg_ts_pct
FROM
  (
    SELECT
      player_name,
      pts,
      experience,
      age,
      usg_pct,
      ts_pct,
      RANK() OVER (PARTITION BY season ORDER BY pts DESC) AS rnk
    FROM
      workspace.nba_proj.nba_season_stats
  ) AS n
WHERE
  n.rnk = 1
;

-- COMMAND ----------

-- Select assist title winners (highest ast per season) with key stats
SELECT 
  player_name, 
  age,
  team_abbreviation as team,
  ast, 
  ast_pct, 
  season, 
  experience
FROM 
  (SELECT 
    *, 
    rank() OVER (PARTITION BY season ORDER BY ast DESC) as rnk
    FROM workspace.nba_proj.nba_season_stats
  ) n
WHERE n.rnk = 1
ORDER BY season desc;

-- COMMAND ----------

-- Aggregate summary stats for assist title winners since 1996
SELECT
  COUNT(DISTINCT player_name) AS unique_players,
  ROUND(AVG(ast), 1) AS avg_asts,
  ROUND(AVG(experience), 1) AS avg_experience,
  ROUND(AVG(age), 1) AS avg_age,
  ROUND(AVG(ast_pct) * 100.0, 1) AS avg_asts_pct
FROM
  (
    SELECT
      player_name,
      ast,
      experience,
      age,
      ast_pct,
      RANK() OVER (PARTITION BY season ORDER BY ast DESC) AS rnk
    FROM
      workspace.nba_proj.nba_season_stats
  ) AS n
WHERE
  n.rnk = 1
;

-- COMMAND ----------

-- Select rebounding title winners (highest reb per season) with key stats
SELECT 
  player_name, 
  age,
  team_abbreviation AS team,
  reb, 
  oreb_pct, 
  dreb_pct,
  season, 
  experience
FROM 
  (
    SELECT 
      *, 
      RANK() OVER (PARTITION BY season ORDER BY reb DESC) AS rnk
    FROM workspace.nba_proj.nba_season_stats
  ) n
WHERE n.rnk = 1 
ORDER BY season DESC;

-- COMMAND ----------

-- Aggregate summary stats for rebounding title winners (highest reb per season)
-- Counts unique players, averages rebounds, offensive/defensive rebounding %, experience, and age
SELECT 
  COUNT(DISTINCT player_name) AS unique_players, 
  ROUND(AVG(reb), 1) AS avg_reb, 
  ROUND(AVG(oreb_pct) * 100.0, 1) AS avg_oreb_pct,
  ROUND(AVG(dreb_pct) * 100.0, 1) AS avg_dreb_pct,
  ROUND(AVG(experience), 1) AS avg_experience,
  ROUND(AVG(age), 1) AS avg_age 
FROM 
  (
    SELECT 
      player_name,
      reb, 
      oreb_pct, 
      dreb_pct, 
      experience,
      age, 
      RANK() OVER (PARTITION BY season ORDER BY reb DESC) AS rnk
    FROM workspace.nba_proj.nba_season_stats
  ) n
WHERE n.rnk = 1;

-- COMMAND ----------

-- Top 5 single-season scoring increases by player
-- Calculates difference in points from previous season for each player
SELECT 
  player_name, 
  season, 
  pts, 
  prev_season_pts,
  pts_diff
FROM (
  SELECT 
    player_name, 
    season, 
    pts, 
    lag(pts) OVER (PARTITION BY player_name ORDER BY season) AS prev_season_pts,
    lag(season) OVER (PARTITION BY player_name ORDER BY season) AS prev_season,
    ROUND(pts - lag(pts) OVER (PARTITION BY player_name ORDER BY season), 1) AS pts_diff
  FROM workspace.nba_proj.nba_season_stats
) n
WHERE prev_season_pts IS NOT NULL
AND season - prev_season = 1 --Filter for consecutive seasons
ORDER BY pts_diff DESC
LIMIT 5

-- COMMAND ----------

-- Top 5 single-season scoring decreases by player
-- Calculates difference in points from previous season for each player
SELECT 
  player_name, 
  season, 
  pts, 
  prev_season_pts,
  pts_diff
FROM (
  SELECT 
    player_name, 
    season, 
    pts, 
    lag(pts) OVER (PARTITION BY player_name ORDER BY season) AS prev_season_pts,
    lag(season) OVER (PARTITION BY player_name ORDER BY season) AS prev_season,
    ROUND(pts - lag(pts) OVER (PARTITION BY player_name ORDER BY season), 1) AS pts_diff
  FROM workspace.nba_proj.nba_season_stats
) n
WHERE prev_season_pts IS NOT NULL
AND season - prev_season = 1 --Filter for consecutive seasons
ORDER BY pts_diff 
LIMIT 5

-- COMMAND ----------

-- Top 5 single-season assist increases by player
-- Calculates difference in assists from previous season for each player
SELECT 
  player_name, 
  season, 
  ast, 
  prev_season_ast,
  ast_diff
FROM (
  SELECT 
    player_name, 
    season, 
    ast, 
    lag(ast) OVER (PARTITION BY player_name ORDER BY season) AS prev_season_ast,
    lag(season) OVER (PARTITION BY player_name ORDER BY season) AS prev_season,
    ROUND(ast - lag(ast) OVER (PARTITION BY player_name ORDER BY season), 1) AS ast_diff 
  FROM workspace.nba_proj.nba_season_stats
) n
WHERE prev_season_ast IS NOT NULL 
AND season - prev_season = 1  --Filter for consecutive seasons
ORDER BY ast_diff DESC            
LIMIT 5

-- COMMAND ----------

-- Top 5 single-season assist decreases by player
-- Calculates difference in assists from previous season for each player
SELECT 
  player_name, 
  season, 
  ast, 
  prev_season_ast,
  ast_diff
FROM (
  SELECT 
    player_name, 
    season, 
    ast, 
    lag(ast) OVER (PARTITION BY player_name ORDER BY season) AS prev_season_ast,
    lag(season) OVER (PARTITION BY player_name ORDER BY season) AS prev_season,
    ROUND(ast - lag(ast) OVER (PARTITION BY player_name ORDER BY season), 1) AS ast_diff
  FROM workspace.nba_proj.nba_season_stats
) n

WHERE prev_season_ast IS NOT NULL
AND season - prev_season = 1 --Filter for consecutive seasons
ORDER BY ast_diff
LIMIT 5

-- COMMAND ----------

-- Top 5 single-season rebounding increases by player
-- Calculates difference in rebounds from previous season for each player
SELECT 
  player_name, 
  season, 
  reb, 
  prev_season_reb,
  reb_diff
FROM (
  SELECT 
    player_name, 
    season, 
    reb, 
    lag(reb) OVER (PARTITION BY player_name ORDER BY season) AS prev_season_reb, 
    lag(season) OVER (PARTITION BY player_name ORDER BY season) AS prev_season,   
    ROUND(reb - lag(reb) OVER (PARTITION BY player_name ORDER BY season), 1) AS reb_diff 
  FROM workspace.nba_proj.nba_season_stats
) n
WHERE prev_season_reb IS NOT NULL 
AND season - prev_season = 1      -- Ensure seasons are consecutive
ORDER BY reb_diff DESC            
LIMIT 5

-- COMMAND ----------

-- Top 5 single-season rebounding decreases by player
-- Calculates difference in rebounds from previous season for each player
SELECT 
  player_name, 
  season, 
  reb, 
  prev_season_reb,
  reb_diff
FROM (
  SELECT 
    player_name, 
    season, 
    reb, 
    lag(reb) OVER (PARTITION BY player_name ORDER BY season) AS prev_season_reb,
    lag(season) OVER (PARTITION BY player_name ORDER BY season) AS prev_season,
    ROUND(reb - lag(reb) OVER (PARTITION BY player_name ORDER BY season), 1) AS reb_diff
  FROM workspace.nba_proj.nba_season_stats
) n
WHERE prev_season_reb IS NOT NULL
AND season - prev_season = 1 --Filter for consecutive seasons
ORDER BY reb_diff 
LIMIT 5

-- COMMAND ----------

-- Find the player with the highest usage percentage (usg_pct) for each season
-- Returns player name, age, team, usage percentage, true shooting percentage, season, and experience
Select 
  player_name, 
  age,
  team_abbreviation as team,
  usg_pct, 
  ts_pct, 
  season, 
  experience
From 
  (Select 
    *, 
    rank() Over (partition by season order by usg_pct desc) as rnk
    from workspace.nba_proj.nba_season_stats
  ) n
where n.rnk = 1
order by usg_pct desc;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Era & Team Comparisons

-- COMMAND ----------

-- Compare average player size and performance by decade (1990s, 2000s, 2010s, 2020s)

-- Calculates player count, average height, and average weight per decade
with size as (
  select 
    count(*) as player_count, 
    round(avg(player_height), 1) as height, 
    round(avg(player_weight), 1) as weight, 
    floor(season / 10) * 10 as decade 
  from workspace.nba_proj.nba_season_stats
  group by floor(season / 10) * 10
), 
-- Calculates average points, rebounds, and assists per decade
performance as (
  select 
    round(avg(pts), 1) as pts, 
    round(avg(reb), 1) as reb, 
    round(avg(ast), 1) as ast,
    floor(season / 10) * 10 as decade 
  from workspace.nba_proj.nba_season_stats
  group by floor(season / 10) * 10
)
--Join size and performance metrics by decade for comparison
select 
  player_count, 
  height, 
  weight, 
  pts, 
  reb, 
  ast, 
  decade
from size
join performance using(decade)
order by decade

-- COMMAND ----------

-- Identify teams that consistently produce top 5 players in points, assists, and rebounds per season.
-- For each team, count the number of player-seasons with top 5 ranks in pts, ast, and reb.
-- Sum these counts to get a total indicator of top player production by team.
Select 
  team, 
  count(*) FILTER(where rnk_pts <= 5) as top_pts, 
  count(*) FILTER(where rnk_ast <= 5) as top_ast, 
  count(*) FILTER(where rnk_reb <= 5) as top_reb, 
  (count(*) FILTER(where rnk_pts <= 5) + 
   count(*) FILTER(where rnk_ast <= 5) + 
   count(*) FILTER(where rnk_reb <= 5)) as total 

From (
  Select 
    team_abbreviation as team, 
    pts, 
    ast, 
    reb,
    rank() Over (partition by season order by pts desc) as rnk_pts, 
    rank() Over (partition by season order by ast desc) as rnk_ast, 
    rank() Over (partition by season order by reb desc) as rnk_reb  
  from workspace.nba_proj.nba_season_stats
) 
group by team
order by total desc

-- COMMAND ----------

-- Counts player-seasons with top 5 ranks in points, assists, and rebounds for the top 3 teams (LAL, PHX, MIN)
-- Returns player name, team, and counts of top 5 appearances in each stat category
Select
  count(rnk_pts) filter(where rnk_pts <=5) as top_5_pts, 
  count(rnk_ast) filter(where rnk_ast <=5) as top_5_ast, 
  count(rnk_reb) filter(where rnk_reb <=5) as top_5_reb,
  player_name, 
  team
From 
  (Select 
    player_name,
    team_abbreviation as team, 
    pts, 
    ast, 
    reb,
    season, 
    rank() Over (partition by season order by pts desc) as rnk_pts, 
    rank() Over (partition by season order by ast desc) as rnk_ast, 
    rank() Over (partition by season order by reb desc) as rnk_reb
  from workspace.nba_proj.nba_season_stats
  ) 
where (rnk_pts <= 5 or rnk_ast <= 5 or rnk_reb <= 5)
  and team in ('LAL', 'PHX', 'MIN')
group by player_name, team 
order by team

-- COMMAND ----------

-- Compare average performance metrics for rookies (experience = 0) and veterans (experience >= 3)
SELECT
  type,              
  avg_pts,            
  avg_ast,             
  avg_reb,             
  avg_net_rating,      
  avg_usg_pct,         
  avg_ts_pct           
FROM (
  SELECT
    'Rookies' AS type,
    ROUND(AVG(pts), 1) AS avg_pts,
    ROUND(AVG(ast), 1) AS avg_ast,
    ROUND(AVG(reb), 1) AS avg_reb,
    ROUND(AVG(net_rating), 1) AS avg_net_rating,
    ROUND(AVG(usg_pct), 3) AS avg_usg_pct,
    ROUND(AVG(ts_pct), 3) AS avg_ts_pct
  FROM workspace.nba_proj.nba_season_stats
  WHERE experience = 0

  UNION ALL

  SELECT
    'Veterans' AS type,
    ROUND(AVG(pts), 1) AS avg_pts,
    ROUND(AVG(ast), 1) AS avg_ast,
    ROUND(AVG(reb), 1) AS avg_reb,
    ROUND(AVG(net_rating), 1) AS avg_net_rating,
    ROUND(AVG(usg_pct), 3) AS avg_usg_pct,
    ROUND(AVG(ts_pct), 3) AS avg_ts_pct
  FROM workspace.nba_proj.nba_season_stats
  WHERE experience >= 3
)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## MVP & Dream Team

-- COMMAND ----------

-- Calculate MVP factor for each player-season using weighted stats
with mvp_factor as (
  select 
    player_name, 
    team_abbreviation as team, 
    season, 
    pts, 
    ast, 
    reb, 
    net_rating, 
    ts_pct,
    ROUND((.3 * pts) + (.2 * ast) + (.2 * ts_pct) + (.15 * reb) + (.15 * net_rating), 2) as mvp_factor
  from workspace.nba_proj.nba_season_stats
)

-- Select the top MVP candidate per season based on highest MVP factor
select 
  player_name, 
  team,
  season, 
  mvp_factor,
  pts, 
  ast, 
  reb, 
  net_rating, 
  ts_pct
from (
  select *, 
    rank() over (partition by season order by mvp_factor desc) as rnk 
  from mvp_factor
)
where rnk = 1
order by season desc

-- COMMAND ----------

WITH mvp_factor AS (
    SELECT
        n.player_name AS player_name,
        n.season AS season,
        ROUND(
            (0.3 * n.pts)
            + (0.2 * n.ast)
            + (0.2 * n.ts_pct)
            + (0.15 * n.reb)
            + (0.15 * n.net_rating)
            , 2
        ) AS mvp_factor
    FROM
        workspace.nba_proj.nba_season_stats AS n
), 
predicted_mvp AS (
    SELECT
        m.player_name AS player_name,
        m.season AS season,
        RANK() OVER (
            PARTITION BY m.season
            ORDER BY m.mvp_factor DESC
        ) AS rnk
    FROM
        mvp_factor AS m
), 
real_mvp AS (
    SELECT
        season,
        actual_mvp
    FROM (
        VALUES 
            (1996, 'Karl Malone')
            , (1997, 'Michael Jordan')
            , (1998, 'Karl Malone')
            , (1999, 'Shaquille O''Neal')
            , (2000, 'Allen Iverson')
            , (2001, 'Tim Duncan')
            , (2002, 'Tim Duncan')
            , (2003, 'Kevin Garnett')
            , (2004, 'Steve Nash')
            , (2005, 'Steve Nash')
            , (2006, 'Dirk Nowitzki')
            , (2007, 'Kobe Bryant')
            , (2008, 'LeBron James')
            , (2009, 'LeBron James')
            , (2010, 'Derrick Rose')
            , (2011, 'LeBron James')
            , (2012, 'LeBron James')
            , (2013, 'Kevin Durant')
            , (2014, 'Stephen Curry')
            , (2015, 'Stephen Curry')
            , (2016, 'Russell Westbrook')
            , (2017, 'James Harden')
            , (2018, 'Giannis Antetokounmpo')
            , (2019, 'Giannis Antetokounmpo')
            , (2020, 'Nikola Jokic')
            , (2021, 'Nikola Jokic')
            , (2022, 'Joel Embiid')
    ) AS real_mvp(season, actual_mvp)
)
SELECT
    p.season AS season,
    p.player_name AS predicted_mvp,
    r.actual_mvp AS actual_mvp,
    CASE
      WHEN p.player_name = r.actual_mvp THEN 'Correct'
      ELSE 'Incorrect'
    END AS mvp_prediction
FROM
    predicted_mvp AS p
    INNER JOIN real_mvp AS r
        Using(season)
WHERE
    p.rnk = 1

-- COMMAND ----------

WITH height_buckets AS (
    SELECT 
        player_name, 
        season,
        CASE 
            WHEN player_height <= 188 THEN 'PG'  -- Point Guard
            WHEN player_height > 188 AND player_height <= 196 THEN 'SG'  -- Shooting Guard
            WHEN player_height > 196 AND player_height <= 203 THEN 'SF'  -- Small Forward
            WHEN player_height > 203 AND player_height <= 210 THEN 'PF'  -- Power Forward
            WHEN player_height > 210 THEN 'C'  -- Center
        END AS position, 
        ROUND((0.3 * pts) + (0.2 * ast) + (0.2 * ts_pct) + (0.15 * reb) + (0.15 * net_rating), 2) AS mvp_factor  -- Calculate MVP factor
    FROM 
        workspace.nba_proj.nba_season_stats
),

ranks AS (
    SELECT 
        player_name, 
        season,
        position,
        mvp_factor,
        RANK() OVER (PARTITION BY position ORDER BY mvp_factor DESC) AS rnk  -- Rank players within each position based on MVP factor
    FROM 
        height_buckets
)

SELECT 
    r.player_name, 
    r.season,
    r.position,
    r.mvp_factor, 
    n.pts, 
    n.ast, 
    n.reb, 
    n.net_rating
FROM 
    ranks r
INNER JOIN 
    workspace.nba_proj.nba_season_stats n
USING(season, player_name)
WHERE 
    rnk = 1  -- Select only the top-ranked player for each position
ORDER BY 
    mvp_factor DESC  -- Order results by MVP factor in descending order
