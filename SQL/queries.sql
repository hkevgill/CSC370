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

CREATE VIEW INCOMINGFLIGHTS AS(
  SELECT *
  FROM Incoming JOIN Flights USING(flightID)
)

CREATE VIEW OUTGOINGFLIGHTS AS(
  SELECT *
  FROM Outgoing JOIN Flights USING(flightID)
)

SELECT INCOMINGFLIGHTS.FLIGHTID AS f1, OUTGOINGFLIGHTS.FLIGHTID AS f2
FROM INCOMINGFLIGHTS JOIN OUTGOINGFLIGHTS ON(INCOMINGFLIGHTS.DESTINATION = OUTGOINGFLIGHTS.SOURCE)
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


Test Data

-- INSERT STATEMENTS
--- Airlines
INSERT INTO AIRLINES VALUES ("ACA","Air Canada","www.aircanada.com");
INSERT INTO AIRLINES VALUES ("SIA","Singapore Airlines","www.singaporeair.com");
INSERT INTO AIRLINES VALUES ("WJA","WestJet","www.aircanada.com");
INSERT INTO AIRLINES VALUES ("BAW","British Airways","www.britishairways.com");
INSERT INTO AIRLINES VALUES ("AFR","Air France","www.airfrance.co.uk");

-- Flights
INSERT INTO FLIGHTS VALUES (1,"AC100","Victoria","Vancouver");
INSERT INTO FLIGHTS VALUES (2,"AC200","Vancouver","Las Vegas");
INSERT INTO FLIGHTS VALUES (3,"SA100","Montreal","Vancouver");
INSERT INTO FLIGHTS VALUES (4,"SA200","Vancouver","Victoria");
INSERT INTO FLIGHTS VALUES (5,"WJ100","Victoria","Vancouver");
INSERT INTO FLIGHTS VALUES (6,"WJ200","Vancouver","Portland");
INSERT INTO FLIGHTS VALUES (7,"BA100","London","Vancouver");
INSERT INTO FLIGHTS VALUES (8,"BA200","Vancouver","Calgary");
INSERT INTO FLIGHTS VALUES (9,"AF100","Paris","Vancouver");
INSERT INTO FLIGHTS VALUES (10,"AF200","Vancouver","Victoria");

-- Incoming
INSERT INTO INCOMING VALUES (1,"2015-03-31 13:00:00","A1");
INSERT INTO INCOMING VALUES (3,"2015-03-31 15:00:00","A3");
INSERT INTO INCOMING VALUES (5,"2015-03-31 17:00:00","A5");
INSERT INTO INCOMING VALUES (7,"2015-03-31 19:00:00","A7");
INSERT INTO INCOMING VALUES (9,"2015-03-31 21:00:00","A9");

-- Outgoing
INSERT INTO OUTGOING VALUES (2,"2015-03-31 14:00:00","B1");
INSERT INTO OUTGOING VALUES (4,"2015-03-31 16:00:00","B3");
INSERT INTO OUTGOING VALUES (6,"2015-03-31 18:00:00","B5");
INSERT INTO OUTGOING VALUES (8,"2015-03-31 20:00:00","B7");
INSERT INTO OUTGOING VALUES (10,"2015-03-31 22:00:00","B9");

-- PlaneModels
INSERT INTO PLANEMODELS VALUES ("A310",220);
INSERT INTO PLANEMODELS VALUES ("A320",150);
INSERT INTO PLANEMODELS VALUES ("A330",300);
INSERT INTO PLANEMODELS VALUES ("A340",359);
INSERT INTO PLANEMODELS VALUES ("A380",853);
INSERT INTO PLANEMODELS VALUES ("B712",106);
INSERT INTO PLANEMODELS VALUES ("B722",131);
INSERT INTO PLANEMODELS VALUES ("B733",149);
INSERT INTO PLANEMODELS VALUES ("B744",345);
INSERT INTO PLANEMODELS VALUES ("B762",252);
INSERT INTO PLANEMODELS VALUES ("B772",451);

-- Passengers
INSERT INTO PASSENGERS VALUES (1000,"Chris Cook","1988-07-25 00:00:00","North Vancouver","Canadian");
INSERT INTO PASSENGERS VALUES (1001,"Kevin","1999-01-01 00:00:00","North Vancouver","Canadian");
INSERT INTO PASSENGERS VALUES (1002,"Brenden","1999-01-01 00:00:00","North Vancouver","Canadian");
INSERT INTO PASSENGERS VALUES (1003,"Niels Bohr","1885-10-07 00:00:00","Copenhagen","Danish");
INSERT INTO PASSENGERS VALUES (1004,"Albert Einstein","1879-03-14 00:00:00","Wurttemberg","Swiss");
INSERT INTO PASSENGERS VALUES (1005,"Stephen Hawking","1942-01-08 00:00:00","Oxford","British");
INSERT INTO PASSENGERS VALUES (1006,"Isaac Newton","1642-12-25 00:00:00","Lincolnshire","English");
INSERT INTO PASSENGERS VALUES (1007,"Galileo Galilei","1564-02-15 00:00:00","Florence","Italian");
INSERT INTO PASSENGERS VALUES (1008,"Marie Curie","1867-11-07 00:00:00","Warsaw","Polish");
INSERT INTO PASSENGERS VALUES (1009,"Robert Hooke","1635-07-28 00:00:00","Isle of Wright","English");
INSERT INTO PASSENGERS VALUES (1010,"Richard Feynman","1918-05-11 00:00:00","Los Angeles","American");
INSERT INTO PASSENGERS VALUES (1011,"Michael Faraday","1791-09-22 00:00:00","Newington Butts","British");
INSERT INTO PASSENGERS VALUES (1012,"Max Planck","1858-04-23 00:00:00","Lower Saxony","German");
INSERT INTO PASSENGERS VALUES (1013,"Erwin Schrodinger","1858-04-23 00:00:00","Vienna","Austrian");
INSERT INTO PASSENGERS VALUES (1014,"James Clerk Maxwell","1831-06-13 00:00:00","Edinburgh","Scottish");

