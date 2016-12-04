CREATE TABLE customer(
    customerID              VARCHAR(20) NOT NULL,
    customerFirstName       VARCHAR(20) NOT NULL,
    customerLastName        VARCHAR(20) NOT NULL,
    customerPhone           VARCHAR(20) NOT NULL,
    customerEmail           VARCHAR(50),
    customerYear            INT,
    CONSTRAINT customer_pk PRIMARY KEY (customerID)
);

CREATE TABLE existing_c(
    customerID              VARCHAR(20) NOT NULL,
    lastVisit               DATE,
    CONSTRAINT existing_c_pk
    PRIMARY KEY (customerID),
    CONSTRAINT existing_c_fk
    FOREIGN KEY (customerID)
    REFERENCES customer (customerID)
);

CREATE TABLE prospect(
    customerID              VARCHAR(20) NOT NULL,
    refferal                VARCHAR(20) NOT NULL,
    lastContactDate         DATE,
    isNowExisting           BOOLEAN,
    CONSTRAINT prospect_pk PRIMARY KEY (customerID, refferal),
    CONSTRAINT prospect_customer_fk
    FOREIGN KEY (customerID)
    REFERENCES customer (customerID),
    CONSTRAINT prospect_existing_fk
    FOREIGN KEY (refferal)
    REFERENCES existing_c(customerID)
);

CREATE TABLE steady(
    customerID              VARCHAR(20) NOT NULL,
    CONSTRAINT steady_pk    PRIMARY KEY (customerID),
    CONSTRAINT steady_existing_c_fk
    FOREIGN KEY (customerID)
    REFERENCES existing_c (customerID)
);

CREATE TABLE premier(
    customerID              VARCHAR(20) NOT NULL,
    monthlyFee              INT         NOT NULL,
    CONSTRAINT premier_pk   PRIMARY KEY (customerID),
    CONSTRAINT premier_existing_c_fk
    FOREIGN KEY (customerID)
    REFERENCES existing_c (customerID)
);

CREATE TABLE private(
    customerID              VARCHAR(20) NOT NULL,
    address                 VARCHAR(50),
    zipcode                 VARCHAR(20),
    CONSTRAINT private_pk
    PRIMARY KEY (customerID),
    CONSTRAINT private_fk
    FOREIGN KEY (customerID)
    REFERENCES customer (customerID)
);

CREATE TABLE corporate(
    customerID              VARCHAR(20) NOT NULL,
    CONSTRAINT corporate_pk
    PRIMARY KEY (customerID),
    CONSTRAINT corporate_fk
    FOREIGN KEY (customerID)
    REFERENCES customer (customerID)
);

CREATE TABLE appointment(
    customerID              VARCHAR(20) NOT NULL,
    aDate                   date,   
    CONSTRAINT appointment_pk
    PRIMARY KEY (customerID, aDate),
    CONSTRAINT appointment_fk
    FOREIGN KEY (customerID)
    REFERENCES customer (customerID)
);

CREATE TABLE car(
    customerID              VARCHAR(20) NOT NULL,
    carVin                  VARCHAR(20) NOT NULL,
    carModle                VARCHAR(20),
    carMake                 VARCHAR(20),
    carYear                 VARCHAR(20),
    CONSTRAINT car_pk
    PRIMARY KEY (carVin),
    CONSTRAINT car_fk
    FOREIGN KEY (customerID)
    REFERENCES customer (customerID)
);

ALTER TABLE car
    ADD isAccidental    BOOLEAN;

CREATE TABLE carMiles(
    carVin                  VARCHAR(20) NOT NULL,
    miles                   INT,
    carMileDate             date,
    CONSTRAINT carMiles_pk
    PRIMARY KEY (carVin, carMileDate),
    CONSTRAINT carMiles_fk
    FOREIGN KEY (carVin)
    REFERENCES car (carVin)
);

CREATE TABLE notifications(
    customerID              VARCHAR(20) NOT NULL,
    carVin                  VARCHAR(20) NOT NULL,
    serviceNeeded           VARCHAR(100),
    CONSTRAINT notifications_pk
    PRIMARY KEY (customerID, carVin),
    CONSTRAINT notification_fk1
    FOREIGN KEY (customerID)
    REFERENCES customer (customerID),
    CONSTRAINT notification_fk2
    FOREIGN KEY (carVin)
    REFERENCES car (carVin)
);

CREATE TABLE special(
    sName                   VARCHAR(20) NOT NULL,
    coupon                  VARCHAR(20),
    CONSTRAINT special_pk
    PRIMARY KEY (sName)
);

CREATE TABLE prospectSpecial(
    customerID              VARCHAR(20) NOT NULL,
    sName                   VARCHAR(20) NOT NULL,
    numberOfSpecials        INT,
    CONSTRAINT prospectSpeical_pk
    PRIMARY KEY (customerID, sNAme),
    CONSTRAINT prospectSpecial_fk1
    FOREIGN KEY (customerID)
    REFERENCES prospect (customerID),
    CONSTRAINT prospectSpecial_fk2
    FOREIGN KEY (sName)
    REFERENCES special (sName)
);

CREATE TABLE contact(
    customerID              VARCHAR(20) NOT NULL,
    method_c                VARCHAR(20),
    date_c                  date,
    CONSTRAINT contact_pk
    PRIMARY KEY (customerID, date_c),
    CONSTRAINT contact_fk
    FOREIGN KEY (customerID)
    REFERENCES prospect (customerID)
);

CREATE TABLE address(
    customerID              VARCHAR(20) NOT NULL,
    aName                   VARCHAR(20),
    address                 VARCHAR(20),
    zipcode                 VARCHAR(5),
    CONSTRAINT address_pk
    PRIMARY KEY (customerID, aName),
    CONSTRAINT address_fk
    FOREIGN KEY (customerID)
    REFERENCES customer (customerID)
);

CREATE TABLE employee(
eID VARCHAR (15) NOT NULL,
ename VARCHAR(20) NOT NULL,
eaddress VARCHAR (75) NOT NULL,
ephoneNumber VARCHAR(20) NOT NULL,
eemail VARCHAR (60) NOT NULL,
CONSTRAINT employee_pk PRIMARY KEY (eID)
);

CREATE TABLE technician(
eID VARCHAR (15) NOT NULL,
FullTime BOOLEAN NOT NULL,
CONSTRAINT technician_pk
PRIMARY KEY (eID),
CONSTRAINT technician_fk
FOREIGN KEY (eID)
REFERENCES employee (eID)
);

CREATE TABLE certification(
certID VARCHAR (15) NOT NULL,
certName VARCHAR (60) NOT NULL,
CONSTRAINT certification_pk PRIMARY KEY (certID)
);

CREATE TABLE certificate_instance(
Date VARCHAR (10) NOT NULL,
eID VARCHAR (15) NOT NULL,
certID VARCHAR(15) NOT NULL,
CONSTRAINT instance_certID FOREIGN KEY (certID) REFERENCES certification (certID),
CONSTRAINT instance_edID FOREIGN KEY (eID) REFERENCES employee (eID),
CONSTRAINT certificate_instance_pk PRIMARY KEY (certID, eID)
);

CREATE TABLE mechanic(
eID VARCHAR(15)  NOT NULL,
DateStarted VARCHAR (10)NOT NULL,
CONSTRAINT eID_fk FOREIGN KEY (eID) REFERENCES employee (eID),
CONSTRAINT mechanic_pk PRIMARY KEY (eID)
);

CREATE TABLE mentorship(
eID VARCHAR (15) NOT NULL,
mentorID VARCHAR (15) NOT NULL,
startDate VARCHAR(15) NOT NULL,
endDate VARCHAR(15),
CONSTRAINT eIDmech_fk FOREIGN KEY (eID) REFERENCES mechanic (eID),
CONSTRAINT mentorID_fk FOREIGN KEY (mentorID) REFERENCES mechanic(eID),
CONSTRAINT mentorship_pk PRIMARY KEY (eID, mentorID)
);

CREATE TABLE skill(
eID VARCHAR (15) NOT NULL,
skillName VARCHAR (40) NOT NULL,
skillDate VARCHAR (15) NOT NULL,
CONSTRAINT eIDskill_fk FOREIGN KEY (eID) REFERENCES mechanic (eID),
CONSTRAINT skill_pk PRIMARY KEY (eID, skillName)
);

CREATE TABLE workOrder (
 /*changed orderDate type to date from VARCHAR*/
  orderNumber varchar(20) NOT NULL,
  carVin varchar(20),
  eID varchar(15),
  orderDate date,
  recordedMilage varchar(20),
  CONSTRAINT order_pk PRIMARY KEY (orderNumber),
  CONSTRAINT order_car_fk FOREIGN KEY (carVin) REFERENCES car (carVin),
  CONSTRAINT order_employee_fk FOREIGN KEY (eID) REFERENCES employee (eID)
);

CREATE TABLE task (
  orderNumber varchar(20) NOT NULL,
  maintenanceItem varchar(500) NOT NULL,
  mechanicsAssigned varchar(500), /*whitespace delimited list of mechanic eIDs*/
  CONSTRAINT task_pk PRIMARY KEY (orderNumber, maintenanceItem),
  CONSTRAINT task_workOrder_fk FOREIGN KEY (orderNumber) REFERENCES workOrder (orderNumber)
);


CREATE TABLE maintSchedule (
  carVin varchar(20) NOT NULL,
  nextMaintDate date NOT NULL,
  CONSTRAINT maintSchedule_car_fk FOREIGN KEY (carVin) REFERENCES car (carVin)
);


CREATE TABLE maintenanceItem (
  jobDescription varchar(100) NOT NULL,
  laborHours varchar(20) NOT NULL,
  CONSTRAINT maintenanceItem_pk PRIMARY KEY (jobDescription, laborHours)
);


CREATE TABLE orderLine (
  orderNumber varchar(20) NOT NULL,
  jobDescription varchar(100) NOT NULL,
  laborHours varchar(20) NOT NULL,
  eID varchar(15),
  CONSTRAINT maintenanceItem_pk PRIMARY KEY (jobDescription, laborHours, orderNumber),
  CONSTRAINT OrderLine_workOrder_fk FOREIGN KEY (orderNumber) REFERENCES workOrder (orderNumber),
  CONSTRAINT OrderLine_maintenanceItem_fk_a FOREIGN KEY (jobDescription, laborHours) REFERENCES maintenanceItem (jobDescription, laborHours),
  CONSTRAINT OrderLine_mechanic FOREIGN KEY (eID) REFERENCES mechanic (eID)
);


CREATE TABLE serviceSkill (
    /*
    Qualifications consistive of levels 1 2, 3, and 5
    
        Level 1 IVQ Certificate in Motor Vehicle Systems is ideal for those with no previous experience of motor vehicle engineering.


        Level 2 mechanic courses will suit you if you have very little knowledge of motor vehicle engineering and want to learn how to service vehicles and take on supervisory responsibilities.


        Level 3 mechanic courses are for those with considerable experience with more advanced engineering skills, as well as management capabilities.


        Level 5 mechanic have a great deal of knowledge and experience and have highly advanced or specialised engineering skills, as well as qualification for senior management roles.
    */
  qualification varchar(20) NOT NULL,
  eID VARCHAR (15) NOT NULL,
  skillName VARCHAR (40) NOT NULL,
  orderNumber varchar(20) NOT NULL,
  laborHours varchar(20) NOT NULL,
  jobDescription varchar(100) NOT NULL,
  /*Might need to think about this PK.  What differentiates serviceSkill from skill?*/
  CONSTRAINT serviceSkill_pk PRIMARY KEY (jobDescription, skillName),
  CONSTRAINT serviceSkill_maintenanceItem_fk_a FOREIGN KEY (jobDescription, laborHours) REFERENCES maintenanceItem (jobDescription, laborHours),
  /*Question, do I reference the origial tanle that eID came from (employee), or should I ref skill that has it as a FK?*/
  CONSTRAINT serviceSkill_eIDskill_fk FOREIGN KEY (eID,skillName) REFERENCES skill (eID,skillName)
);


CREATE TABLE package (
  discount varchar(20),
  model varchar(20),
  make varchar(20),
  mileage varchar(20),
  pkgname varchar(100) not null,
  CONSTRAINT package_pk PRIMARY KEY (pkgname)
);


CREATE TABLE maintGroup(
  pkgname varchar(100) not null,
  jobDescription varchar(100) not null,
  laborHours varchar(20) not null,
  CONSTRAINT maintGroup_pk PRIMARY KEY (pkgname, jobDescription, laborHours),
  CONSTRAINT maintGroup_maintenanceItem_fk FOREIGN KEY (jobDescription, laborHours) REFERENCES maintenanceItem (jobDescription, laborHours)
);


INSERT INTO customer (customerID, customerFirstName, customerLastName,
                  	customerPhone, customerEmail, customerYear)
	VALUES
       	('01', 'Sam', 'Dan', '(949)-821-9990', 'samD@gmail.com', 1995),
   	('02', 'Jack', 'Roberts', '(714)233-3456', 'jr@yahoo.com', 2001),
       	('03', 'Samuel', 'Jackson', '(949)113-2234', 'samj@aol.com', 2005),
       	('04', 'Robert', 'Scott', '(512)254-2234', 'rscott@gmail.com', 2010),
       	('05', 'Rod', 'Shiva', '(714)339-2123', 'rshiva@hotmail.com', 2012),
       	('06', 'Jamie', 'Someone', '(949)773-3245', 'someone@gmail.com', 2012),
       	('07', 'Robbie', 'Garcia', '(623)345-1234', 'rg@yahoo.com', 2013),
       	('08', 'Shawn', 'Hannity', '(212)654-9309', 'hannity@fox.com', 2014),
       	('09', 'Tony', 'Stark', '(949)230-1907', 'ts@stark.com', 2014),
       	('10', 'Shayna', 'Howlet', '(949)223-1245', 'howlet@berkley.com', 2014),
       	('11', 'Sarah', 'Cats', '(714)023-8710', 'cats@gmail.com', 2015);

INSERT INTO customer (customerID, customerFirstName, customerLastName,
                      customerPhone, customerEmail, customerYear)
    	VALUES
        ('12', 'John', 'Lennon', '(949)-821-9990', 'Lennon@gmail.com', 2013),
        ('13', 'Ringo', 'Star', '(714)233-3456', 'Ringo@yahoo.com', 2012),
        ('14', 'George', 'Harrison', '(949)113-2234', 'Harrisonj@aol.com', 2014);


INSERT INTO existing_c(customerID, lastVisit)
	VALUES
       	('01', '2016-04-04'),
       	('02', '2016-05-30'),
       	('03', '2016-01-20'),
       	('04', '2016-02-08'),
       	('05', '2016-01-22');


INSERT INTO existing_c(customerID, lastVisit)
	VALUES
       	('06', '2016-11-04'),
       	('07', '2016-10-30'),
       	('08', '2016-05-20');
	
INSERT INTO prospect(customerID, refferal, lastContactDate, isNowExisting)
	VALUES   
       	('10', '01', '2015-12-20', false),
       	('11', '02', '2016-03-05', false),
       	('09', '01', '2016-03-05', false);
	
INSERT INTO prospect(customerID, refferal, lastContactDate, isNowExisting)
	VALUES   
       	('14', '01', '2015-11-20', false),
       	('12', '02', '2015-01-05', false),
        ('13', '01', '2016-01-04', false);


INSERT INTO steady(customerID)
	VALUES
       	('01'),
       	('02'),
       	('03'),
       	('04'),
       	('05');

INSERT INTO premier(customerID, monthlyFee)
	VALUES
       	('06', 20),
       	('07', 22),
       	('08', 35);

INSERT INTO private(customerID, address, zipcode)
	VALUES
       	('01', '135 Jackson street', '92604'),
       	('02', '2 Savahna', '92620'),
       	('04', '13 Ford rd', '92201'),
       	('05', '28 Flower street', '92202'),
       	('06', '16 Cherry Lane', '92202');

INSERT INTO corporate(customerID)
	VALUES
       	('03'),
       	('07'),
       	('08');

INSERT INTO address(customerID, aName, address, zipcode)
	VALUES
       	('03', 'North Office', '135 Baranca', '92620'),
       	('03', 'South Office', '1106 Hayes', '92604'),
       	('07', 'Main Office', '125 Fruit st', '92345'),
       	('07', 'Downtown', '45 Fowler', '92620'),
       	('08', 'Headquaters', '12 Abby st', '92445');

INSERT INTO appointment(customerID, aDate)
	VALUES
       	('01', '2016-12-18'),
       	('01', '2016-12-21'),
       	('02', '2016-12-28'),
       	('07', '2016-12-18'),
       	('09', '2016-12-08'),
       	('08', '2016-12-09'),
       	('04', '2016-12-30');

INSERT INTO car(customerID, carVin, carModle, carMake, carYear, isAccidental)
	VALUES
       	('01', '1GBL7D1YXCV167188', 'F-150', 'Ford', '2004', false),
       	('01', 'SALVV2BGXCH726816', 'Focus', 'Ford', '2013', true),
       	('02', '1FUBGDDR19LA06952', 'Corolla', 'Toyota', '2006', false),
       	('03', '1FABP40A1JF315303', 'Accord', 'Honda', '2008', false),
       	('04', '5KKHAXDV1FPG36118', 'Civic', 'Honda', '2009', false),
       	('05', 'JKAKXTCC4WA040493', 'Civic', 'Honda', '2002', false),
       	('05', '1GKDT13S342329642', 'Accord', 'Honda', '2008', false),
       	('06', '1FTNS1EW6BDB42500', 'Camry', 'Toyota', '2008', false),
       	('07', 'JHLRD18691C097003', 'Tacoma', 'Toyota', '2009', false),
       	('08', '1FBNE31S04HB51098', 'Camero', 'Chevy', '2010', false);

INSERT INTO carMiles(carVin, miles, carMileDate)
	VALUES
       	('1GBL7D1YXCV167188', 84732, '2016-03-18'),
       	('SALVV2BGXCH726816', 60129, '2016-04-04'),
       	('1FUBGDDR19LA06952', 93032, '2016-05-30'),
       	('1FABP40A1JF315303', 91028, '2016-01-20'),
       	('5KKHAXDV1FPG36118', 32405, '2016-02-08'),
       	('JKAKXTCC4WA040493', 91091, '2016-01-22'),
       	('1GKDT13S342329642', 63357, '2016-01-06'),
       	('1FTNS1EW6BDB42500', 87091, '2016-11-04'),
       	('JHLRD18691C097003', 46301, '2016-10-30'),
       	('1FBNE31S04HB51098', 10210, '2016-05-20');

INSERT INTO notifications(customerID, carVin, serviceNeeded)
	VALUES
       	('01', '1GBL7D1YXCV167188', 'Oil Change'),
       	('03', '1FABP40A1JF315303', 'Spark Plug-Oil Change'),
       	('06', '1FTNS1EW6BDB42500', 'Oil Change-Brakes'),
       	('07', 'JHLRD18691C097003', 'Brakes-Spark Plugs'),
       	('04', '5KKHAXDV1FPG36118', 'Oil Change');

INSERT INTO special(sName, coupon)
	VALUE
       	('Oil Change', '1A'),
       	('$50 off', '2A'),
       	('$100 off', '2B');

INSERT INTO prospectSpecial(customerID, sName, numberOfSpecials)
	VALUES
       	('10', 'Oil Change', 2),
       	('10', '$50 off', 2);

INSERT INTO contact(customerID, method_c, date_c)
	VALUE
       	('10', 'Phone', '2015-10-20'),
       	('10', 'Email', '2015-12-20'),
       	('09', 'Email', '2015-10-18'),
       	('09', 'Phone', '2016-01-05'),
       	('09', 'Phone', '2016-03-05'),
       	('11', 'Email', '2016-03-05');
	
INSERT INTO contact(customerID, method_c, date_c)
	VALUE
       	('11', 'Phone', '2015-11-20'),
       	('11', 'Email', '2014-12-20'),
       	('11', 'Email', '2013-10-18'),
       	('12', 'Phone', '2015-01-05'),
       	('12', 'Phone', '2014-03-05'),
        ('12', 'Email', '2013-03-05'),
	('13', 'Email', '2015-11-20');


INSERT INTO employee VALUES ('576027904033696', 'Marc Summers', '1245 Park Ave, Long Beach CA', '+1-562-333-8918','marc.summers@autoshop.com');
INSERT INTO employee VALUES ('925812068577979', 'Ashton Kutcher', '3146 Main St, Irvine CA', '+1-717-615-2558', 'ashton.kutcher@autoshop.com');
INSERT INTO employee VALUES ('312476314438384', 'Rihanna', '77891 Flower Rd, Carson CA', '+619-761-1624','rihanna@autoshop.com');
INSERT INTO employee VALUES ('578090506011182', 'Drake', '99 Atherton Rd, Long Beach CA', '+1-910-278-4151', 'drake@autoshop.com');
INSERT INTO employee VALUES ('809898239915394', 'Dwayne Johnson', '987 Denver Dr, Costa CA', '+1-562-480-9986', 'dwayne.johnson@autoshop.com');
INSERT INTO employee VALUES ('544324531428223', 'Jen Nee', '231 2nd St , Westminster CA', '+562-682-4476', 'jen.nee@autoshop.com');
INSERT INTO employee VALUES ('451851475207895', 'Brad Pitt', '423 Cookie Way, Lakewood CA', '+310-218-7413','brad.pitt@gmail.com');

INSERT INTO technician VALUES ('576027904033696' , True);
INSERT INTO technician VALUES ('925812068577979', True);
INSERT INTO technician VALUES ('312476314438384', False);
INSERT INTO technician VALUES ('578090506011182' , False);

INSERT INTO mechanic VALUES ('578090506011182', '4/3/1996');
INSERT INTO mechanic VALUES ('809898239915394' , '1/25/2001');
INSERT INTO mechanic VALUES ('544324531428223', '8/23/2013');
INSERT INTO mechanic VALUES ('451851475207895' , '11/7/2014');

INSERT INTO certification VALUES ('224679848009249' , 'Smog Check Certificate');
INSERT INTO certification VALUES ('059485942439364' , 'Engine Swap Certificate');
INSERT INTO certification VALUES ('553475559524378' , 'Head Light Restore Certificate');
INSERT INTO certification VALUES ('609648661240830' , 'Fabricator Certificate');
INSERT INTO certification VALUES ('874928552724630' , 'Transmission Swap Certificate');

INSERT INTO certificate_instance VALUES ('12/12/2004' , '578090506011182','059485942439364'  );
INSERT INTO certificate_instance VALUES ('8/23/2000' , '578090506011182','224679848009249'  );
INSERT INTO certificate_instance VALUES ('4/9/2008' , '578090506011182','874928552724630'  );
INSERT INTO certificate_instance VALUES ('11/6/2008' , '578090506011182','553475559524378'  );
INSERT INTO certificate_instance VALUES ('1/28/2008' , '809898239915394','609648661240830'  );
INSERT INTO certificate_instance VALUES ('1/27/2015' , '544324531428223','553475559524378'  );
INSERT INTO certificate_instance VALUES ('1/23/2014' , '544324531428223','059485942439364'  );
INSERT INTO certificate_instance VALUES ('1/5/2016' , '451851475207895', '553475559524378'  );

INSERT INTO mentorship VALUES ('578090506011182' , '809898239915394' , '5/5/2015' , '');
INSERT INTO mentorship VALUES ('809898239915394' , '451851475207895' , '10/8/2014', '12/4/2014' );
INSERT INTO mentorship VALUES ('544324531428223' , '578090506011182' , '9/12/2014' , '8/7/2016');
INSERT INTO mentorship VALUES ('809898239915394' , '544324531428223', '1/1/2016' , '3/4/2016');
INSERT INTO mentorship VALUES ('578090506011182' , '544324531428223', '1/1/2016' , '3/4/2016');

INSERT INTO skill VALUES ('578090506011182' , 'Brake Change', '5/23/1997');
INSERT INTO skill VALUES ('578090506011182' , 'Body Detailing', '7/23/1998');
INSERT INTO skill VALUES ('578090506011182' , 'Electrical Wiring', '8/29/2004');
INSERT INTO skill VALUES ('578090506011182' , 'Interior Cleaning' , '4/12/2000');
INSERT INTO skill VALUES ('809898239915394' , 'Decals' , '3/2/2009');
INSERT INTO skill VALUES ('809898239915394' , 'Wheel Alignment', '3/27/2012');
INSERT INTO skill VALUES ('809898239915394' , 'Tire Change', '3/24/2012');
INSERT INTO skill VALUES ('544324531428223' , 'Electrical Wiring', '9/20/2015');
INSERT INTO skill VALUES ('544324531428223' , 'Radiator Change', '9/28/2015');
INSERT INTO skill VALUES ('451851475207895' , 'Interior Cleaning' , '5/5/2015');
INSERT INTO skill VALUES ('809898239915394' , 'Brake Change' , '3/2/2009');
INSERT INTO skill VALUES ('809898239915394' , 'Interior Cleaning', '3/27/2012');
INSERT INTO skill VALUES ('809898239915394' , 'Electrical Wiring' , '3/2/2009');


/*John DML*/


/*Possible Issues:
  - Not 100% sure about how I've modled the multi-valued attribute Task
    as it is seeming a lot like orderLine
    
  -Check where the derived value for laborHrs * hourlywage is calculated.
   Need to make money at some point! :)
*/


INSERT INTO workOrder(orderNumber, carVin, orderDate, eID, recordedMilage)
  VALUES
       	('00001', '1GBL7D1YXCV167188', '2016-12-18', '576027904033696', '81148'),
       	('00002', 'SALVV2BGXCH726816', '2016-12-21', '925812068577979', '107286'),
       	('00003', '1FUBGDDR19LA06952', '2016-12-28', '312476314438384', '97686'),
       	('00004', '5KKHAXDV1FPG36118', '2016-12-18', '312476314438384', '76258'),
       	('00005', 'JKAKXTCC4WA040493', '2016-12-08', '578090506011182', '113184'),
       	('00006', '1GKDT13S342329642', '2016-12-09', '809898239915394', '33610'),
       	('00007', '1FTNS1EW6BDB42500', '2016-12-30', '451851475207895', '101813');


INSERT INTO workOrder(orderNumber, carVin, orderDate, eID, recordedMilage)
  VALUES
        ('00008', '1GKDT13S342329642', '2016-12-10', '809898239915394', '33610'),
        ('00009', '1GKDT13S342329642', '2016-12-09', '809898239915394', '33610'),
        ('00010', '1GKDT13S342329642', '2016-12-11', '809898239915394', '33610');
        
INSERT INTO orderLine(orderNumber, jobDescription, laborHours, eID)
  VALUES
        ('00008','Break pads', '1.5', '809898239915394'),
       	('00009','check/replace fuel filters', '2','809898239915394'),
       	('00010','inspect or replace windshield wipers', '0.25', '809898239915394');
       
INSERT INTO task(orderNumber, maintenanceItem, mechanicsAssigned)
  VALUES
       	('00001', 'Tire rotation', '576027904033696 925812068577979'),
       	('00002',  'Valve adjustment', '925812068577979 451851475207895 809898239915394'),
       	('00003', 'Oil change', '312476314438384'),
       	('00004', 'check or flush brake fluid','312476314438384 578090506011182'),
       	('00005', 'AC refill', '578090506011182'),
       	('00006', 'Oil change', '809898239915394'),
       	('00007', 'Break pads', '451851475207895');


INSERT INTO task(orderNumber, maintenanceItem, mechanicsAssigned)
  VALUES
        ('00008', 'Break pads', '451851475207895'),
        ('00009', 'check/replace fuel filters', '451851475207895'),
        ('00010', 'inspect or replace windshield wipers', '451851475207895');


                
INSERT INTO maintSchedule(carVin, nextMaintDate)
  VALUES
        ('1GBL7D1YXCV167188', '2017-03-18'),
       	('SALVV2BGXCH726816', '2017-03-21'),
       	('1FUBGDDR19LA06952', '2017-03-28'),
       	('5KKHAXDV1FPG36118', '2017-03-18'),
       	('JKAKXTCC4WA040493', '2017-03-08'),
       	('1GKDT13S342329642', '2017-03-09'),
       	('1FTNS1EW6BDB42500', '2017-03-30');
        
INSERT INTO maintenanceItem(jobDescription, laborHours)
  VALUES
        ('Tire rotation', '1.5'),
       	('Valve adjustment', '4'),
       	('Oil change', '0.5'),
       	('Transmission rebuild', '14'),
       	('Break pads', '1.5'),
       	('check/replace fuel filters', '2'),
       	('inspect or replace windshield wipers', '0.25'),
        ('Tire balancing', '2'),
        ('Wheel alignment', '1.5'),
        ('check or flush brake fluid', '0.25'),
        ('check or flush transmission fluid', '0.5'),
        ('check or flush power steering fluid', '0.5'),
        ('check and flush engine coolant', '1'),
        ('inspect or replace spark plugs', '2'),
        ('inspect or replace air filter', '1'),
        ('inspect or replace timing belt and other belts', '2'),
        ('lubricate locks, latches, hinges', '1'),
        ('tighten chassis nuts and bolts', '2'),
        ('check if rubber boots are cracked and need replacement', '1'),
        ('test electronics ABS', '1'),
        ('read fault codes from the Engine control unit', '0.25');
     
INSERT INTO orderLine(orderNumber, jobDescription, laborHours, eID)
  VALUES
        ('00001','Tire rotation', '1.5', '578090506011182'),
       	('00002','Valve adjustment', '4', '578090506011182'),
       	('00003','Oil change', '0.5', '809898239915394'),
       	('00004','Transmission rebuild', '14', '809898239915394'),
       	('00005','Break pads', '1.5', '544324531428223'),
       	('00006','check/replace fuel filters', '2','544324531428223'),
       	('00007','inspect or replace windshield wipers', '0.25', '451851475207895');


INSERT INTO orderLine(orderNumber, jobDescription, laborHours, eID)
  VALUES
        ('00008','Break pads', '1.5', '809898239915394'),
       	('00009','check/replace fuel filters', '2','809898239915394'),
       	('00010','inspect or replace windshield wipers', '0.25', '809898239915394');
        


/*Possible issue:  Skill name is different from what is in skill table
                   because skill names are similar to what I'm calling
                   jobDiscriptions.  Rename skills to something like a
                   job catagory - making sure to differ from qualification.'*/
INSERT INTO serviceSkill(qualification, eID, skillName, orderNumber, jobDescription, laborHours)
  VALUES
        ('Level 1','578090506011182', 'Brake Change', '00001', 'Tire rotation', '1.5'),
       	('Level 3','578090506011182', 'Body Detailing', '00002', 'Valve adjustment', '4'),
       	('Level 1','578090506011182', 'Electrical Wiring', '00003', 'Oil change', '0.5'),
       	('Level 5','578090506011182', 'Interior Cleaning', '00004', 'Transmission rebuild', '14'),
       	('Level 2','809898239915394', 'Decals', '00005', 'Break pads', '1.5'),
       	('Level 2','451851475207895', 'Interior Cleaning', '00006', 'check/replace fuel filters','2'),
       	('Level 1','578090506011182', 'Interior Cleaning', '00007', 'inspect or replace windshield wipers', '0.25');
        
INSERT INTO package(discount, model, make, mileage, pkgname)
  VALUES
        ('0.65','Ford', 'CR-V', '25000', 'Ford Under CR-V 25k'),
        ('0.75','HONDA', 'Civic', '25000', 'HONDA Civic Under 25k'),
        ('0.85','MITSUBISHI', 'Outlander', '25000', 'MITSUBISHI Outlander Under 25k'),
        ('0.95','SUZUKI', 'S-Cross', '25000', 'SUZUKI S-Cross Under 25k'),
       	('0.95','TOYOTA', 'Prius', '25000', 'TOYOTA Prius Under 25k');
        
INSERT INTO maintGroup (jobDescription, laborHours, pkgname)
  VALUES
        ('Tire rotation', '1.5', 'Ford Under CR-V 25k'),
        ('Valve adjustment', '4', 'HONDA Civic Under 25k'),
        ('Oil change', '0.5', 'MITSUBISHI Outlander Under 25k'),
        ('Transmission rebuild', '14', 'SUZUKI S-Cross Under 25k'),
       	('Break pads', '1.5', 'TOYOTA Prius Under 25k');


/*John DML End*/


/*Queries*/
/*1. List the customers.  For each customer, indicate which category he or she 
     fall into, and his or her contact information.*/
    SELECT "Steady", customerFirstName, customerLastName, customerEmail, customerPhone
        FROM steady
        NATURAL JOIN customer
        UNION
    SELECT "Premier", customerFirstName, customerLastName, customerEmail, customerPhone
        FROM premier
        NATURAL JOIN customer
    UNION
    SELECT "Prospect", customerFirstName, customerLastName, customerEmail, customerPhone
        FROM prospect
        NATURAL JOIN customer;
/*2*/
SELECT customerFirstName, customerLastName, orderDate AS "Transaction", laborHours * 40 AS "Total" 
FROM customer
INNER JOIN car USING (customerID)
INNER JOIN workOrder USING (carVin)
INNER JOIN orderLine USING (orderNumber);
GROUP BY customerFirstName, customerLastName, orderNumber AS "Transaction";


/*3*/
SELECT customerFirstName, customerLastName, SUM(laborHours * 40) AS "Total" 
FROM customer
INNER JOIN car using (customerID)
INNER JOIN workOrder USING (carVin)
INNER JOIN orderLine USING (orderNumber)
WHERE orderDate BETWEEN '2014-1-1' AND '2016-12-31'
GROUP BY customerFirstName, customerLastName
ORDER BY Total desc
limit 3;


/*5*/
/*List the mechanics who have 3 or more skills in common */
SELECT (S1.eID) AS 'Person 1 ID', (Select ename from employee where S1.eID = employee.eID)as 'person 1 name' , (S2.eID) AS 'Person 2 ID' , ename as 'person 2 name', count(employee.eID) as 'Common Skills' FROM employee
JOIN skill S1 on employee.eID = S1.eID
JOIN skill S2 on S1.eID != S2.eID
and S1.SKILLNAME = S2.SKILLNAME
GROUP BY (S1.eID) , (S2.eID)
HAVING COUNT(employee.eID) >= 3;


/*8*/
SELECT customerFirstName, customerLastName, SUM(laborHours * 40 *0.25) AS "Royalty"
FROM customer
INNER JOIN car using (customerID)
INNER JOIN workOrder USING (carVin)
INNER JOIN orderLine USING (orderNumber)
GROUP BY customerFirstName, customerLastName
ORDER BY Royalty desc;


/*11. List the three services that we have performed the most in the last year 
      and how many times they were performed. */
select workOrder.orderNumber, workOrder.orderDate, orderLine.jobDescription, count(*)
from workOrder
inner join orderLine using (orderNumber)
WHERE orderDate BETWEEN '2015-1-1' AND '2016-12-31'
GROUP BY workOrder.orderNumber, workOrder.orderDate, orderLine.jobDescription
order by  orderLine.jobDescription asc
limit 3;

/*13. Find the mechanic who is mentoring the most other mechanics.  List the 
      skills that the mechanic is passing along to the other mechanics.*/
select DISTINCT ename, skillName from employee 
inner join mechanic USING (eID)
inner join mentorship 
ON mentorship.mentorID = mechanic.eID
INNER JOIN skill
ON mentorship.mentorID = skill.eID
where mechanic.eID = (
select mentorID from mentorship
group by mentorID
order by count(*) desc
limit 1);




/*14. Find the three skills that have the fewest mechanics who have those skills*/
SELECT skillName FROM skill
ORDER BY skillName ASC  LIMIT 3;


/*15. SYNTAX ERROR*/
select ename from employee
inner join mechanic using (eID)
where ename in (
select ename from employee
inner join technician using (eID));


/*16. Four additional queries that you make up yourselves. One query per person.  
      Feel free to create additional views to support these queries if you so 
      desire.*/
 


/*Views*/
/*1. Customer_v – for each customer, indicate his or her name as well as the 
customer type (prospect, steady or premier) as well as the number of years that 
customer has been with us.*/
CREATE VIEW customer_info AS
SELECT "Steady", customerFirstName, customerLastName, (2016 - customerYear) AS "Years"
	FROM steady
	NATURAL JOIN customer
UNION
SELECT "Premier", customerFirstName, customerLastName, (2016 - customerYear) AS "Years"
	FROM premier
	NATURAL JOIN customer
UNION
SELECT "Prospect", customerFirstName, customerLastName, (2016 - customerYear) AS "Years"
	FROM prospect
	NATURAL JOIN customer;
GRANT SELECT ON customer_info TO public;


SELECT * FROM customer_info;


/*2. Customer_addresses_v – for each customer, indicate whether they are an
individual or a corporate account, and display all of the addresses that we are 
managing for that customer.*/


CREATE VIEW customer_address_v AS
SELECT "Private", customerFirstName, customerLastName, address, zipcode
	FROM private
	NATURAL JOIN customer
UNION
	SELECT "Corporate", customerFirstName, customerLastName, address, zipcode
	FROM corporate
	NATURAL JOIN address
	NATURAL JOIN customer;
GRANT SELECT ON customer_address_v TO public;

/* 5 5.	Prospective_resurrection_v – List all of the prospective customers 
who have had three or more contacts, and for whom the most recent contact 
was more than a year ago.  They might be ripe for another attempt.
*/
CREATE VIEW prospect_v AS
SELECT customerFirstName, customerLastName
    FROM customer    
    NATURAL JOIN prospect
    NATURAL JOIN contact
    WHERE DATEDIFF(CURDATE(), lastContactDate) > 365
    GROUP BY customerID
    HAVING COUNT(customerID) >= 3;
GRANT SELECT ON prospect_v TO public;


/* 1 of 4 additional query. mechanics that aren't technician*/
SELECT ename from employee
INNER JOIN mechanic USING (eID)
WHERE mechanic.eID NOT IN
(SELECT eID from technician );


/*2 of 4 additional query Find the most popular certificate among the mechanics*/
SELECT DISTINCT certName , certID from certification
INNER JOIN certificate_instance USING (certID)
WHERE certificate_instance.certID = ( SELECT certID FROM certificate_instance 
                GROUP BY certID
                ORDER BY COUNT(*) DESC 
                LIMIT 1);
                
