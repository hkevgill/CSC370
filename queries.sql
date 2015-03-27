a)

SELECT INCOMING.flightID AS f1, OUTGOING.flightID AS f2
FROM INCOMING, OUTGOING
WHERE plannedDepartureTime - plannedArrivalTime <= 3 AND plannedDepartureTime - plannedArrivalTime > 0

b)

c)