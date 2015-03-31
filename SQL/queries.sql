4.
a)

SELECT flightID
FROM(
	SELECT *
	FROM AIRLINES JOIN OPERATES ON AIRLINES.airlineCode = OPERATES.airlineCode 
	WHERE AIRLINES.name = (Insert airline here))

b)

SELECT flightID
FROM FLIGHTS
WHERE source = (Insert location here) OR destination = (Insert location here)

c) 

SELECT *
FROM
  ((SELECT departureGate, departureDate, departureStatus AS Status
  FROM DEPARTURES
  WHERE ((Insert time of day here) - departureDate) < (1/24) AND ((Insert time of day here) - departureDate) > (-1/24))
    NATURAL FULL OUTER JOIN
  (SELECT arrivalGate, arrivalDate, arrivalStatus AS Status
  FROM ARRIVALS
  WHERE ((arrivalDate - (Insert time of day here)) < (1/24) AND (arrivalDate - (Insert time of day here)) > (-1/24))));

d)

SELECT passID, name, dateOfBirth, placeOfBirth, citizenship
FROM ASSOCIATEDDEPARTURE JOIN PASSENGERS USING(passID)
WHERE ((Insert gate here) = departureGate) AND ((Insert date here) = departureDate)
	UNION ALL
SELECT passID, name, dateOfBirth, placeOfBirth, citizenship
FROM ASSOCIATEDARRIVAL JOIN PASSENGERS USING(passID)
WHERE ((Insert gate here) = arrivalGate) AND ((Insert date here) = arrivalDate)

e)

SELECT bagID
FROM BOARDS
WHERE passID = (Insert flightID here) AND flightID = (Insert flightID here)


5.
a)

SELECT INCOMING.flightID AS f1, OUTGOING.flightID AS f2
FROM INCOMING, OUTGOING
WHERE (plannedDepartureTime - plannedArrivalTime <= 0.125) AND (plannedDepartureTime - plannedArrivalTime > 0)

b)

SELECT passID
FROM BOARDS 
		NATURAL JOIN 
	((SELECT * 
	FROM (FLIGHTS JOIN INCOMING USING(flightID))
	WHERE SYSDATE < plannedArrivalTime AND SYSDATE > plannedArrivalTime - duration)
		UNION ALL
	(SELECT *
	FROM (FLIGHTS JOIN OUTGOING USING(flightID))
	WHERE SYSDATE > plannedDepartureTime AND SYSDATE < plannedDepartureTime + duration))

c)

SELECT *
FROM(
	SELECT passID, COUNT(passID) AS numberOfFlights
	FROM BOARDS
	GROUP BY passID
	ORDER BY COUNT(passID) DESC)
WHERE ROWNUM <= 3

d)

CREATE VIEW ALLFLIGHTSTATUS AS(
	SELECT *
	FROM(SELECT *
		FROM (SELECT departureGate AS flightGate, departureDate AS flightDate, departureStatus AS flightStatus
			FROM DEPARTURES)
				NATURAL JOIN
			(SELECT flightID, plannedDepartureGate AS flightGate, plannedDepartureTime AS flightDate
			FROM OUTGOING))
			UNION ALL
		(SELECT *
		FROM (SELECT arrivalGate AS flightGate, arrivalDate AS flightDate, arrivalStatus AS flightStatus
			FROM ARRIVALS)
				NATURAL JOIN
			(SELECT flightID, plannedArrivalGate AS flightGate, plannedArrivalTime AS flightDate
			FROM INCOMING))
)

CREATE VIEW DELAYS AS(
	SELECT source, destination, flightID, flightStatus
	FROM(FLIGHTS JOIN ALLFLIGHTSTATUS USING(flightID))
	WHERE flightStatus LIKE ('delayed to %')
)

CREATE VIEW ROUTEDELAYS AS(
	SELECT source, destination, name, COUNT(name) as numDelays
	FROM(DELAYS 
			JOIN 
		(SELECT name, flightID
		FROM AIRLINES JOIN OPERATES USING(airlineCode))
			USING(flightID))
	GROUP BY source, destination, name
)

SELECT source, destination, MAX(name) as airlineName, MAX(numDelays) as maxDelays
	FROM ROUTEDELAYS
	GROUP BY source, destination


-- Bonus

SELECT passID, name, timesFlown
FROM(SELECT *
	FROM(
		(SELECT passID, COUNT(passID) AS timesFlown
		FROM ((SELECT *
			FROM AIRLINES JOIN OPERATES USING(airlineCode)
			WHERE AIRLINES.name = 'Air Canada')
				JOIN
			(SELECT *
			FROM PASSENGERS JOIN BOARDS USING(passID))
				USING(flightID))
		GROUP BY passID)
			JOIN PASSENGERS USING(passID)
		)
	ORDER BY timesFlown DESC)
WHERE ROWNUM <= 1

