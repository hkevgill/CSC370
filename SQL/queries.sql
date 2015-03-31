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
FROM ASSOCIATEDDEPARTURE JOIN PASSENGER USING(passID)
WHERE ((Insert gate here) = departureGate) AND ((Insert date here) = departureDate)
	UNION ALL
SELECT passID, name, dateOfBirth, placeOfBirth, citizenship
FROM ASSOCIATEDARRIVAL JOIN PASSENGER USING(passID)
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
FROM ASSOCIATEDDEPARTURE NATURAL JOIN ASSOCIATEDARRIVAL
WHERE (SYSDATE > departureDate) AND (SYSDATE < arrivalDate)

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
	SELECT 
	FROM(((SELECT departureGate AS flightGate, departureDate AS flightDate, departureStatus AS flightStatus
		FROM DEPARTURES)
			JOIN
		(SELECT plannedDepartureGate AS flightGate, plannedDepartureTime AS flightDate
		FROM OUTGOING)
			ON (DEPARTURES.flightGate = OUTGOING.flightGate) AND (DEPARTURES.flightDate = OUTGOING.flightDate))
				JOIN
		((SELECT arrivalGate AS flightGate, arrivalDate AS flightDate, arrivalStatus AS flightStatus
		FROM ARRIVALS)
			JOIN
		(SELECT plannedArrivalGate AS flightGate, plannedDepartureTime AS flightDate
		FROM INCOMING)
			ON (ARRIVALS.flightGate = INCOMING.flightGate) AND (ARRIVALS.flightGate = INCOMING.flightDate)))
)

CREATE VIEW DELAYS AS(
	SELECT source, destination, flightID, status
	FROM(FLIGHTS JOIN ALLFLIGHTSTATUS USING(flightID))

)



CREATE VIEW DELAYS AS(
	SELECT source, destination, flightID, count(status) AS numberOfDelays
	FROM
		(SELECT source, destination, flightID, status
		FROM
			((SELECT INCOMING.flightID AS flightID, ARRIVALS.arrivalStatus AS status
			FROM INCOMING JOIN ARRIVALS ON ((INCOMING.plannedArrivalTime = ARRIVALS.arrivalDate) AND (INCOMING.plannedArrivalGate = ARRIVALS.arrivalGate)))
				UNION ALL
			(SELECT OUTGOING.flightID AS flightID, DEPARTURES.departureStatus AS status
			FROM OUTGOING JOIN DEPARTURES ON ((OUTGOING.plannedDepartureTime = DEPARTURES.departureDate) AND (OUTGOING.plannedDepartureGate = DEPARTURES.departureGate))))
		WHERE status LIKE ('delayed to %'))
	GROUP BY flightID
)

SELECT *
FROM
	(SELECT source, destination, name, SUM(numberOfDelays) AS numDelays
	FROM
		((SELECT AIRLINES.name AS name, OPERATES.flightID AS flightID
		FROM AIRLINES JOIN OPERATES ON AIRLINES.airlineCode = OPERATES.airlineCode)
			NATURAL JOIN
		DELAYS)
	GROUP BY name
	ORDER BY source, destination, name, SUM(numberOfDelays) DESC)
WHERE ROWNUM <= 1