4.
a)

"SELECT flightID
FROM(
	SELECT *
	FROM AIRLINES JOIN OPERATES ON AIRLINES.airlineCode = OPERATES.airlineCode 
	WHERE AIRLINES.name = " + airlineName + ")"

b)

"SELECT flightID
FROM FLIGHTS
WHERE source = " + location + " OR destination = " + location + "
"

c) 

"SELECT * " +
"FROM " +
  "((SELECT departureGate, departureDate, departureStatus AS Status " +
  "FROM DEPARTURES " +
  "WHERE (TO_DATE('" + timeOfDay + "', 'yyyy-mm-dd hh24:mi:ss') - departureDate) < (1/24) AND (TO_DATE('" + timeOfDay + "', 'yyyy-mm-dd hh24:mi:ss') - departureDate) > (-1/24)) " +
    "NATURAL FULL OUTER JOIN " +
  "(SELECT arrivalGate, arrivalDate, arrivalStatus AS Status " +
  "FROM ARRIVALS " +
  "WHERE ((arrivalDate - TO_DATE('" + timeOfDay + "', 'yyyy-mm-dd hh24:mi:ss')) < (1/24) AND (arrivalDate - TO_DATE('" + timeOfDay + "', 'yyyy-mm-dd hh24:mi:ss')) > (-1/24))))");

d)

"SELECT passID, name, dateOfBirth, placeOfBirth, citizenship
FROM ASSOCIATEDDEPARTURE JOIN PASSENGER USING(passID)
WHERE (" + gate + " = departureGate) AND (" + date + " = departureDate)
	UNION ALL
SELECT passID, name, dateOfBirth, placeOfBirth, citizenship
FROM ASSOCIATEDARRIVAL JOIN PASSENGER USING(passID)
WHERE (" + gate + " = arrivalGate) AND (" + date + " = arrivalDate)"

	
e)

"SELECT bagID " +
"FROM BOARDS " +
"WHERE passID = " + passID + " AND flightID = " + flightID


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
	ORDER BY COUNT(passID))
WHERE ROWNUM <= 3

d)

CREATE VIEW DELAYS AS(
	SELECT flightID, COUNT(status LIKE ('delayed to %')) AS numberOfDelays
	FROM
		((SELECT INCOMING.flightID AS flightID, ARRIVALS.arrivalStatus AS status
		FROM INCOMING JOIN ARRIVALS ON ((INCOMING.plannedArrivalTime = ARRIVALS.arrivalDate) AND (INCOMING.plannedArrivalGate = ARRIVALS.arrivalGate)))
			UNION ALL
		(SELECT OUTGOING.flightID AS flightID, DEPARTURES.departureStatus AS status
		FROM OUTGOING JOIN DEPARTURES ON ((OUTGOING.plannedDepartureTime = DEPARTURES.departureDate) AND (OUTGOING.plannedDepartureGate = DEPARTURES.departureGate))))
	GROUP BY flightID
)

SELECT *
FROM
	(SELECT name, SUM(numberOfDelays) AS numDelays
	FROM
		((SELECT AIRLINES.name AS name, OPERATES.flightID AS flightID
		FROM AIRLINES JOIN OPERATES ON AIRLINES.airlineCode = OPERATES.airlineCode)
			NATURAL JOIN
		DELAYS)
	GROUP BY name
	ORDER BY SUM(numberOfDelays) DESC)
WHERE ROWNUM <= 1