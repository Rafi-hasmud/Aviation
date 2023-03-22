# Aviation Data Analysis

- Download Raw Dataset -- https://bit.ly/3mCysVz
- Download Cleaned Dataset - https://bit.ly/3YvEqon

# Introduction

The Aviation Data Analysis project aims to analyze data on flights to identify patterns and trends related to arrival and departure times, delays, cancellations, and other factors that affect the performance of airlines. The project uses a dataset that contains information on flights from various sources, including airlines, airports, and government agencies. 

The project consists of several stages, starting with data cleaning to address missing values, errors, and inconsistencies in the dataset. This is followed by exploratory data analysis to identify patterns and trends in the data, and statistical modeling to test hypotheses and make predictions based on the data.

# Goal

The ultimate goal of the project is to provide insights and recommendations that can help airlines and airports improve their performance and better serve their customers. 

This documentation provides a detailed overview of the Aviation Data Analysis project, including the methodology, data sources, data cleaning process, data analysis techniques, and findings. The documentation is intended to provide a comprehensive guide for anyone interested in replicating or building upon the project's analysis.

I hope that this project will contribute to the ongoing efforts to improve the performance of airlines and airports, and I invite feedback and suggestions for future iterations of the project.

# Files 
The project includes the following files:


# Data Wrangling using Excel

The first step in any data analysis project is to collect and clean the data. In this project, I collected data on aviation incidents from various sources and consolidated them into a single dataset. This dataset contained a large number of missing values, errors, and inconsistencies, which needed to be addressed before any meaningful analysis could be performed.
To clean the data, I used various formulae in Excel to identify and correct errors, inconsistencies, and missing values. I also used conditional formatting and data validation to ensure that the data was consistent and accurate.
The following steps I am taken to clean the dataset:
1.	Identify and remove duplicate records: I used Excel's built-in tools to identify and remove any duplicate records from the dataset. This step helped to reduce the size of the dataset and avoid any errors due to duplicate records.
2.	Handle missing values: I used various formulae to fill in missing values in the dataset. For example, I used the IF function to check if a value was missing and then filled in a default value or a value based on the adjacent data.
3.	Correct errors: I used formulae to correct any errors in the dataset. For example, I used the VLOOKUP function to correct misspelled names or to map one value to another.
4.	Standardize data: I used formulae to standardize data in the dataset. For example, I used the UPPER function to convert all text to uppercase or the PROPER function to capitalize the first letter of each word.
5.	Remove unnecessary columns: I removed any columns from the dataset that Ire not required for the analysis. This step helped to reduce the size of the dataset and make it more manageable.
6.	Validate data: I used data validation to ensure that the data in the dataset was consistent and accurate. For example, I set up data validation rules to ensure that all dates were in the correct format and fell within a specific range.
By following these steps, I was able to clean the dataset and prepare it for analysis. The cleaned dataset was then saved in a separate file to ensure that the original data was not lost or overwritten.

# Data Interpretation, Exploration and Wrangling using SQL

```sql
SELECT * 
FROM Aviation.dbo.Flights


--Correcting Data in the column

Update Aviation.dbo.Flights
SET arrival_status = REPLACE (arrival_status, 'Not Availble', 'Not Available')


--Changing Column Name

EXEC sp_RENAME 'Aviation.dbo.Flights.raw_wheels_on_time', 'wheels_on_time', 'COLUMN'
EXEC sp_RENAME 'Aviation.dbo.Flights.raw_wheels_off_time', 'wheels_off_time', 'COLUMN'

```
These SQL queries are used to clean, correct and transform data in the "Flights" table of the "Aviation" database, which is part of the "Aviation Data Analysis" project. The queries perform the following actions:
 - The first query selects all the data from the "Flights" table.
 - The second query corrects the data in the "arrival_status" column by replacing misspelled values ("Not Availble") with the correct spelling ("Not Available").
 - The third and fourth queries change the names of two columns in the "Flights" table from "raw_wheels_on_time" and "raw_wheels_off_time" to "wheels_on_time" and "wheels_off_time", respectively.

--------------------------------------------------------------------------

```sql
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
```

These SQL queries are used to identify and correct data irregularities in the "Flights" table of the "Aviation" database, which is part of the "Aviation Data Analysis" project. The queries perform the following actions:
 - The first query selects the "arrival_delay" and "actual_arrival_time" columns from the "Flights" table where the "actual_arrival_time" value is "Cancelled". This query is used to identify any data quality issues related to flight cancellations.
 - The second and third queries alter the "arrival_delay" column to allow for null values and then replace any null values with "Cancelled" where the "actual_arrival_time" value is also "Cancelled". This transformation is necessary to ensure data consistency and enable accurate analysis of the data.
 - The fourth and fifth queries select the "actual_departure_time" and "departure_delay" columns from the "Flights" table where the "actual_departure_time" value is "Cancelled". This query is used to identify any data quality issues related to cancelled flights at departure.
 - The sixth and seventh queries alter the "departure_delay" column to allow for null values and then replace any null values with "Cancelled" where the "actual_departure_time" value is also "Cancelled". This transformation is necessary to ensure data consistency and enable accurate analysis of the data.


#### Reason to use these queries:
The queries are used to identify and correct data quality issues in the "Flights" table that may affect the accuracy and reliability of any analyses or conclusions drawn from the data. 

Flight cancellations and delays are a common occurrence in the aviation industry, and it is essential to ensure that the data accurately reflects these events. By identifying irregularities in the data related to cancelled flights and replacing any missing data with a consistent value, the data can be standardized and cleaned, enabling more accurate and reliable analysis. 

These queries are part of the data preparation phase of the "Aviation Data Analysis" project and are essential for ensuring the quality and integrity of the data.

--------------------------------------------------------------------------

```sql
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
```

The above SQL code is an example of how to replace 0 and 1 with No and Yes, respectively, in the 'was_cancelled' column of the Aviation.dbo.Flights table.

 - The first statement changes the data type of the 'was_cancelled' column to varchar(3), which allows the column to store character values.
 - The second statement uses the CASE expression to update the 'was_cancelled' values to 'NO' or 'YES' based on whether the original value is '0' or '1', respectively. For all other values, the original value is retained.
 - The third statement is a SELECT statement used to verify that the update was successful.


The reason for using this SQL code is to standardize the values in the 'was_cancelled' column to make it easier to interpret and analyze the data. 
Using 'NO' and 'YES' instead of '0' and '1' improves the readability of the data and makes it easier to understand the meaning of each value. 
This is especially important if the data is being used for reporting or analysis purposes.

--------------------------------------------------------------------------

```sql
--fix the time format

ALTER TABLE Aviation.dbo.Flights
ALTER COLUMN day date

SELECT day
FROM Aviation.dbo.Flights
```
The above SQL code is an example of how to fix the time format in the 'day' column of the Aviation.dbo.Flights table.

 - The first statement changes the data type of the 'day' column to date, which allows the column to store date values.

 - The second statement is a SELECT statement used to verify that the time format has been fixed and the values in the 'day' column are in the correct date format.

The reason for using this SQL code is to ensure that the data in the 'day' column is in the correct format for analysis. 
If the time format is not standardized, it can lead to errors in analysis and reporting. By fixing the time format to the correct format, 
it makes it easier to analyze the data and draw insights from it. This is especially important for the Aviation Data Analysis project, 
where accurate data is critical for decision-making and identifying trends in the aviation industry.

--------------------------------------------------------------------------

```sql
-- average distance

SELECT AVG (TRY_CONVERT(decimal, LEFT(distance, CHARINDEX(' ', distance)-1))) as average_distance
From Aviation.dbo.Flights
WHERE distance IS NOT NULL
```
The above SQL code is an example of how to calculate the average distance of flights in the Aviation.dbo.Flights table.

 - The SELECT statement uses the AVG function to calculate the average distance of all flights in the table. 
 - The TRY_CONVERT and LEFT functions are used to extract the numeric value of the distance column and convert it to a decimal value. 
 - The CHARINDEX function is used to find the position of the first space in the distance column, 
 which allows the LEFT function to extract only the numeric value before the space. 
 - The WHERE clause filters out any NULL values in the distance column.

The reason for using this SQL code is to calculate the average distance of flights in the Aviation.dbo.Flights table, 
which is important for analyzing the performance of airlines and identifying trends in the aviation industry. 
The average distance is a key metric for measuring the efficiency and profitability of airlines. 
By calculating the average distance using SQL, we can easily incorporate this metric into our analysis and reporting.

--------------------------------------------------------------------------

```sql
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

```

The above SQL code includes two examples of how to analyze flight delays in the Aviation.dbo.Flights table.

 - The first query calculates the average arrival delay and average departure delay of all flights in the table. 
 The CONVERT and TRY_CONVERT functions are used to convert the arrival_delay and departure_delay columns to numeric values. 
 The WHERE clause filters out any cancelled flights and NULL values.

 - The second query calculates the average arrival delay and average departure delay of flights grouped by the day of the week. 
The GROUP BY clause groups the flights by the day_of_week column, and the 
ORDER BY clause orders the results by the day of the week in a specific order. 
The CONVERT and TRY_CONVERT functions are used to convert the arrival_delay and departure_delay columns to integer values.

The reason for using these SQL queries is to analyze flight delays in the Aviation.dbo.Flights table, 
which is important for identifying trends and performance metrics of airlines. 
By calculating the average arrival delay and average departure delay, we can identify which airlines are performing well and which ones need improvement. 
By grouping the flights by day of the week, we can identify if there are any specific days of the week that have more delays than others. 
This information can be used to improve airline scheduling and operations. 
The results of these queries can be used in the Aviation Data Analysis project to provide insights and recommendations 
to airlines for improving their performance.

--------------------------------------------------------------------------

```sql
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

```
The above queries are used to analyze the distribution and reasons for flight cancellations.

 - The first query displays the distribution of reasons for flight cancellations in the Aviation database. 
It groups the cancellations by the reason and returns the count of each reason for the cancellations. 
This information can be used to identify patterns and trends in the reasons for cancellations and help airlines take appropriate measures to reduce them.

 - The second query displays how the day of the week affects flight cancellations. 
It groups the cancellations by the day of the week and returns the count of cancelled arrivals and departures for each day of the week. 
This information can be used to identify the days with the highest cancellation rates, and help airlines adjust their schedules accordingly.

 - The third query displays the top 5 flight cancellation dates in the Aviation database. 
It groups the cancellations by the date and day of the week and returns the count of flight cancellations, arrival cancellations, 
and departure cancellations for each date. This information can be used to identify the specific days with the highest cancellation rates 
and investigate the causes behind them.

- The fourth query provides insights into how the origin city and state affect flight delays and cancellations. This information can be used by airlines to understand which regions are prone to more delays and cancellations and take proactive steps to avoid such situations.

Overall, these queries provide valuable insights into flight cancellations and help airlines make informed decisions to improve their operations and reduce cancellations.

--------------------------------------------------------------------------

```sql
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
```
The above queries are essential to the Aviation Data Analysis project. The project aims to explore and analyze data related to flights to improve the overall aviation industry's efficiency and quality. The data provides valuable insights into the performance of airlines, their on-time arrivals, departures, delays, and cancellation rates.

 - The first query provides the average departure and arrival delays of airlines, which are significant factors that influence customer satisfaction. It allows airlines to identify the areas where they can improve their services and make informed decisions about how to allocate resources effectively.

 - The second query determines the airlines with the highest cancellation rates and the main reasons for cancellation. Airlines can use this information to understand their performance in terms of flight cancellations and the reasons for them. This can help airlines focus on reducing flight cancellations and addressing the specific issues that are causing them.

 - The third query identifies the airlines that have the highest percentage of on-time departures and arrivals. On-time performance is critical to passenger satisfaction and can significantly affect an airline's reputation. The information obtained from this query can help airlines to focus on improving their on-time performance.

 - The fourth query is useful in identifying which airlines have the most frequent flights between specific city pairs. This information can help airlines identify their popular routes and optimize their schedules and services to meet the demand and improve customer satisfaction.
 - 

Overall, these queries provide airlines with essential insights into their performance and allow them to make data-driven decisions to improve their services and meet their customer's needs. The Aviation Data Analysis project's success is based on the accurate and relevant data obtained from these queries, making them an essential part of the project's documentation.






