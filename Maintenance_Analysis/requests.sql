
-- Answer : 


--  Question 1 :
-- 1. what are the 3 elevators with the most breakdowns

SELECT e.name, COUNT(b.intervention_cost) AS number_breakdowns
FROM breakdowns AS b
JOIN elevators AS e 
ON b.elevator_id = e.id
GROUP By e.name --b.elevator_id
ORDER BY number_breakdowns 
DESC LIMIT(3) ;


--Question 2 : 
-- 2. for each elevator, when was the last visit done?

SELECT e.name,  MAX(visits.closed_at) 
FROM elevators AS e
INNER JOIN visits 
ON visits.elevator_id = e.id 
WHERE status = 'DONE'
GROUP BY e.name ;

--Question 3 :
-- 3. what is the elevator with the most "relapses"?
--    a "relapse" is a breakdown occuring on an elevator
--    that is 90 days away from the previous one at most



SELECT e.name, elevator_id, COUNT(date_lag) AS  relapses
	FROM (
		SELECT elevator_id,
		ABS(start_date - LAG(start_date)
		OVER (PARTITION BY elevator_id ORDER BY elevator_id)) AS date_lag
		FROM (
			SELECT * 
			FROM breakdowns 
			ORDER BY start_date ASC) AS breakdowns) AS date_lags
	INNER JOIN elevators AS e
	ON date_lags.elevator_id = e.id
	where date_lag < 90 
	GROUP BY e.name, date_lags.elevator_id
	ORDER BY  relapses DESC 
	LIMIT 10 ;
