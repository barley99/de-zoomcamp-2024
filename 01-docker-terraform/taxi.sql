-- Question 3. Count records
select count(*) from public.green_tripdata
where lpep_pickup_datetime >= '2019-09-18 00:00:00' and lpep_pickup_datetime < '2019-09-19 00:00:00'
	and lpep_dropoff_datetime >= '2019-09-18 00:00:00' and  lpep_dropoff_datetime < '2019-09-19 00:00:00';

-- Question 4. Largest trip for each day
SELECT DATE(lpep_pickup_datetime)
FROM public.green_tripdata
WHERE trip_distance = (select MAX(trip_distance) from public.green_tripdata);

--
SELECT "PULocationID", SUM(total_amount) AS location_total_amount
FROM public.green_tripdata
WHERE DATE(lpep_pickup_datetime) = '2019-09-18'
GROUP BY "PULocationID"
ORDER BY location_total_amount DESC;

-- Question 5. Three biggest pick up Boroughs
SELECT "Borough", SUM(total_amount) AS location_total_amount
FROM public.green_tripdata AS trips
INNER JOIN public.taxi_zone_lookup AS zones ON trips."PULocationID" = zones."LocationID"
WHERE DATE(lpep_pickup_datetime) = '2019-09-18'
GROUP BY "Borough"
HAVING SUM(total_amount) > 50000
ORDER BY location_total_amount DESC;

-- Question 6. Largest tip
EXPLAIN WITH astoria_sept_trips AS (
	SELECT zones_do."Zone", tip_amount
	FROM public.green_tripdata AS trips
	INNER JOIN public.taxi_zone_lookup AS zones_pu ON trips."PULocationID" = zones_pu."LocationID"
	INNER JOIN public.taxi_zone_lookup AS zones_do ON trips."DOLocationID" = zones_do."LocationID"
	WHERE DATE_TRUNC('month', CAST(lpep_pickup_datetime AS TIMESTAMP)) = '2019-09-01'
		AND zones_pu."Zone" = 'Astoria'
)
SELECT "Zone" FROM astoria_sept_trips WHERE tip_amount = (SELECT MAX(tip_amount) FROM astoria_sept_trips);

SELECT zones_do."Zone", tip_amount
FROM public.green_tripdata AS trips
INNER JOIN public.taxi_zone_lookup AS zones_pu ON trips."PULocationID" = zones_pu."LocationID"
INNER JOIN public.taxi_zone_lookup AS zones_do ON trips."DOLocationID" = zones_do."LocationID"
WHERE DATE_TRUNC('month', CAST(lpep_pickup_datetime AS TIMESTAMP)) = '2019-09-01'
	AND zones_pu."Zone" = 'Astoria'
ORDER BY tip_amount DESC
LIMIT 1;
