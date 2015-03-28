a)

SELECT INCOMING.flightID AS f1, OUTGOING.flightID AS f2
FROM INCOMING, OUTGOING
WHERE (plannedDepartureTime - plannedArrivalTime <= 0.125) AND (plannedDepartureTime - plannedArrivalTime > 0)

b)

SELECT passID
FROM ASSOCIATEDDEPARTURE NATURAL JOIN ASSOCIATEDARRIVAL
WHERE (SYSDATE > departureDate) AND (SYSDATE < arrivalDate)

c)