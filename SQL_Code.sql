## Appending all tables into one
SELECT  *
FROM `cyclistic-347119.Trips.table_202104`
UNION DISTINCT
SELECT *
FROM `cyclistic-347119.Trips.table_202105`
UNION DISTINCT
SELECT *
FROM `cyclistic-347119.Trips.table_202106`
UNION DISTINCT
SELECT *
FROM `cyclistic-347119.Trips.table_202107`
UNION DISTINCT
SELECT *
FROM `cyclistic-347119.Trips.table_202108`
UNION DISTINCT
SELECT *
FROM `cyclistic-347119.Trips.table_202109`
UNION DISTINCT
SELECT *
FROM `cyclistic-347119.Trips.table_202110`
UNION DISTINCT
SELECT *
FROM `cyclistic-347119.Trips.table_202111`
UNION DISTINCT
SELECT *
FROM `cyclistic-347119.Trips.table_202112`
UNION DISTINCT
SELECT *
FROM `cyclistic-347119.Trips.table_202201`
UNION DISTINCT
SELECT *
FROM `cyclistic-347119.Trips.table_202202`
UNION DISTINCT
SELECT *
FROM `cyclistic-347119.Trips.table_202203`

## Calculating the average ride length 
SELECT  
  member_casual,
  ROUND(AVG(DATE_DIFF(ended_at, started_at, MINUTE))) AS total_min
FROM `cyclistic-347119.Trips.all_trips`
GROUP BY member_casual

## Extracting data on the number of rides per day by casual/member riders
SELECT  
  member_casual,
  COUNT(EXTRACT(DAYOFWEEK FROM started_at)) AS num_of_days,
  FORMAT_DATE('%A', started_at) AS day_of_week         
FROM `cyclistic-347119.Trips.all_trips`
GROUP BY day_of_week, member_casual
ORDER BY member_casual

## Calculating the average ride length per day by casual/member riders
SELECT  
  member_casual,
  ROUND(AVG(DATE_DIFF(ended_at, started_at, MINUTE))) AS avg_total_min,
  FORMAT_DATE('%A', started_at) AS day_of_week,         
FROM `cyclistic-347119.Trips.all_trips`
GROUP BY day_of_week, member_casual
ORDER BY member_casual
