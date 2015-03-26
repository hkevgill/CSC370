-- ENTITIES


CREATE TABLE AIRLINES(
	airlineCode INT PRIMARY KEY,
	name VARCHAR(40),
	website VARCHAR(100)
);

CREATE TABLE FLIGHTS(
	flightID INT PRIMARY KEY,
	flightNumber INT,
	source VARCHAR(100),
	source VARCHAR(100)
);

CREATE TABLE INCOMING(
	flightID INT,
	plannedArrivalTime DATE,
	CONSTRAINT fk_incoming FOREIGN KEY(flightID) REFERENCES AIRLINES(flightID)
);

CREATE TABLE OUTGOING(
	flightID INT,
	plannedDepartureTime DATE,
	CONSTRAINT fk_outgoing FOREIGN KEY(flightID) REFERENCES AIRLINES(flightID)
);

CREATE TABLE PLANEMODELS(
	planeCode INT PRIMARY KEY,
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
);

CREATE TABLE REGULARCLASS(
	classID INT,
	mealChoice VARCHAR(100),
	CONSTRAINT fk_regularclass FOREIGN KEY(classID) REFERENCES CLASS(classID)
);

CREATE TABLE SPECIALNEEDS(
	classID INT,
	disability VARCHAR(300),
	mealChoice VARCHAR(100),
	CONSTRAINT fk_specialneeds FOREIGN KEY(classID) REFERENCES CLASS(classID)
);

CREATE TABLE INFANT(
	classID INT,
	mealChoice VARCHAR(100),
	toyChoice VARCHAR(100),
	CONSTRAINT fk_infant FOREIGN KEY(classID) REFERENCES CLASS(classID)
);

CREATE TABLE DEPARTURES(
	departureID INT PRIMARY KEY,
	gate VARCHAR(10),
	departureDate DATE,
	departureStatus VARCHAR(100) CONSTRAINT departure_check CHECK(departureStatus LIKE ('departed at [0-2][0-9]:[0-5][0-9]' OR 'delayed to [0-2][0-9]:[0-5][0-9]'))
);

CREATE TABLE ARRIVALS(
	arrivalID INT PRIMARY KEY,
	gate VARCHAR(10),
	arrivalDate DATE,
	arrivalStatus VARCHAR(100) CONSTRAINT arrival_check CHECK(arrivalStatus LIKE ('arrived at [0-2][0-9]:[0-5][0-9]' OR 'delayed to [0-2][0-9]:[0-5][0-9]'))
);


-- RELATIONSHIPS

CREATE TABLE OPERATES(
	airlineCode INT,
	flightID INT,
	planeCode INT,
	CONSTRAINT fk_operates_airlinecode FOREIGN KEY(airlineCode) REFERENCES AIRLINES(airlineCode),
	CONSTRAINT fk_operates_flightid FOREIGN KEY(flightID) REFERENCES FLIGHTS(flightID),
	CONSTRAINT fk_operates_planeCode FOREIGN KEY(planeCode) REFERENCES PLANEMODELS(planeCode)
);

CREATE TABLE BOARDS(
	flightID INT,
	bagID INT,
	passID INT,
	CONSTRAINT fk_boards_flightid FOREIGN KEY(flightID) REFERENCES FLIGHTS(flightID),
	CONSTRAINT fk_boards_bagid FOREIGN KEY(bagID) REFERENCES BAGGAGE(bagID),
	CONSTRAINT fk_boards_passid FOREIGN KEY(passID) REFERENCES PASSENGERS(passID)
);

CREATE TABLE BELONGTO(
	passID INT,
	classID INT,
	CONSTRAINT fk_belongto_passid FOREIGN KEY(passID) REFERENCES PASSENGERS(passID),
	CONSTRAINT fk_belongto_classid FOREIGN KEY(classID) REFERENCES CLASS(classID)
);

CREATE TABLE ASSOCIATEDDEPARTURE(
	classID INT,
	departureID INT,
	CONSTRAINT fk_associateddeparture_classid FOREIGN KEY(classID) REFERENCES CLASS(classID),
	CONSTRAINT fk_associateddeparture_departureid FOREIGN KEY(departureID) REFERENCES DEPARTURES(departureID)
);

CREATE TABLE ASSOCIATEDARRIVAL(
	classID INT,
	arrivalID INT,
	CONSTRAINT fk_associatedarrival_classid FOREIGN KEY(classID) REFERENCES CLASS(classID),
	CONSTRAINT fk_associatedarrival_arrivalid FOREIGN KEY(arrivalID) REFERENCES ARRIVALS(arrivalID),
);

