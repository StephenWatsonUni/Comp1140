	drop table Enrolment
	drop table Course
	drop table Privilege
	drop table Acquisition
	drop table Reservation
	drop table Loan
	drop table MoveableResource
	drop table ImmoveableResource
	drop table Resource
	drop table Location
	drop table Category
	drop table Staff
	drop table Student
	drop table Member

CREATE TABLE Category  
(
	code CHAR(15) NOT NULL,
	name VARCHAR(30) NOT NULL,
	description VARCHAR(30) NOT NULL,
	durationInHours int NOT NULL,
	PRIMARY KEY (code)
)


CREATE TABLE Location 
(
	locationId CHAR(15) NOT NULL,
	room CHAR(15) NULL,
	level VARCHAR(30) NULL,
	building VARCHAR(30) NOT NULL,
	campus VARCHAR(30) CHECK(campus IN('Newcastle','Ourimbah','Sydney','Coffs Harbour')) NOT NULL,
	PRIMARY KEY (locationId)
)


CREATE TABLE Resource 
(
  resourceId CHAR(15) NOT NULL,
  description VARCHAR(30) NULL,
  status VARCHAR(20) CHECK(status IN('Not collected', 'Collected', 'Cancelled')) DEFAULT 'Not collected' NOT NULL,
  code CHAR(15) NOT NULL,
  locationId CHAR(15) NOT NULL,
  FOREIGN KEY (code) REFERENCES Category(code) ON UPDATE CASCADE ON DELETE NO ACTION,
  FOREIGN KEY (locationId) REFERENCES Location(locationId) ON UPDATE CASCADE ON DELETE NO ACTION,
  PRIMARY KEY (resourceId)
)

CREATE TABLE Member 
(
  memberId CHAR(15) NOT NULL,
  name VARCHAR(30) NOT NULL,
  streetName VARCHAR(30) NOT NULL,
  streetNumber INT NOT NULL,
  suburb VARCHAR(30) NOT NULL,
  postCode VARCHAR(30) NOT NULL,
  phone CHAR(10) NOT NULL,
  email VARCHAR(30) CHECK(email LIKE '%_@__%.__%') NOT NULL,
  status VARCHAR(30) CHECK(status IN('Disabled', 'Active')) DEFAULT 'Active' NOT NULL,
  comments VARCHAR (30) NULL,
  primary key(memberId)
)

CREATE TABLE Student 
(
	memberId CHAR(15) NOT NULL,
	points INT DEFAULT 12 NOT NULL,
	FOREIGN KEY (memberId) REFERENCES Member(memberId) ON UPDATE CASCADE ON DELETE CASCADE, 
	primary key(memberId)
)	


CREATE TABLE Staff 
(
	memberId CHAR(15) NOT NULL,
	Position CHAR(15) NOT NULL,
	Foreign Key (memberId) REFERENCES Member(memberId)	ON UPDATE CASCADE ON DELETE CASCADE,
	primary key(memberId)
)


CREATE TABLE Course
(
	courseId CHAR(30) NOT NULL,
	name VARCHAR(30) NOT NULL,
	primary key(courseId)

)


CREATE TABLE MoveableResource
(

	resourceId CHAR(15) NOT NULL,
	name VARCHAR(30) NOT NULL,
	make VARCHAR(30) NULL,
	model VARCHAR(30) NULL,
	year CHAR(4) NULL,
	manufacturer VARCHAR(30) NULL,
	assetValue MONEY NULL,
	FOREIGN KEY (resourceId) REFERENCES Resource(resourceId) ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY(resourceId)
)


CREATE TABLE ImmoveableResource 
(
  resourceId CHAR(15) NOT NULL,
  capacity INT NULL,
  FOREIGN KEY (resourceId) REFERENCES Resource(resourceId) ON UPDATE CASCADE ON DELETE CASCADE,
  primary key(resourceId)
)



CREATE TABLE Privilege 
(
	privilegeId CHAR(15) NOT NULL,
	description VARCHAR(30) NOT NULL,
	maximumItems INT NOT NULL,
	code CHAR(15) NOT NULL,
	FOREIGN KEY (code) REFERENCES Category(code) ON UPDATE CASCADE ON DELETE NO ACTION,
	PRIMARY KEY(privilegeId)
)


CREATE TABLE Enrolment
(
	courseId CHAR(30) NOT NULL,
	name VARCHAR(30) NOT NULL,
	startDate Date NOT NULL,
	endDate Date NOT NULL,
	semesterOffered VARCHAR(30) CHECK(semesterOffered IN('1','Winter','2','Summer', '1 AND 2')) NOT NULL,
	yearOffered CHAR(4) NOT NULL,
	privilegeId CHAR(15) NOT NULL,
	memberId CHAR(15) Not NULL,	
	FOREIGN KEY (privilegeId) REFERENCES Privilege(privilegeId) ON UPDATE CASCADE ON DELETE NO ACTION, 
	FOREIGN KEY (memberId) REFERENCES Member(memberId) ON UPDATE CASCADE ON DELETE NO ACTION, 
	FOREIGN KEY (courseId) REFERENCES Course(courseId) ON UPDATE CASCADE ON DELETE NO ACTION,
	PRIMARY KEY (courseId)
)


CREATE TABLE Acquisition 
(
	acquisitionId CHAR(15) NOT NULL,   
	memberId CHAR(15) Not NULL,	
	itemName VARCHAR(30) Not NULL,
	make VARCHAR(30) Not NULL,
	model VARCHAR(30) Not NULL,
	year CHAR(4)  Not NULL,
	manufacturer VARCHAR(30) NULL,
	description	VARCHAR(30)	Not NULL,
	urgency	VARCHAR(30)	CHECK(urgency IN('High','Low')) NULL,
	status	VARCHAR(10)	CHECK(status IN('Pending','Approved', 'Denied')) DEFAULT 'Pending' NULL,
	vendorCode VARCHAR(30) Not NULL,
	price Decimal(5) Not NULL,
	fundCode VARCHAR(30) Not NULL,
	notes VARCHAR(30) Not NULL,
	FOREIGN KEY (memberId) REFERENCES Member(memberId) ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY (acquisitionId)
)


CREATE TABLE Loan 
(
	loanId	INT IDENTITY(1,1) NOT NULL,
	dateTimeBorrowed dateTime NOT NULL,
	dateTimeDue	dateTime NOT NULL,
	dateTimeReturned dateTime NULL,
	moveableResourceId CHAR(15) NOT NULL,
	memberId CHAR(15) NOT NULL,
	FOREIGN KEY (moveableResourceId) REFERENCES MoveableResource(resourceId) ON UPDATE CASCADE ON DELETE NO ACTION,
	FOREIGN KEY (memberId) REFERENCES Member(memberId) ON UPDATE CASCADE ON DELETE NO ACTION,	
	PRIMARY KEY (loanId)
)


CREATE TABLE Reservation 
(
	reservationId CHAR(15) NOT NULL, 
	dateTimeStart date NOT NULL,
	DateTimeEnd date NOT NULL,
	memberId CHAR(15) NOT NULL,
	resourceId CHAR(15) NOT NULL,
	FOREIGN KEY (resourceId) REFERENCES Resource(resourceId) ON UPDATE CASCADE ON DELETE NO ACTION,
	FOREIGN KEY (memberId) REFERENCES Member(memberId) ON UPDATE CASCADE ON DELETE NO ACTION,
	PRIMARY KEY(reservationId)
)



INSERT INTO Category VALUES ('cam10287','Camera', 'Camera types', 14)
INSERT INTO Category VALUES ('bos1237','speaker', 'Bluetooth speakers', 14)
INSERT INTO Category VALUES ('mthb002615','book','Math books', 14)
INSERT INTO Category VALUES ('mr1264','room','Meeting room', 3)
INSERT INTO Category VALUES ('srm1304','room','Study room', 3)
INSERT INTO Category VALUES ('st2003','room','Studio room', 4)

SELECT *
FROM Category;


INSERT INTO Location VALUES ('syd1001','blm1406',1,'blossom','Sydney')
INSERT INTO Location VALUES ('new0785','lsm100',2,'math','Newcastle')
INSERT INTO Location VALUES ('our1501','es1206',1,'engineering','Ourimbah')

SELECT *
FROM Location;

INSERT INTO RESOURCE VALUES ('Cam01874','Sony Camera', 'Collected','cam10287','new0785')
INSERT INTO Resource VALUES ('Spkr12031','Bose bluetrooth speaker','Collected','bos1237','Syd1001')
INSERT INTO Resource VALUES ('mthBook101','math basics textBook','Not collected', 'mthb002615','our1501')
INSERT INTO Resource VALUES ('SydSR001','Study room for students', default,'srm1304','Syd1001')
INSERT INTO Resource VALUES ('OurMR002','Meeting Room', default, 'mr1264','our1501')
INSERT INTO Resource VALUES ('newMR003','Studio room', default,'st2003','new0785')

SELECT *
FROM RESOURCE;

INSERT INTO Member VALUES ('S3334685','Jill Smith', 'Fake Street', 37, 'Lake Mac','2259','0412762918','JSmith82@Gmail.com', 'Active', '')
INSERT INTO Member VALUES ('S3331125','Dean Hughes', 'Leggee Place', 145, 'Green Point','2250','0417198473','Deano27@Gmail.com', 'Active', 'None')
INSERT INTO Member VALUES ('S3330695','Matthew Parker', 'Timmins Avenue', 145, 'Birmingham Gardens','2287','0482657361','PraxM@Gmail.com', 'Disabled', 'None')
INSERT INTO Member VALUES ('S3334463','John Coyle', 'Boulvard Street', 24, 'Surry Hills', '2002','0411673609','JohnyCoyleM@Gmail.com', 'Active', 'Fines due')
INSERT INTO Member VALUES ('S3332275','Chris Watson', 'SunShine Street', 6, 'Coffs Harbour','2450','0465283760','CDW@Gmail.com', 'Disabled', 'None')
INSERT INTO Member VALUES ('S3330047','Bryce Harvard', 'Anita Place', 109, 'AdamsTown', '2587','0428871652','HarvardB84@Gmail.com', 'Active', '')
INSERT INTO Member VALUES ('S3335569','Alex Griffin', 'Plateau Street', 334, 'Springfield', '2265','0418726345','Griffin34@Gmail.com', 'Active', '')
INSERT INTO Member VALUES ('S3330052','Bree Sherd', 'Latern Street', 97, 'HomeBush', '2025','0410756734','BreeSherd@Gmail.com', 'Active', '')

SELECT *
FROM Member;


INSERT INTO Student (memberId, points) VALUES ('S3331125', default)
INSERT INTO Student (memberId, points) VALUES ('S3334463', 9)
INSERT INTO Student (memberId, points) VALUES ('S3330047', default)
INSERT INTO Student (memberId, points) VALUES ('S3330052', 6)

SELECT *
FROM Student;

INSERT INTO Staff VALUES ('S3334685','Lecture')
INSERT INTO Staff VALUES ('S3330695','Lab Tutor')
INSERT INTO Staff VALUES ('S3332275','Admin')
INSERT INTO Staff VALUES ('S3335569','Former Staff')

SELECT *
FROM Staff;



INSERT INTO Course VALUES ('ENG2500','Sustainable Engineering')
INSERT INTO Course VALUES ('SENG1120','Data Structures')
INSERT INTO Course VALUES ('COMP1140','Database Management')
INSERT INTO Course VALUES ('MATH1110','Mathamatics for Engineering')
INSERT INTO Course VALUES ('HUBS1410','Medical terminalogy')

SELECT *
FROM Course;


INSERT INTO MoveableResource (resourceId, name, make, model, year, manufacturer, assetValue) VALUES ('Cam01874', 'camera1003', 'sony camera', '1522ci', 2017,'sony',1300)
INSERT INTO MoveableResource (resourceId, name, make, model, year, manufacturer, assetValue) VALUES ('Spkr12031', 'speaker1609', 'bose camera', '2270', 2019,'bose',1495)
INSERT INTO MoveableResource (resourceId, name, make, model, year, manufacturer, assetValue) VALUES ('mthBook101', 'mathBasic', 'dep edu', 'ver 3', 2015,'dep edu',345)

SELECT *
FROM MoveableResource;


INSERT INTO ImmoveableResource (resourceId, capacity) VALUES ('SydSR001', 15)
INSERT INTO ImmoveableResource (resourceId, capacity) VALUES ('OurMR002', 12)
INSERT INTO ImmoveableResource (resourceId, capacity) VALUES ('newMR003', 6)

SELECT *
FROM ImmoveableResource;


INSERT INTO Privilege VALUES ('PrMthb002615','Mathamatics Books', 10,'mthb002615')
INSERT INTO Privilege VALUES ('PrEng0023','sony Camera', 1, 'cam10287')
INSERT INTO Privilege VALUES ('PrBos1237','Speaker', 2,'bos1237')
INSERT INTO Privilege VALUES ('PrMR1264','Meeting room', 2, 'mr1264')

SELECT *
FROM Privilege


INSERT INTO Enrolment VALUES ('SENG1120', 'Data Structures', '2020-4-20', '2020-7-20','1 AND 2', '2020','PrBos1237', 'S3331125') -- dean, 
INSERT INTO Enrolment VALUES ('COMP1140', 'Database Management', '2020-4-20', '2020-7-20','1', '2020', 'PrEng0023', 'S3334463')
INSERT INTO Enrolment VALUES ('ENG2500', 'Sustainable Engineering', '2020-7-20', '2020-11-20','2', '2020','PrMR1264', 'S3330047')
INSERT INTO Enrolment VALUES ('Hubs1410', 'Medical terminalogy', '2020-7-20', '2020-11-20','1 AND 2','2020', 'PrBos1237', 'S3330052')
INSERT INTO Enrolment VALUES ('Math1110', 'Mathamatics for Engineering', '2020-4-20', '2020-7-20','Summer','2021','PrMthb002615', 'S3330052')

SELECT *
FROM Enrolment


INSERT INTO Acquisition (acquisitionId, memberId, itemName, make, model, year, manufacturer, description, urgency, status, vendorCode, price, fundCode, notes) VALUES ('Acq10004','S3332275','Pencils','HB','HB2', 2020,'Officeworks', 'lead pencils', 'low', 'Approved', 'ven9889675', 24.50, 'fc356475', 'Order approved')
INSERT INTO Acquisition (acquisitionId, memberId, itemName, make, model, year, manufacturer, description, urgency, status, vendorCode, price, fundCode, notes) VALUES ('Acq10001','S3334685','headphones','1790E','JBL', 2019,'JBL', 'Bluetooth Headphones', 'low', 'pending', 'ven1140594', 730, 'fc20034', 'N/A')
INSERT INTO Acquisition (acquisitionId, memberId, itemName, make, model, year, manufacturer, description, urgency, status, vendorCode, price, fundCode, notes) VALUES ('Acq10002','S3330695','Glasses','wrkSfe2378','SafeHouse', 2018,'SafeHouse', 'Saftey glasses', 'high', 'approved', 'ven1986746', 120, 'fc678473', 'saftey glasses engineering')
INSERT INTO Acquisition (acquisitionId, memberId, itemName, make, model, year, manufacturer, description, urgency, status, vendorCode, price, fundCode, notes) VALUES ('Acq10003','S3335569','Laptop','Surface pro ','pro seven', 2020,'Microsoft', 'portable laptop/tablet', 'high', 'Denied', 'ven1465096', 1700, 'fc361524', 'denied Not current employee')

SELECT *
FROM Acquisition;


INSERT INTO Loan(memberId, dateTimeBorrowed, dateTimeDue, dateTimeReturned, moveableResourceId) VALUES ('S3331125', getDate(), DATEADD(HOUR, +336, getDate()) , DATEADD(DAY, +9, getDate()) , 'Cam01874')
INSERT INTO Loan(memberId, dateTimeBorrowed, dateTimeDue, dateTimeReturned, moveableResourceId) VALUES ('S3334463', getDate(), DATEADD(HOUR, +336, getDate()) , DATEADD(DAY, +13, getDate()) , 'Spkr12031')
INSERT INTO Loan(memberId, dateTimeBorrowed, dateTimeDue, dateTimeReturned, moveableResourceId) VALUES ('S3330047', getDate(), DATEADD(HOUR, +336, getDate()) , DATEADD(DAY, +6, getDate()) , 'mthBook101')

SELECT *
FROM Loan;

INSERT INTO Reservation VALUES ('Res10001', '2019-6-19', '2019-7-3' , 'S3334685', 'Cam01874')
INSERT INTO Reservation VALUES ('Res10002', '2019-5-4', '2019-5-18' , 'S3330047', 'mthBook101')
INSERT INTO Reservation VALUES ('Res10003', getDate(), DATEADD(DAY, +14, getDate()) , 'S3331125', 'Spkr12031')
INSERT INTO Reservation VALUES ('Res10004', getDate(), DATEADD(DAY, +14, getDate()) , 'S3331125', 'OurMR002')
INSERT INTO Reservation VALUES ('Res10005', '2019-4-13', '2019-4-27' , 'S3334685', 'newMR003')

SELECT *
FROM Reservation;

--1
--Courses in database are HUBS1410, SENG1120, ENG2500, COMP1140, MATH1110
SELECT m.name
FROM Enrolment s join Member m ON s.memberId = m.memberId
WHERE s.courseId = 'HUBS1410';

--2
--Only Dean hughes and Bree Sherd are allowed speakers
SELECT SUM(p.maximumItems) AS 'sum Of Speaker Privileges'
FROM Privilege p, Enrolment ci, Enrolment m
WHERE p.code = (SELECT code FROM Category c WHERE c.name = 'Speaker') 
AND p.privilegeId = ci.privilegeId
AND p.privilegeId = ci.privilegeId AND ci.courseId = m.CourseId
AND m.memberId = (SELECT m.memberId FROM Member m WHERE m.name = 'Dean Hughes')

--3
-- Jill is the staff member who has acquisitions and Reservations
select  m.name,m.phone, count(DISTINCT a.acquisitionId) 'total acquisitions',
count(DISTINCT r.reservationId) as 'total Reservations'
 from  member m  
join Acquisition a on m.memberId = a.memberId
join Reservation r on m.memberId = r.memberId
where year = '2019' and m.memberId = 'S3334685'
group by m.name,m.phone,a.acquisitionId

--4 
-- Dean is only one who borrowed camera
SELECT DISTINCT(m.name) FROM Member m 
RIGHT JOIN Student s ON m.memberId = s.memberId 
LEFT JOIN Loan l ON s.memberId = l.memberId LEFT JOIN MoveableResource m2 ON l.moveableResourceId = m2.resourceId 
LEFT JOIN Resource r ON m2.resourceId = r.resourceId LEFT JOIN Category c ON r.code = c.code
WHERE YEAR(l.dateTimeBorrowed) = '2020' AND c.name = 'Camera' AND m2.model = '1522ci'



--5 MathBook is most loaned
SELECT TOP (1) name, l.moveableResourceId FROM MoveableResource m RIGHT JOIN Loan l ON m.resourceId = l.moveableResourceId 
WHERE MONTH(l.dateTimeBorrowed) = MONTH(GETDATE())
GROUP BY name, l.moveableResourceId ORDER BY COUNT(l.moveableResourceId) DESC;

--6