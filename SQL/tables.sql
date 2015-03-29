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
	destination VARCHAR(100)
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

