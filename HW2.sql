--Derek Wu (dw29924), runs drop statements on sequences and tables so script can be used again 
DROP SEQUENCE passenger_id_seq;
DROP SEQUENCE payment_id_seq;
DROP SEQUENCE flight_id_seq;
DROP SEQUENCE reservation_id_seq;
DROP SEQUENCE employee_id_seq;

DROP TABLE Pass_Resv_Flight_Linking;
DROP TABLE Flight;
DROP TABLE Employee;
DROP TABLE Reservation;
DROP TABLE Frequent_Flyer_Profile;
DROP TABLE Passenger_Payment;
DROP TABLE Passenger;

-- Derek Wu (dw29924), section creates sequences and then creates tables
CREATE SEQUENCE passenger_id_seq;
CREATE SEQUENCE payment_id_seq;
CREATE SEQUENCE flight_id_seq;
CREATE SEQUENCE reservation_id_seq;
CREATE SEQUENCE employee_id_seq
START WITH 100001; 

CREATE TABLE Passenger
(
    Passenger_ID NUMBER DEFAULT passenger_id_seq.NEXTVAL PRIMARY KEY NOT NULL,
    First_Name VARCHAR(100) NOT NULL,
    Middle_Name VARCHAR(100),
    Last_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Gender CHAR(1) NOT NULL,
    Country_of_Residence VARCHAR(100) NOT NULL,
    State_of_Residence CHAR(2) NOT NULL,
    Mailing_Address_1 VARCHAR(100) NOT NULL,
    Mailing_Address_2 VARCHAR(100),
    Mailing_City VARCHAR(100) NOT NULL,
    Mailing_State CHAR(2) NOT NULL,
    Mailing_Zip CHAR(5) NOT NULL,
    Primary_Phone CHAR(12) NOT NULL,
    Secondary_Phone CHAR(12),
    CONSTRAINT email_length_check CHECK (LENGTH(Email) >= 7)
);

CREATE TABLE Passenger_Payment 
(
    Payment_ID NUMBER DEFAULT payment_id_seq.NEXTVAL PRIMARY KEY NOT NULL,
    Passenger_ID NUMBER REFERENCES Passenger(Passenger_ID) NOT NULL,
    Cardholder_First_Name VARCHAR(100) NOT NULL,
    Cardholder_Mid_Name VARCHAR(100) NOT NULL,
    Cardholder_Last_Name VARCHAR(100) NOT NULL,
    CardType VARCHAR(100) NOT NULL,
    CardNumber VARCHAR(100) NOT NULL,
    Expiration_Date DATE NOT NULL,
    CC_ID CHAR(10) NOT NULL,
    Billing_Address VARCHAR(100) NOT NULL,
    Billing_City VARCHAR(100) NOT NULL,
    Billing_State CHAR(2) NOT NULL,
    Billing_Zip CHAR(5) NOT NULL
);

CREATE TABLE Frequent_Flyer_Profile
(
    Passenger_ID NUMBER REFERENCES Passenger(Passenger_ID) PRIMARY KEY NOT NULL,
    Frequent_Flyer_ID NUMBER UNIQUE NOT NULL,
    Password VARCHAR(100) NOT NULL,
    Frequent_Flyer_Level VARCHAR(1) CHECK (Frequent_Flyer_Level = 'B' OR Frequent_Flyer_Level = 'S' OR Frequent_Flyer_Level = 'G' OR Frequent_Flyer_Level = 'P') NOT NULL,
    Miles_Balance NUMBER DEFAULT 5000 NOT NULL
);

CREATE TABLE Reservation
(
    Reservation_ID NUMBER DEFAULT reservation_id_seq.NEXTVAL PRIMARY KEY NOT NULL, 
    Confirmation_Number VARCHAR(100) UNIQUE NOT NULL,
    Confirmation_Date DATE DEFAULT SYSDATE NOT NULL,
    Trip_Contact_Email VARCHAR(100) CHECK (LENGTH(Trip_Contact_Email) >= 7) NOT NULL,
    Trip_Contact_Phone CHAR(12) NOT NULL
);

CREATE TABLE Employee
(
    Employee_ID NUMBER DEFAULT employee_id_seq.NEXTVAL PRIMARY KEY NOT NULL,
    First_Name VARCHAR(100) NOT NULL,
    Last_Name VARCHAR(100) NOT NULL,
    Birtday DATE NOT NULL,
    Tax_ID_Number NUMBER UNIQUE NOT NULL,
    Mailing_Address VARCHAR(100) NOT NULL,
    Mailing_City VARCHAR(100) NOT NULL,
    Mailing_State CHAR(2) NOT NULL,
    Mailing_Zip CHAR(5) NOT NULL,
    Emp_Level CHAR(1) CHECK (Emp_Level = '1' OR Emp_Level = '2' OR Emp_Level = '3') NOT NULL
);

CREATE TABLE Flight 
(
    Flight_ID NUMBER DEFAULT flight_id_seq.NEXTVAL PRIMARY KEY NOT NULL,
    Flight_Number VARCHAR(100) NOT NULL, 
    Departure_DateTime DATE NOT NULL,
    Departure_City CHAR(3) NOT NULL,
    Arrival_City CHAR(3) NOT NULL,
    Assigned_Employee NUMBER REFERENCES Employee(Employee_ID)
);

CREATE TABLE Pass_Resv_Flight_Linking
(
    Passenger_ID NUMBER NOT NULL,
    Reservation_ID NUMBER NOT NULL,
    Flight_ID NUMBER NOT NULL,
    Seat_Assignment VARCHAR(100),
    Ticket_Number VARCHAR(100),
    Checked_In_Flag CHAR(1) NOT NULL,
    Boarded_Flag CHAR(1) NOT NULL,
    CONSTRAINT Pass_Resv_Flight_Linking_passenger_fk    FOREIGN KEY(Passenger_ID)      REFERENCES Passenger(Passenger_ID),
    CONSTRAINT Pass_Resv_Flight_Linking_reservation_fk  FOREIGN KEY(Reservation_ID)    REFERENCES Reservation(Reservation_ID),
    CONSTRAINT Pass_Resv_Flight_Linking_flight_fk       FOREIGN KEY(Flight_ID)         REFERENCES Flight(Flight_ID),
    CONSTRAINT Pass_Resv_Flight_Linking_pk PRIMARY KEY(Passenger_ID, Reservation_ID, Flight_ID) 
);

--Derek Wu (dw29924), section inserts test values for the tables created above
INSERT INTO Passenger
VALUES (DEFAULT, 'Derek', 'Yitao', 'Wu', 'dw29924@utexas.edu', 'M', 'USA', 
'TX', '2100 San Antonio', NULL, 'Austin', 'TX', '78705', '214-326-9953', NULL);

INSERT INTO Passenger
VALUES (passenger_id_seq.NEXTVAL, 'Clint', 'Bob', 'Tuttle', 'clint.tuttle@utexas.edu', 'M', 'USA', 
'TX', '1000 San Jacinto', NULL, 'Austin', 'TX', '78705', '111-111-1111', NULL);

COMMIT;

INSERT INTO Frequent_Flyer_Profile
VALUES (1, 1, 'password', 'G', DEFAULT);

INSERT INTO Frequent_Flyer_Profile 
VALUES (2, 2, 'password', 'B', DEFAULT);

COMMIT; 

INSERT INTO Passenger_Payment
VALUES(DEFAULT, 1, 'Derek', 'Yitao', 'Wu', 'Visa', '123456789', '30-MAY-2022',
'000', '2100 San Antonio', 'Austin', 'TX', '78705');

INSERT INTO Passenger_Payment
VALUES(DEFAULT, 1, 'Derek', 'Yitao', 'Wu', 'Visa', '123456790', '11-APR-2022',
'001', '4585 Firewheel Dr.', 'New York', 'NY', '11111');

INSERT INTO Passenger_Payment
VALUES (DEFAULT, 2, 'Clint', 'Bob', 'Tuttle', 'Visa', '123456791', '23-OCT-2020', '002',
'1000 San Jacinto', 'Austin', 'TX', '78705');

COMMIT;

INSERT INTO Employee
VALUES(DEFAULT, 'Jake', 'Peralta', '13-MAY-1980', 6666666666, '99 Brooklyn Ave',
'San Antonio', 'TX', '77777', '2');

INSERT INTO Employee
VALUES(DEFAULT, 'Amy', 'Santiago', '20-JUN-1981', 6666666667, '55 Brooklyn Ave',
'San Antonio', 'TX', '77778', '3');

INSERT INTO Employee
VALUES(DEFAULT, 'Jim', 'Halpert', '12-AUG-1980', 6666666668, '111 Scranton Ave',
'El Paso', 'TX', '88888', '1');

INSERT INTO Employee
VALUES(DEFAULT, 'Pam', 'Beasley', '13-MAY-1981', 6666666669, '112 Scranton Ave',
'El Paso', 'TX', '88889', '2');

INSERT INTO Employee
VALUES(DEFAULT, 'Ben', 'Wyatt', '1-DEC-1978', 6666666670, '1111 Pawnee Ave',
'San Diego', 'TX', '99999', '2');

INSERT INTO Employee
VALUES(DEFAULT, 'Leslie', 'Knope', '27-FEB-1985', 6666666671, '1112 Pawnee Ave',
'San Diego', 'TX', '99100', '3');

COMMIT;

INSERT INTO Flight
VALUES(DEFAULT, 231, TO_DATE ('01-JUN-2020 8:00:00', 'DD-MON-YYYY HH24:MI:SS'), 'SAT', 'ELP', 100001);

INSERT INTO Flight
VALUES(DEFAULT, 232, TO_DATE ('01-JUN-2020 11:00:00', 'DD-MON-YYYY HH24:MI:SS'), 'ELP', 'SAN', 100002);

INSERT INTO Flight
VALUES(DEFAULT, 451, TO_DATE ('01-JUN-2020 15:00:00', 'DD-MON-YYYY HH24:MI:SS'), 'SAN', 'ELP', 100003);

INSERT INTO Flight
VALUES(DEFAULT, 452, TO_DATE ('01-JUN-2020 17:00:00', 'DD-MON-YYYY HH24:MI:SS'), 'ELP', 'SAT', 100004);

INSERT INTO Flight
VALUES(DEFAULT, 231, TO_DATE ('02-JUN-2020 8:00:00', 'DD-MON-YYYY HH24:MI:SS'), 'SAT', 'ELP', 100005);

INSERT INTO Flight
VALUES(DEFAULT, 232, TO_DATE ('02-JUN-2020 11:00:00', 'DD-MON-YYYY HH24:MI:SS'), 'ELP', 'SAN', 100004);

INSERT INTO Flight
VALUES(DEFAULT, 451, TO_DATE ('02-JUN-2020 15:00:00', 'DD-MON-YYYY HH24:MI:SS'), 'SAN', 'ELP', 100006);

INSERT INTO Flight
VALUES(DEFAULT, 452, TO_DATE ('02-JUN-2020 17:00:00', 'DD-MON-YYYY HH24:MI:SS'), 'ELP', 'SAT', 100002);

COMMIT;



INSERT INTO Reservation
VALUES(DEFAULT, 11111111 , DEFAULT, 'dw29924@utexas.edu', '972-971-2139');

COMMIT;

INSERT INTO Pass_Resv_Flight_Linking
VALUES(1, 1, 1, '32A', NULL, 'N', 'N');

INSERT INTO Pass_Resv_Flight_Linking
VALUES(2, 1, 1, '32B', NULL, 'N', 'N');

INSERT INTO Pass_Resv_Flight_Linking
VALUES(1, 1, 2, '12C', NULL, 'N', 'N');

INSERT INTO Pass_Resv_Flight_Linking
VALUES(2, 1, 2, '12B', NULL, 'N', 'N');

INSERT INTO Pass_Resv_Flight_Linking
VALUES(1, 1, 7, '20A', NULL, 'N', 'N');

INSERT INTO Pass_Resv_Flight_Linking
VALUES(2, 1, 7, '20B', NULL, 'N', 'N');

INSERT INTO Pass_Resv_Flight_Linking
VALUES(1, 1, 8, '4B', NULL, 'N', 'N');

INSERT INTO Pass_Resv_Flight_Linking
VALUES(2, 1, 8, '4C', NULL, 'N', 'N');

COMMIT;

--Derek Wu (dw29924), section creates indexes for the tables for the purpose of speeding up queries
CREATE INDEX passenger_payment_passenger_id_ix ON Passenger_Payment(passenger_ID);
CREATE INDEX flight_assigned_employee_ix ON flight(assigned_employee);
CREATE INDEX passenger_primary_phone_ix ON passenger(primary_phone);
CREATE INDEX flight_flight_number_ix ON flight(flight_number);

