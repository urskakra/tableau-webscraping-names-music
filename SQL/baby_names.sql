DROP DATABASE IF EXISTS baby_names;

CREATE DATABASE baby_names;

USE baby_names;

SELECT * FROM top_names_states
	ORDER BY Count DESC
    LIMIT 10000;
    
-- Most popular names of all times for males.

SELECT Name, SUM(Count) AS 'Total' FROM top_names_states
	WHERE Sex LIKE 'M'
		GROUP BY Name
		ORDER BY SUM(Count) DESC
		LIMIT 30;
        
-- Most popular names of all times for females.

SELECT Name, SUM(Count) AS 'Total' FROM top_names_states
	WHERE Sex LIKE 'F'
		GROUP BY Name
		ORDER BY SUM(Count) DESC
		LIMIT 10;
        
-- Join top_names and all_births, on Year of Birth and Ethnicity.
-- For years 2011-2019.
-- ??

SELECT top_names.*, top_names.Count / all_births.Births AS 'Percentage of all births'
FROM top_names
	JOIN all_births
	ON all_births.`Birth Year`= top_names.`Year of Birth`
		AND all_births.`Race or Ethnicity of Mother` = top_names.Ethnicity
        AND all_births.`Sex of Infant` = top_names.Gender
	WHERE top_names.`Year of Birth` BETWEEN 2011 AND 2019
	ORDER BY Count DESC;
    
-- Join top_names_states with corresponding music for each year

SELECT top_names_states.*, song, decade
	FROM top_names_states
    JOIN 
		(SELECT year
				,decade
                ,song
			FROM (
			SELECT year
				,decade
                ,song
				,all_music.order
				,RANK() OVER (PARTITION BY year order by all_music.order) as ranking
			FROM all_music) AS my_table
			WHERE ranking = 1) as top_chart
	ON top_names_states.Year = top_chart.year;
  
  
-- Top 30 most unique names of all times (with at least 500 total occurences / avg 5 per last 100 years).

SELECT Name, SUM(Count) AS 'Total' FROM top_names_states
	WHERE Sex LIKE 'M'
            GROUP BY Name
				HAVING SUM(Count) > 500
            ORDER BY SUM(Count) ASC
            LIMIT 30;
            
SELECT Name, SUM(Count) AS 'Total' FROM top_names_states
	WHERE Sex LIKE 'F'
            GROUP BY Name
				HAVING SUM(Count) > 500
            ORDER BY SUM(Count) ASC
            LIMIT 30;


-- Biggest change in name popularity in the past 100 years (growing and declining).

SELECT Sex, Name, (MAX(Count) - MIN(Count)) AS max_change
	FROM top_names_states
		WHERE Sex = 'M'
		GROUP BY Name
		ORDER BY max_change DESC
		LIMIT 20;
        
SELECT Sex, Name, (MAX(Count) - MIN(Count)) AS max_change
	FROM top_names_states
		WHERE Sex = 'F'
		GROUP BY Name
		ORDER BY max_change DESC
		LIMIT 20;

-- Most popular modern names (appeared after 1990), plus year when they appear for the first time.
    
SELECT MIN(Year) AS First_year, Name, SUM(Count) AS Total
	FROM top_names_states
		WHERE Sex = 'M'
    GROUP BY Name
		HAVING MIN(Year) BETWEEN '1990' AND '2022'
    ORDER BY SUM(Count) DESC
    LIMIT 10;
    
SELECT MIN(Year) AS First_year, Name, SUM(Count) AS Total
	FROM top_names_states
		WHERE Sex = 'F'
    GROUP BY Name
		HAVING MIN(Year) BETWEEN '1990' AND '2022'
    ORDER BY SUM(Count) DESC
    LIMIT 10;
    
-- Most popular traditional names (disappeared by 1990), plus year when they appear for the last time.
    
SELECT MAX(Year) AS Last_year, Name, SUM(Count) AS Total
	FROM top_names_states
		WHERE Sex = 'M'
    GROUP BY Name
		HAVING MAX(Year) < '1990'
    ORDER BY SUM(Count) DESC
    LIMIT 10;
    
SELECT MAX(Year) AS Last_year, Name, SUM(Count) AS Total
	FROM top_names_states
		WHERE Sex = 'F'
    GROUP BY Name
		HAVING MAX(Year) < '1990'
    ORDER BY SUM(Count) DESC
    LIMIT 10;
    
-- Timeless names, that have been around throughout all the years observed.

SELECT (MAX(Year)-MIN(Year)) AS years_present, Name, SUM(Count) AS Total
	FROM top_names_states
		WHERE Sex = 'M'
    GROUP BY Name
		HAVING years_present = 111
    ORDER BY years_present DESC, Total DESC;
    
SELECT (MAX(Year)-MIN(Year)) AS years_present, Name, SUM(Count) AS Total
	FROM top_names_states
		WHERE Sex = 'F'
    GROUP BY Name
		HAVING years_present = 111
    ORDER BY years_present DESC, Total DESC;
    
-- Names with sudden spikes in popularity. Ranking of count by year per name? MAX STDEV?

SELECT Name, MAX(Count) AS spike, STDDEV(Count) AS std_dev
	FROM top_names_states
		WHERE Sex = 'M'
    GROUP BY Name
    ORDER BY spike DESC
    LIMIT 20;
    
SELECT Name, MAX(Count) AS spike, STDDEV(Count) AS std_dev
	FROM top_names_states
		WHERE Sex = 'F'
    GROUP BY Name
    ORDER BY spike DESC
    LIMIT 20;
    
-- Search music top charts for possible top names in the same year.

SELECT year
	,song
FROM (
SELECT year
	,song
    ,all_music.order
    ,RANK() OVER (PARTITION BY year order by all_music.order) as ranking
FROM all_music) AS my_table
WHERE ranking = 1;

-- BESSIE, LOUIS 1925
-- DUKE 1931
-- JUDY 1939
-- GLORIA 1978
-- BILLIE 1982
-- MADONNA 1989
-- !!! SINEAD 1990
-- !! WHITNEY 1992
-- !!! RIHANNA 2007
-- !! BEYONCE 2008
-- ELVIS 1950s
-- CHET 1960s
-- ARETHA 1960s
-- BRITNEY y.2000
-- Mariah 1990s
-- Bryan 1980s
-- Ray 1957


SELECT Year, Name, SUM(Count)
    FROM top_names_states
		WHERE Name = 'Cannonball'
	GROUP BY Year
	ORDER BY SUM(Count) DESC;
    
    
-- Find most popular unisex names. Condition: at least 10.000 total occurences per sex, and ratio F/M at least 25%.

SELECT top_names_states.Name, Sex, SUM(Count)
	FROM top_names_states
    JOIN
	(SELECT Name, SUM(Totals)
		FROM
		(SELECT top_names_states.Name, Sex, SUM(Count) AS Totals
			FROM top_names_states
			JOIN
			(SELECT Name, SUM(Count)
				FROM top_names_states
				GROUP BY Name
					HAVING COUNT(DISTINCT Sex) = 2
					AND SUM(Count) > 10000) AS unisex_names
			ON unisex_names.Name = top_names_states.Name
			GROUP BY Name, Sex
				HAVING Totals > 10000) AS unisex_top
		GROUP BY Name
			HAVING COUNT(DISTINCT Sex) = 2
			AND MAX(Totals) - MIN(Totals) BETWEEN 10000 AND 100000) AS unisex_final
	ON unisex_final.Name = top_names_states.Name
    GROUP BY Name, Sex
	ORDER BY Name ASC;
    
SELECT top_names_states.Name, Sex, SUM(Count)
	FROM top_names_states
    JOIN
	(SELECT Name, SUM(Totals)
		FROM
		(SELECT top_names_states.Name, Sex, SUM(Count) AS Totals
			FROM top_names_states
			JOIN
			(SELECT Name, SUM(Count)
				FROM top_names_states
				GROUP BY Name
					HAVING COUNT(DISTINCT Sex) = 2
					AND SUM(Count) > 10000) AS unisex_names
			ON unisex_names.Name = top_names_states.Name
			GROUP BY Name, Sex
				HAVING Totals > 10000) AS unisex_top
		GROUP BY Name
			HAVING COUNT(DISTINCT Sex) = 2
			AND MIN(Totals)/MAX(Totals) > 0.25) AS unisex_final
	ON unisex_final.Name = top_names_states.Name
    GROUP BY Name, Sex
	ORDER BY Name ASC;
    
    
-- Confirm if unisex names from Tableau are really unisex. YES.

SELECT Name, Sex, SUM(Count)
	FROM top_names_states
		WHERE Name IN ('Andrew', 'Ashley', 'Amanda', 'Amy', 'Amber', 'Angela', 'Alan',
        'Austin', 'Anna', 'Alyssa', 'Carlos', 'Carl', 'Chase', 'Caleb', 'Colin',
        'Cindy', 'Carrie', 'Claire', 'Craig', 'Calvin', 'Carly')
	GROUP BY Name, Sex
    ORDER BY Name;
    
-- Most popular names in the decade 1920s vs. 2010s

SELECT Name, SUM(Count) AS 'Total' FROM top_names_states
	WHERE Sex LIKE 'F'
    AND Year BETWEEN 1910 AND 1919
		GROUP BY Name
		ORDER BY SUM(Count) DESC
		LIMIT 30;
        
-- How many James and Maries of all times?

SELECT Name, SUM(Count)
	FROM top_names_states
		WHERE Name IN ('James', 'Mary')
    GROUP BY Name;


