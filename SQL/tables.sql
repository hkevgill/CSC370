DROP TABLE OPERATES;
DROP TABLE BOARDS;
DROP TABLE BELONGTO;
DROP TABLE ASSOCIATEDDEPARTURE;
DROP TABLE ASSOCIATEDARRIVAL;
DROP TABLE AIRLINES;
DROP TABLE FLIGHTS;
DROP TABLE INCOMING;
DROP TABLE OUTGOING;
DROP TABLE PLANEMODELS;
DROP TABLE PASSENGERS;
DROP TABLE BAGGAGE;
DROP TABLE CLASS;
DROP TABLE FIRSTCLASS;
DROP TABLE REGULARCLASS;
DROP TABLE SPECIALNEEDS;
DROP TABLE INFANT;
DROP TABLE DEPARTURES;
DROP TABLE ARRIVALS;

-- ENTITIES

CREATE TABLE AIRLINES(
	airlineCode VARCHAR(10) PRIMARY KEY,
	name VARCHAR(40),
	website VARCHAR(100)
);

CREATE TABLE FLIGHTS(
	flightID INT PRIMARY KEY,
	flightNumber VARCHAR(10),
	source VARCHAR(100),
	destination VARCHAR(100),
	duration INT
);

CREATE TABLE INCOMING(
	flightID INT,
	plannedArrivalTime DATE,
	plannedArrivalGate VARCHAR(10),
	CONSTRAINT fk_incoming FOREIGN KEY(flightID) REFERENCES FLIGHTS(flightID)
		ON DELETE CASCADE
);

CREATE TABLE OUTGOING(
	flightID INT,
	plannedDepartureTime DATE,
	plannedDepartureGate VARCHAR(10),
	CONSTRAINT fk_outgoing FOREIGN KEY(flightID) REFERENCES FLIGHTS(flightID)
		ON DELETE CASCADE
);

CREATE TABLE PLANEMODELS(
	planeCode VARCHAR(50) PRIMARY KEY,
	capacity INT
);

CREATE TABLE PASSENGERS(
	passID INT PRIMARY KEY,
	name VARCHAR(40),
	dateOfBirth DATE,
	placeOfBirth VARCHAR(100),
	citizenship VARCHAR(100)
);

CREATE TABLE BAGGAGE(
	bagID INT PRIMARY KEY
);

CREATE TABLE CLASS(
	classID INT PRIMARY KEY
);

CREATE TABLE FIRSTCLASS(
	classID INT,
	dessert VARCHAR(100),
	mealChoice VARCHAR(100),
	partyFavors VARCHAR(100),
	numberOfPillows INT,
	winePreference VARCHAR(100),
	CONSTRAINT fk_firstclass FOREIGN KEY(classID) REFERENCES CLASS(classID)
		ON DELETE CASCADE
);

CREATE TABLE REGULARCLASS(
	classID INT,
	mealChoice VARCHAR(100),
	CONSTRAINT fk_regularclass FOREIGN KEY(classID) REFERENCES CLASS(classID)
		ON DELETE CASCADE
);

CREATE TABLE SPECIALNEEDS(
	classID INT,
	disability VARCHAR(300),
	mealChoice VARCHAR(100),
	CONSTRAINT fk_specialneeds FOREIGN KEY(classID) REFERENCES CLASS(classID)
		ON DELETE CASCADE
);

CREATE TABLE INFANT(
	classID INT,
	mealChoice VARCHAR(100),
	toyChoice VARCHAR(100),
	CONSTRAINT fk_infant FOREIGN KEY(classID) REFERENCES CLASS(classID)
		ON DELETE CASCADE
);

CREATE TABLE DEPARTURES(
	departureGate VARCHAR(10),
	departureDate DATE,
	departureStatus VARCHAR(100),
	CONSTRAINT departure_check_1 CHECK(departureStatus LIKE 'departed at __:__' OR departureStatus LIKE 'delayed to __:__'),
	PRIMARY KEY(departureGate, departureDate)
);

CREATE TABLE ARRIVALS(
	arrivalGate VARCHAR(10),
	arrivalDate DATE,
	arrivalStatus VARCHAR(100),
	 CONSTRAINT arrival_check CHECK(arrivalStatus LIKE 'arrived at __:__' OR arrivalStatus LIKE 'delayed to __:__'),
	PRIMARY KEY(arrivalGate, arrivalDate)
);


-- RELATIONSHIPS

CREATE TABLE OPERATES(
	airlineCode VARCHAR(10),
	flightID INT,
	planeCode VARCHAR(50),
	CONSTRAINT fk_operates_airlinecode FOREIGN KEY(airlineCode) REFERENCES AIRLINES(airlineCode)
		ON DELETE CASCADE,
	CONSTRAINT fk_operates_flightid FOREIGN KEY(flightID) REFERENCES FLIGHTS(flightID)
		ON DELETE CASCADE,
	CONSTRAINT fk_operates_planeCode FOREIGN KEY(planeCode) REFERENCES PLANEMODELS(planeCode)
		ON DELETE CASCADE
);

CREATE TABLE BOARDS(
	flightID INT,
	bagID INT,
	passID INT,
	CONSTRAINT fk_boards_flightid FOREIGN KEY(flightID) REFERENCES FLIGHTS(flightID)
		ON DELETE CASCADE,
	CONSTRAINT fk_boards_bagid FOREIGN KEY(bagID) REFERENCES BAGGAGE(bagID)
		ON DELETE CASCADE,
	CONSTRAINT fk_boards_passid FOREIGN KEY(passID) REFERENCES PASSENGERS(passID)
		ON DELETE CASCADE
);

CREATE TABLE BELONGTO(
	passID INT,
	classID INT,
	CONSTRAINT fk_belongto_passid FOREIGN KEY(passID) REFERENCES PASSENGERS(passID)
		ON DELETE CASCADE,
	CONSTRAINT fk_belongto_classid FOREIGN KEY(classID) REFERENCES CLASS(classID)
		ON DELETE CASCADE
);

CREATE TABLE ASSOCIATEDDEPARTURE(
	passID INT,
	departureGate VARCHAR(10),
	departureDate DATE,
	CONSTRAINT fk_associateddeparture_passid FOREIGN KEY(passID) REFERENCES PASSENGERS(passID)
		ON DELETE CASCADE,
	CONSTRAINT fk_associateddeparture FOREIGN KEY(departureGate, departureDate) REFERENCES DEPARTURES(departureGate, departureDate)
		ON DELETE CASCADE
);

CREATE TABLE ASSOCIATEDARRIVAL(
	passID INT,
	arrivalGate VARCHAR(10),
	arrivalDate DATE,
	CONSTRAINT fk_associatedarrival_passid FOREIGN KEY(passID) REFERENCES PASSENGERS(passID)
		ON DELETE CASCADE,
	CONSTRAINT fk_associatedarrival FOREIGN KEY(arrivalGate, arrivalDate) REFERENCES ARRIVALS(arrivalGate, arrivalDate)
		ON DELETE CASCADE
);



-- INSERT STATEMENTS
--- AIRLINES
INSERT INTO AIRLINES(airlineCode,name,website) VALUES ('ACA','Air Canada','www.aircanada.com');
INSERT INTO AIRLINES(airlineCode,name,website) VALUES ('SIA','Singapore Airlines','www.singaporeair.com');
INSERT INTO AIRLINES(airlineCode,name,website) VALUES ('WJA','WestJet','www.aircanada.com');
INSERT INTO AIRLINES(airlineCode,name,website) VALUES ('BAW','British Airways','www.britishairways.com');
INSERT INTO AIRLINES(airlineCode,name,website) VALUES ('AFR','Air France','www.airfrance.co.uk');

-- FLIGHTS
INSERT INTO FLIGHTS(flightID,flightNumber,source,destination, duration) VALUES (1,'AC100','Victoria','Vancouver',1/24);
INSERT INTO FLIGHTS(flightID,flightNumber,source,destination, duration) VALUES (2,'AC200','Vancouver','Las Vegas',4/24);
INSERT INTO FLIGHTS(flightID,flightNumber,source,destination, duration) VALUES (3,'SA100','Montreal','Vancouver',5/24),;
INSERT INTO FLIGHTS(flightID,flightNumber,source,destination, duration) VALUES (4,'SA200','Vancouver','Victoria',1/24);
INSERT INTO FLIGHTS(flightID,flightNumber,source,destination, duration) VALUES (5,'WJ100','Victoria','Vancouver',1/24);
INSERT INTO FLIGHTS(flightID,flightNumber,source,destination, duration) VALUES (6,'WJ200','Vancouver','Portland',2/24);
INSERT INTO FLIGHTS(flightID,flightNumber,source,destination, duration) VALUES (7,'BA100','London','Vancouver',16/24);
INSERT INTO FLIGHTS(flightID,flightNumber,source,destination, duration) VALUES (8,'BA200','Vancouver','Calgary',2/24);
INSERT INTO FLIGHTS(flightID,flightNumber,source,destination, duration) VALUES (9,'AF100','Paris','Vancouver',16/24);
INSERT INTO FLIGHTS(flightID,flightNumber,source,destination, duration) VALUES (10,'AF200','Vancouver','Victoria',1/24);
INSERT INTO FLIGHTS(flightID,flightNumber,source,destination, duration) VALUES (98,'AF998','Victoria','Vancouver',1/24);
INSERT INTO FLIGHTS(flightID,flightNumber,source,destination, duration) VALUES (99,'AF999','Vancouver','Las Vegas',4/24);

-- INCOMING
INSERT INTO INCOMING(flightID,plannedArrivalTime,plannedArrivalGate) VALUES (1,TO_DATE('2015-03-31 11:00:00', 'yyyy-mm-dd hh24:mi:ss'),'A1');
INSERT INTO INCOMING(flightID,plannedArrivalTime,plannedArrivalGate) VALUES (3,TO_DATE('2015-03-31 13:00:00', 'yyyy-mm-dd hh24:mi:ss'),'A3');
INSERT INTO INCOMING(flightID,plannedArrivalTime,plannedArrivalGate) VALUES (5,TO_DATE('2015-03-31 15:00:00', 'yyyy-mm-dd hh24:mi:ss'),'A5');
INSERT INTO INCOMING(flightID,plannedArrivalTime,plannedArrivalGate) VALUES (7,TO_DATE('2015-03-31 17:00:00', 'yyyy-mm-dd hh24:mi:ss'),'A7');
INSERT INTO INCOMING(flightID,plannedArrivalTime,plannedArrivalGate) VALUES (9,TO_DATE('2015-03-31 19:00:00', 'yyyy-mm-dd hh24:mi:ss'),'A9');
INSERT INTO INCOMING(flightID,plannedArrivalTime,plannedArrivalGate) VALUES (98,TO_DATE('2015-03-30 17:30:00', 'yyyy-mm-dd hh24:mi:ss'),'A98');

-- OUTGOING
INSERT INTO OUTGOING(flightID,plannedDepartureTime,plannedDepartureGate) VALUES (2,TO_DATE('2015-03-31 12:00:00', 'yyyy-mm-dd hh24:mi:ss'),'B2');
INSERT INTO OUTGOING(flightID,plannedDepartureTime,plannedDepartureGate) VALUES (4,TO_DATE('2015-03-31 14:00:00', 'yyyy-mm-dd hh24:mi:ss'),'B4');
INSERT INTO OUTGOING(flightID,plannedDepartureTime,plannedDepartureGate) VALUES (6,TO_DATE('2015-03-31 16:00:00', 'yyyy-mm-dd hh24:mi:ss'),'B6');
INSERT INTO OUTGOING(flightID,plannedDepartureTime,plannedDepartureGate) VALUES (8,TO_DATE('2015-03-31 18:00:00', 'yyyy-mm-dd hh24:mi:ss'),'B8');
INSERT INTO OUTGOING(flightID,plannedDepartureTime,plannedDepartureGate) VALUES (10,TO_DATE('2015-03-31 20:00:00', 'yyyy-mm-dd hh24:mi:ss'),'B10');
INSERT INTO OUTGOING(flightID,plannedDepartureTime,plannedDepartureGate) VALUES (99,TO_DATE('2015-03-30 18:30:00', 'yyyy-mm-dd hh24:mi:ss'),'B99');

-- PLANEMODELS
INSERT INTO PLANEMODELS(planeCode,capacity) VALUES ('A310',220);
INSERT INTO PLANEMODELS(planeCode,capacity) VALUES ('A320',150);
INSERT INTO PLANEMODELS(planeCode,capacity) VALUES ('A330',300);
INSERT INTO PLANEMODELS(planeCode,capacity) VALUES ('A340',359);
INSERT INTO PLANEMODELS(planeCode,capacity) VALUES ('A380',853);
INSERT INTO PLANEMODELS(planeCode,capacity) VALUES ('B712',106);
INSERT INTO PLANEMODELS(planeCode,capacity) VALUES ('B722',131);
INSERT INTO PLANEMODELS(planeCode,capacity) VALUES ('B733',149);
INSERT INTO PLANEMODELS(planeCode,capacity) VALUES ('B744',345);
INSERT INTO PLANEMODELS(planeCode,capacity) VALUES ('B762',252);
INSERT INTO PLANEMODELS(planeCode,capacity) VALUES ('B772',451);

-- PASSENGERS
INSERT INTO PASSENGERS(passID,name,dateOfBirth,placeOfBirth,citizenship) VALUES (1001,'Chris Cook',TO_DATE('1988-07-25 00:00:00', 'yyyy-mm-dd hh24:mi:ss'),'North Vancouver','Canadian');
INSERT INTO PASSENGERS(passID,name,dateOfBirth,placeOfBirth,citizenship) VALUES (1002,'Kevin Gill',TO_DATE('1993-01-10 00:00:00', 'yyyy-mm-dd hh24:mi:ss'),'Duncan','Canadian');
INSERT INTO PASSENGERS(passID,name,dateOfBirth,placeOfBirth,citizenship) VALUES (1003,'Brendan Beach',TO_DATE('1994-09-28 00:00:00', 'yyyy-mm-dd hh24:mi:ss'),'Victoria','Canadian');
INSERT INTO PASSENGERS(passID,name,dateOfBirth,placeOfBirth,citizenship) VALUES (1004,'Niels Bohr',TO_DATE('1885-10-07 00:00:00', 'yyyy-mm-dd hh24:mi:ss'),'Copenhagen','Danish');
INSERT INTO PASSENGERS(passID,name,dateOfBirth,placeOfBirth,citizenship) VALUES (1005,'Albert Einstein',TO_DATE('1879-03-14 00:00:00', 'yyyy-mm-dd hh24:mi:ss'),'Wurttemberg','Swiss');
INSERT INTO PASSENGERS(passID,name,dateOfBirth,placeOfBirth,citizenship) VALUES (1006,'Stephen Hawking',TO_DATE('1942-01-08 00:00:00', 'yyyy-mm-dd hh24:mi:ss'),'Oxford','British');
INSERT INTO PASSENGERS(passID,name,dateOfBirth,placeOfBirth,citizenship) VALUES (1007,'Isaac Newton',TO_DATE('1642-12-25 00:00:00', 'yyyy-mm-dd hh24:mi:ss'),'Lincolnshire','English');
INSERT INTO PASSENGERS(passID,name,dateOfBirth,placeOfBirth,citizenship) VALUES (1008,'Galileo Galilei',TO_DATE('1564-02-15 00:00:00', 'yyyy-mm-dd hh24:mi:ss'),'Florence','Italian');
INSERT INTO PASSENGERS(passID,name,dateOfBirth,placeOfBirth,citizenship) VALUES (1009,'Marie Curie',TO_DATE('1867-11-07 00:00:00', 'yyyy-mm-dd hh24:mi:ss'),'Warsaw','Polish');
INSERT INTO PASSENGERS(passID,name,dateOfBirth,placeOfBirth,citizenship) VALUES (1010,'Robert Hooke',TO_DATE('1635-07-28 00:00:00', 'yyyy-mm-dd hh24:mi:ss'),'Isle of Wright','English');
INSERT INTO PASSENGERS(passID,name,dateOfBirth,placeOfBirth,citizenship) VALUES (1011,'Richard Feynman',TO_DATE('1918-05-11 00:00:00', 'yyyy-mm-dd hh24:mi:ss'),'Los Angeles','American');
INSERT INTO PASSENGERS(passID,name,dateOfBirth,placeOfBirth,citizenship) VALUES (1012,'Michael Faraday',TO_DATE('1791-09-22 00:00:00', 'yyyy-mm-dd hh24:mi:ss'),'Newington Butts','British');
INSERT INTO PASSENGERS(passID,name,dateOfBirth,placeOfBirth,citizenship) VALUES (1013,'Max Planck',TO_DATE('1858-04-23 00:00:00', 'yyyy-mm-dd hh24:mi:ss'),'Lower Saxony','German');
INSERT INTO PASSENGERS(passID,name,dateOfBirth,placeOfBirth,citizenship) VALUES (1014,'Erwin Schrodinger',TO_DATE('1858-04-23 00:00:00', 'yyyy-mm-dd hh24:mi:ss'),'Vienna','Austrian');
INSERT INTO PASSENGERS(passID,name,dateOfBirth,placeOfBirth,citizenship) VALUES (1015,'James Clerk Maxwell',TO_DATE('1831-06-13 00:00:00', 'yyyy-mm-dd hh24:mi:ss'),'Edinburgh','Scottish');

-- BAGGAGE
INSERT INTO BAGGAGE(bagID) VALUES (1101);
INSERT INTO BAGGAGE(bagID) VALUES (1102);
INSERT INTO BAGGAGE(bagID) VALUES (1103);
INSERT INTO BAGGAGE(bagID) VALUES (1104);
INSERT INTO BAGGAGE(bagID) VALUES (1105);
INSERT INTO BAGGAGE(bagID) VALUES (1106);
INSERT INTO BAGGAGE(bagID) VALUES (1107);
INSERT INTO BAGGAGE(bagID) VALUES (1108);
INSERT INTO BAGGAGE(bagID) VALUES (1109);
INSERT INTO BAGGAGE(bagID) VALUES (1110);
INSERT INTO BAGGAGE(bagID) VALUES (1111);
INSERT INTO BAGGAGE(bagID) VALUES (1112);
INSERT INTO BAGGAGE(bagID) VALUES (1113);
INSERT INTO BAGGAGE(bagID) VALUES (1114);
INSERT INTO BAGGAGE(bagID) VALUES (1115);
INSERT INTO BAGGAGE(bagID) VALUES (1198);
INSERT INTO BAGGAGE(bagID) VALUES (1199);

-- CLASS
INSERT INTO CLASS(classID) VALUES (1);
INSERT INTO CLASS(classID) VALUES (2);
INSERT INTO CLASS(classID) VALUES (3);
INSERT INTO CLASS(classID) VALUES (4);
INSERT INTO CLASS(classID) VALUES (5);
INSERT INTO CLASS(classID) VALUES (6);
INSERT INTO CLASS(classID) VALUES (7);
INSERT INTO CLASS(classID) VALUES (8);
INSERT INTO CLASS(classID) VALUES (9);
INSERT INTO CLASS(classID) VALUES (10);
INSERT INTO CLASS(classID) VALUES (11);
INSERT INTO CLASS(classID) VALUES (12);
INSERT INTO CLASS(classID) VALUES (13);
INSERT INTO CLASS(classID) VALUES (14);
INSERT INTO CLASS(classID) VALUES (15);

-- FIRSTCLASS
INSERT INTO FIRSTCLASS(classID,dessert,mealChoice,partyFavors,numberOfPillows,winePreference) VALUES (1,'Chocolate Terrine','Kobe Tartare','8oz of Mexican black-tar heroin',13,'1938 Montrachet, 1942 Le Pan');
INSERT INTO FIRSTCLASS(classID,dessert,mealChoice,partyFavors,numberOfPillows,winePreference) VALUES (2,'Buche De Noel','Prime Rib','Vicodin',6,'Screaming Eagle Cabernet Sauvignon');

-- REGULARCLASS
INSERT INTO REGULARCLASS(classID,mealChoice) VALUES (3,'Mashed Potatoes');
INSERT INTO REGULARCLASS(classID,mealChoice) VALUES (4,'Mashed Potatoes');
INSERT INTO REGULARCLASS(classID,mealChoice) VALUES (5,'Mashed Potatoes');
INSERT INTO REGULARCLASS(classID,mealChoice) VALUES (6,'Mashed Potatoes');
INSERT INTO REGULARCLASS(classID,mealChoice) VALUES (7,'Mashed Potatoes');
INSERT INTO REGULARCLASS(classID,mealChoice) VALUES (8,'Mashed Potatoes');
INSERT INTO REGULARCLASS(classID,mealChoice) VALUES (9,'Mashed Potatoes');
INSERT INTO REGULARCLASS(classID,mealChoice) VALUES (10,'Mashed Potatoes');
INSERT INTO REGULARCLASS(classID,mealChoice) VALUES (11,'Mashed Potatoes');
INSERT INTO REGULARCLASS(classID,mealChoice) VALUES (12,'Mashed Potatoes');
INSERT INTO REGULARCLASS(classID,mealChoice) VALUES (13,'Mashed Potatoes');
INSERT INTO REGULARCLASS(classID,mealChoice) VALUES (14,'Mashed Potatoes');
INSERT INTO REGULARCLASS(classID,mealChoice) VALUES (15,'Mashed Potatoes');

-- DEPARTURES
INSERT INTO DEPARTURES(departureGate,departureDate,departureStatus) VALUES ('B2',TO_DATE('2015-03-31 12:00:00', 'yyyy-mm-dd hh24:mi:ss'),'delayed to 12:15');
INSERT INTO DEPARTURES(departureGate,departureDate,departureStatus) VALUES ('B4',TO_DATE('2015-03-31 14:00:00', 'yyyy-mm-dd hh24:mi:ss'),'delayed to 14:15');
INSERT INTO DEPARTURES(departureGate,departureDate,departureStatus) VALUES ('B6',TO_DATE('2015-03-31 16:00:00', 'yyyy-mm-dd hh24:mi:ss'),'delayed to 16:15');
INSERT INTO DEPARTURES(departureGate,departureDate,departureStatus) VALUES ('B8',TO_DATE('2015-03-31 18:00:00', 'yyyy-mm-dd hh24:mi:ss'),'delayed to 18:15');
INSERT INTO DEPARTURES(departureGate,departureDate,departureStatus) VALUES ('B10',TO_DATE('2015-03-31 20:00:00', 'yyyy-mm-dd hh24:mi:ss'),'delayed to 20:15');
INSERT INTO DEPARTURES(departureGate,departureDate,departureStatus) VALUES ('B99',TO_DATE('2015-03-30 18:30:00', 'yyyy-mm-dd hh24:mi:ss'),'delayed to 18:45');

-- ARRIVALS
INSERT INTO ARRIVALS(arrivalGate,arrivalDate,arrivalStatus) VALUES ('A1',TO_DATE('2015-03-31 11:00:00', 'yyyy-mm-dd hh24:mi:ss'),'delayed to 11:15');
INSERT INTO ARRIVALS(arrivalGate,arrivalDate,arrivalStatus) VALUES ('A3',TO_DATE('2015-03-31 13:00:00', 'yyyy-mm-dd hh24:mi:ss'),'delayed to 13:15');
INSERT INTO ARRIVALS(arrivalGate,arrivalDate,arrivalStatus) VALUES ('A5',TO_DATE('2015-03-31 15:00:00', 'yyyy-mm-dd hh24:mi:ss'),'delayed to 15:15');
INSERT INTO ARRIVALS(arrivalGate,arrivalDate,arrivalStatus) VALUES ('A7',TO_DATE('2015-03-31 17:00:00', 'yyyy-mm-dd hh24:mi:ss'),'delayed to 17:15');
INSERT INTO ARRIVALS(arrivalGate,arrivalDate,arrivalStatus) VALUES ('A9',TO_DATE('2015-03-31 19:00:00', 'yyyy-mm-dd hh24:mi:ss'),'delayed to 19:15');
INSERT INTO ARRIVALS(arrivalGate,arrivalDate,arrivalStatus) VALUES ('A98',TO_DATE('2015-03-30 17:30:00', 'yyyy-mm-dd hh24:mi:ss'),'delayed to 17:45');

-- OPERATES
INSERT INTO OPERATES(airlineCode,flightID,planeCode) VALUES ('ACA',1,'B712');
INSERT INTO OPERATES(airlineCode,flightID,planeCode) VALUES ('ACA',2,'B744');
INSERT INTO OPERATES(airlineCode,flightID,planeCode) VALUES ('SIA',3,'A330');
INSERT INTO OPERATES(airlineCode,flightID,planeCode) VALUES ('SIA',4,'B712');
INSERT INTO OPERATES(airlineCode,flightID,planeCode) VALUES ('WJA',5,'B712');
INSERT INTO OPERATES(airlineCode,flightID,planeCode) VALUES ('WJA',6,'A310');
INSERT INTO OPERATES(airlineCode,flightID,planeCode) VALUES ('BAW',7,'A340');
INSERT INTO OPERATES(airlineCode,flightID,planeCode) VALUES ('BAW',8,'A310');
INSERT INTO OPERATES(airlineCode,flightID,planeCode) VALUES ('AFR',9,'A340');
INSERT INTO OPERATES(airlineCode,flightID,planeCode) VALUES ('AFR',10,'B712');
INSERT INTO OPERATES(airlineCode,flightID,planeCode) VALUES ('ACA',98,'A310');
INSERT INTO OPERATES(airlineCode,flightID,planeCode) VALUES ('ACA',99,'A320');

-- BOARDS
INSERT INTO BOARDS(flightID,bagID,passID) VALUES (1,1101,1001);
INSERT INTO BOARDS(flightID,bagID,passID) VALUES (2,1102,1002);
INSERT INTO BOARDS(flightID,bagID,passID) VALUES (3,1103,1003);
INSERT INTO BOARDS(flightID,bagID,passID) VALUES (4,1104,1004);
INSERT INTO BOARDS(flightID,bagID,passID) VALUES (5,1105,1005);
INSERT INTO BOARDS(flightID,bagID,passID) VALUES (6,1106,1006);
INSERT INTO BOARDS(flightID,bagID,passID) VALUES (7,1107,1007);
INSERT INTO BOARDS(flightID,bagID,passID) VALUES (8,1108,1008);
INSERT INTO BOARDS(flightID,bagID,passID) VALUES (9,1109,1009);
INSERT INTO BOARDS(flightID,bagID,passID) VALUES (10,1110,1010);
INSERT INTO BOARDS(flightID,bagID,passID) VALUES (1,1111,1011);
INSERT INTO BOARDS(flightID,bagID,passID) VALUES (2,1112,1012);
INSERT INTO BOARDS(flightID,bagID,passID) VALUES (3,1113,1013);
INSERT INTO BOARDS(flightID,bagID,passID) VALUES (4,1114,1014);
INSERT INTO BOARDS(flightID,bagID,passID) VALUES (5,1115,1015);
INSERT INTO BOARDS(flightID,bagID,passID) VALUES (98,1198,1001);
INSERT INTO BOARDS(flightID,bagID,passID) VALUES (99,1199,1002);

-- BELONGTO
INSERT INTO BELONGTO(passID,classID) VALUES (1001,1);
INSERT INTO BELONGTO(passID,classID) VALUES (1002,2);
INSERT INTO BELONGTO(passID,classID) VALUES (1003,3);
INSERT INTO BELONGTO(passID,classID) VALUES (1004,4);
INSERT INTO BELONGTO(passID,classID) VALUES (1005,5);
INSERT INTO BELONGTO(passID,classID) VALUES (1006,6);
INSERT INTO BELONGTO(passID,classID) VALUES (1007,7);
INSERT INTO BELONGTO(passID,classID) VALUES (1008,8);
INSERT INTO BELONGTO(passID,classID) VALUES (1009,9);
INSERT INTO BELONGTO(passID,classID) VALUES (1010,10);
INSERT INTO BELONGTO(passID,classID) VALUES (1011,11);
INSERT INTO BELONGTO(passID,classID) VALUES (1012,12);
INSERT INTO BELONGTO(passID,classID) VALUES (1013,13);
INSERT INTO BELONGTO(passID,classID) VALUES (1014,14);
INSERT INTO BELONGTO(passID,classID) VALUES (1015,15);

-- ASSOCIATEDDEPARTURE
INSERT INTO ASSOCIATEDDEPARTURE(passID,departureGate,departureDate) VALUES (1002,'B2',TO_DATE('2015-03-31 12:00:00', 'yyyy-mm-dd hh24:mi:ss'));
INSERT INTO ASSOCIATEDDEPARTURE(passID,departureGate,departureDate) VALUES (1004,'B4',TO_DATE('2015-03-31 14:00:00', 'yyyy-mm-dd hh24:mi:ss'));
INSERT INTO ASSOCIATEDDEPARTURE(passID,departureGate,departureDate) VALUES (1006,'B6',TO_DATE('2015-03-31 16:00:00', 'yyyy-mm-dd hh24:mi:ss'));
INSERT INTO ASSOCIATEDDEPARTURE(passID,departureGate,departureDate) VALUES (1008,'B8',TO_DATE('2015-03-31 18:00:00', 'yyyy-mm-dd hh24:mi:ss'));
INSERT INTO ASSOCIATEDDEPARTURE(passID,departureGate,departureDate) VALUES (1010,'B10',TO_DATE('2015-03-31 20:00:00', 'yyyy-mm-dd hh24:mi:ss'));
INSERT INTO ASSOCIATEDDEPARTURE(passID,departureGate,departureDate) VALUES (1012,'B2',TO_DATE('2015-03-31 12:00:00', 'yyyy-mm-dd hh24:mi:ss'));
INSERT INTO ASSOCIATEDDEPARTURE(passID,departureGate,departureDate) VALUES (1014,'B4',TO_DATE('2015-03-31 14:00:00', 'yyyy-mm-dd hh24:mi:ss'));
INSERT INTO ASSOCIATEDDEPARTURE(passID,departureGate,departureDate) VALUES (1002,'B99',TO_DATE('2015-03-30 18:30:00', 'yyyy-mm-dd hh24:mi:ss'));

-- ASSOCIATEDARRIVAL
INSERT INTO ASSOCIATEDARRIVAL(passID,arrivalGate,arrivalDate) VALUES (1001,'A1',TO_DATE('2015-03-31 11:00:00', 'yyyy-mm-dd hh24:mi:ss'));
INSERT INTO ASSOCIATEDARRIVAL(passID,arrivalGate,arrivalDate) VALUES (1003,'A3',TO_DATE('2015-03-31 13:00:00', 'yyyy-mm-dd hh24:mi:ss'));
INSERT INTO ASSOCIATEDARRIVAL(passID,arrivalGate,arrivalDate) VALUES (1005,'A5',TO_DATE('2015-03-31 15:00:00', 'yyyy-mm-dd hh24:mi:ss'));
INSERT INTO ASSOCIATEDARRIVAL(passID,arrivalGate,arrivalDate) VALUES (1007,'A7',TO_DATE('2015-03-31 17:00:00', 'yyyy-mm-dd hh24:mi:ss'));
INSERT INTO ASSOCIATEDARRIVAL(passID,arrivalGate,arrivalDate) VALUES (1009,'A9',TO_DATE('2015-03-31 19:00:00', 'yyyy-mm-dd hh24:mi:ss'));
INSERT INTO ASSOCIATEDARRIVAL(passID,arrivalGate,arrivalDate) VALUES (1011,'A1',TO_DATE('2015-03-31 11:00:00', 'yyyy-mm-dd hh24:mi:ss'));
INSERT INTO ASSOCIATEDARRIVAL(passID,arrivalGate,arrivalDate) VALUES (1013,'A3',TO_DATE('2015-03-31 13:00:00', 'yyyy-mm-dd hh24:mi:ss'));
INSERT INTO ASSOCIATEDARRIVAL(passID,arrivalGate,arrivalDate) VALUES (1001,'A98',TO_DATE('2015-03-30 17:30:00', 'yyyy-mm-dd hh24:mi:ss'));
