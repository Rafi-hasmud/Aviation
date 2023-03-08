SELECT * 
FROM Aviation.dbo.Flights


--Correcting Data in the column

Update Aviation.dbo.Flights
SET arrival_status = REPLACE (arrival_status, 'Not Availble', 'Not Available')


--Changing Column Name

EXEC sp_RENAME 'Aviation.dbo.Flights.raw_wheels_on_time', 'wheels_on_time', 'COLUMN'
EXEC sp_RENAME 'Aviation.dbo.Flights.raw_wheels_off_time', 'wheels_off_time', 'COLUMN'


--figure out the irregularity

Select arrival_delay,
actual_arrival_time
FROM Aviation.dbo.Flights
WHERE actual_arrival_time = 'Cancelled' --AND arrival_delay IS NULL


--Replace the null with 'Cancelled'
--for arrival delay
ALTER TABLE Aviation.dbo.Flights 
ALTER COLUMN arrival_delay nvarchar(255)

UPDATE Aviation.dbo.Flights
SET arrival_delay = 'Cancelled' 
WHERE actual_arrival_time = 'Cancelled' AND arrival_delay IS NULL
 
SELECT actual_arrival_time, arrival_delay
FROM Aviation.dbo.Flights
WHERE actual_arrival_time = 'Cancelled'


--for departure delay

ALTER TABLE Aviation.dbo.Flights 
ALTER COLUMN departure_delay nvarchar(255)

UPDATE Aviation.dbo.Flights
SET departure_delay ='Cancelled'
WHERE actual_departure_time = 'Cancelled' AND departure_delay IS NULL

SELECT actual_departure_time, departure_delay
FROM Aviation.dbo.Flights
WHERE actual_departure_time = 'Cancelled'


--Replace 0/1 with No/Yes

ALTER TABLE Aviation.dbo.Flights
ALTER COLUMN was_cancelled varchar(3)

UPDATE Aviation.dbo.Flights
SET was_cancelled = CASE was_cancelled
                    WHEN '0' THEN 'NO'
					WHEN '1' THEN 'YES'
					ELSE was_cancelled END

SELECT was_cancelled
FROM Aviation.dbo.Flights


--fix the time format

ALTER TABLE Aviation.dbo.Flights
ALTER COLUMN day date

SELECT day
FROM Aviation.dbo.Flights


-- average distance

SELECT AVG (TRY_CONVERT(decimal, LEFT(distance, CHARINDEX(' ', distance)-1))) as average_distance
From Aviation.dbo.Flights
WHERE distance IS NOT NULL

---average arrival and departure delay

SELECT AVG(CONVERT(numeric, TRY_Convert(numeric, arrival_delay))) as average_arrival_delay, 
AVG(CONVERT(numeric, TRY_Convert(numeric, departure_delay))) as average_departure_delay
From Aviation.dbo.Flights
WHERE arrival_delay NOT LIKE '%Cancelled%' AND arrival_delay IS NOT NULL AND
departure_delay NOT LIKE '%Cancelled%' AND departure_delay IS NOT NULL


--how the day of the week affects flight delays

SELECT day_of_week, AVG(CONVERT(INT, TRY_Convert(INT, arrival_delay))) as average_arrival_delay, 
AVG(CONVERT(INT, TRY_Convert(INT, departure_delay))) as average_departure_delay
From Aviation.dbo.Flights
WHERE arrival_delay NOT LIKE '%Cancelled%' 
  AND arrival_delay IS NOT NULL 
  AND departure_delay NOT LIKE '%Cancelled%' 
  AND departure_delay IS NOT NULL
GROUP BY day_of_week
ORDER BY 
        CASE day_of_week
		     WHEN 'Friday'    THEN 1
			 WHEN 'Saturday'  THEN 2
			 WHEN 'SUNDAY'    THEN 3
			 WHEN 'Monday'    THEN 4
			 WHEN 'Tuesday'   THEN 5
			 WHEN 'Wednesday' THEN 6
			 WHEN 'Thursday'  THEN 7
			 END


 --Most Common causes of flight delays

SELECT delay_cause,  COUNT(delay_cause) as delay_count
FROM
     (SELECT CASE 
             WHEN security_delay>0 THEN 'Security Delay'
			 WHEN weather_delay>0 THEN 'Weather Delay'
			 WHEN late_aircraft_delay>0 THEN 'Late Aircraft Delay'
			 WHEN air_traffic_delay>0 THEN 'Air Traffic Delay'
			 WHEN carrier_delay>0 THEN 'Carrier Delay'
			 ELSE 'Not Measured'
			 END as delay_cause
 FROM Aviation.dbo.Flights
WHERE arrival_status = 'Delayed'
 AND departure_status = 'Delayed') delay_table
Group by delay_cause
Order by 2 DESC

---distribution of the reasons for flight cancellations

SELECT cancellation_reason, COUNT(*) as count
From Aviation.dbo.Flights
WHERE was_cancelled = 'YES'
GROUP BY cancellation_reason


---how the day of the week affects flight cancellaions

SELECT day_of_week,
                   COUNT(CASE WHEN actual_arrival_time LIKE '%Cancelled%' THEN 1 END) AS cancelled_arrivals,
				   COUNT(CASE WHEN actual_departure_time LIKE '%Cancelled%' THEN 1 END) AS cancelled_departures

FROM Aviation.dbo.Flights
GROUP BY day_of_week
ORDER BY
        CASE day_of_week
		     WHEN 'Friday'    THEN 1
			 WHEN 'Saturday'  THEN 2
			 WHEN 'SUNDAY'    THEN 3
			 WHEN 'Monday'    THEN 4
			 WHEN 'Tuesday'   THEN 5
			 WHEN 'Wednesday' THEN 6
			 WHEN 'Thursday'  THEN 7
			 END
 

 --Top 5 flight cancellation dates

 SELECT TOP 5 day, day_of_week, 
             COUNT(CASE WHEN was_cancelled LIKE '%YES%' THEN 1 END) AS flight_cancellations_count,
             COUNT(CASE WHEN actual_arrival_time LIKE '%Cancelled%' THEN 1 END) AS arrival_cancellations_count,
			 COUNT(CASE WHEN actual_departure_time LIKE '%Cancelled%' THEN 1 END) AS departure_cancellations_count
 FROM Aviation.dbo.Flights
 GROUP BY day, day_of_week
 ORDER BY 3 DESC



-- How does the origin city and state affect flight delays and cancellations?

SELECT origin_city, origin_state,
                  COUNT(CASE WHEN was_cancelled LIKE 'YES' THEN 1 END) AS cancelled_flights_count,
				  COUNT(CASE WHEN departure_status LIKE 'Delayed' THEN 1 END) AS delayed_flights_count
    FROM Aviation.dbo.Flights
    GROUP BY origin_city, origin_state
	ORDER BY 3 DESC,4 DESC


-- avg departure & arrival delay of airlines

SELECT airline_name, AVG(TRY_CONVERT(numeric, departure_delay)) AS avg_departure_delay,
                     AVG(TRY_CONVERT(numeric, arrival_delay)) AS avg_arrival_delay
FROM Aviation.dbo.Flights
WHERE departure_delay NOT LIKE '%Cancelled%' AND departure_delay IS NOT NULL
  AND arrival_delay NOT LIKE '%Cancelled%' AND arrival_delay IS NOT NULL
GROUP BY airline_name
ORDER BY avg_departure_delay DESC;



--- airlines with the highest cancellation rate and the main reasons for cancellation

SELECT airline_name, COUNT(*) AS total_flights,
                     COUNT(CASE WHEN was_cancelled = 'YES' THEN 1 END) AS cancellation_count,
					 COUNT(CASE WHEN cancellation_reason = 'Carrier' THEN 1 END) AS carrier_cancellation,
					 COUNT(CASE WHEN Cancellation_reason ='National Air System' THEN 1 END) AS national_air_system_cancellation,
					 COUNT(CASE WHEN cancellation_reason = 'Weather' THEN 1 END) AS weather_cancellation,
				CAST(COUNT(CASE WHEN was_cancelled = 'YES' THEN 1 END) AS numeric)/COUNT(*) *100 AS cancellation_rate
FROM Aviation.dbo.Flights
GROUP BY airline_name
Order By cancellation_rate DESC

-- airlines that highest percentage of depart on time and arrival on time

SELECT airline_name, COUNT(*) AS total_flights,
       CAST(COUNT (CASE WHEN departure_status = 'On Time' THEN 1 END) AS numeric) / COUNT(*) *100 AS on_time_departure_percentage,
	   CAST(COUNT (CASE WHEN arrival_status  = 'On Time' THEN 1 END) AS numeric)/ COUNT(*) *100 AS on_time_arrival_percentage
FROM Aviation.dbo.Flights
WHERE departure_status IS NOT NULL
 AND  arrival_status IS NOT NULL
GROUP BY airline_name
ORDER BY on_time_departure_percentage DESC, on_time_arrival_percentage DESC


--airlines have the most frequent flights between certain city pairs
-- New York to Washington

SELECT airline_name, COUNT (*) as flights                               
FROM Aviation.dbo.Flights
WHERE origin_city = 'New York' 
AND   destination_city = 'Washington'
GROUP BY airline_name
Order BY 2 DESC
