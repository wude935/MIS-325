SET SERVEROUTPUT ON;
--1
DECLARE 
    count_flight_var NUMBER;
BEGIN
    SELECT COUNT(flight_id) 
    INTO count_flight_var
    FROM flight
    WHERE departure_city = 'SAT';
    
    IF count_flight_var > 30 THEN 
        DBMS_OUTPUT.PUT_LINE('The number of flights from San Antonio is greater than 30.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('The number of flights from San Antonio is less than or equal to 30.');
    END IF;
END;
/
--2
DECLARE 
    departure_city_var VARCHAR2(3);
    count_flight_var NUMBER;
BEGIN
    departure_city_var := '&departure_city';
    SELECT COUNT(flight_id) 
    INTO count_flight_var
    FROM flight
    WHERE departure_city = departure_city_var;
    
    IF count_flight_var > 30 THEN 
        DBMS_OUTPUT.PUT_LINE('The number of flight from ' || departure_city_var || ' is greater than 30.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('The number of flights from ' || departure_city_var || ' is less than or equal to 30.');
    END IF;
END;
/
--3
--adds a new flight 165 by following the established pattern: increasing the day by one and swapping the two employees who regularly schedule the flight
DECLARE
    flight_id_var NUMBER;
    departure_datetime_var DATE;
    assigned_employee_var NUMBER;
BEGIN
    SELECT * 
    INTO flight_id_var, departure_datetime_var, assigned_employee_var
    FROM (
        SELECT flight_id, departure_datetime, assigned_employee
        FROM flight
        WHERE flight_number = 165
        ORDER BY departure_datetime DESC )
    WHERE ROWNUM = 1;
    
    INSERT INTO flight
    VALUES (
    flight_id_seq.nextval,
    165,
    departure_datetime_var + 1,
    'SAT',
    'PHX',
    CASE assigned_employee_var
        WHEN 100022 then 100028
        WHEN 100028 then 100022
    END);
    DBMS_OUTPUT.PUT_LINE('1 row was inserted into the flight table.');
EXCEPTION
    WHEN OTHERS THEN    
        DBMS_OUTPUT.PUT_LINE('Row was not inserted. Unexpected exception occurred.');
END;
/
--4
DECLARE
--creates a record that contain multiple columns and then creates a table that holds the record
    TYPE multi_record IS RECORD (passenger_id NUMBER(10), seat_assignment VARCHAR2(100));
    TYPE multi_table IS TABLE OF multi_record;
    multi_list multi_table;
BEGIN 
    SELECT passenger_id, seat_assignment
    BULK COLLECT INTO multi_list
    FROM pass_resv_flight_linking
    WHERE flight_id = 25
    ORDER BY passenger_id ASC;
    
    FOR i IN 1..multi_list.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Passenger ' || multi_list(i).passenger_id || ' has been assigned seat ' || multi_list(i).seat_assignment);
    END LOOP;
END;
/
--5
CREATE OR REPLACE FUNCTION count_flights 
(
    flight_number_param NUMBER
)
RETURN NUMBER
AS flight_count_var NUMBER;
BEGIN 
    SELECT count(flight_id)
    INTO flight_count_var
    FROM flight
    WHERE flight_number = flight_number_param;
    
    RETURN flight_count_var;
END;
/
SELECT flight_number, 
count_flights(flight_number) as count_of_flights
FROM flight;
--extra credit
SELECT flight_number, COUNT(flight_id) AS count_of_flights
FROM flight
GROUP BY flight_number;

--6
SELECT mailing_address, mailing_city, mailing_state, mailing_zip
FROM employee
WHERE employee_id = 100010;

CREATE OR REPLACE PROCEDURE update_employee_mailing
(
    employee_id_param NUMBER,
    mailing_address_param VARCHAR2,
    mailing_city_param VARCHAR2,
    mailing_state_param VARCHAR2,
    mailing_zip_param NUMBER
)
AS
BEGIN 
    UPDATE employee
    SET 
        mailing_address = mailing_address_param, 
        mailing_city = mailing_city_param,
        mailing_state = mailing_state_param,
        mailing_zip = mailing_zip_param
    WHERE employee_id = employee_id_param;
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN 
        ROLLBACK;
END;
/

CALL update_employee_mailing(100010, '1234 Happy Street', 'AUSTIN', 'TX', 78705)

SELECT mailing_address, mailing_city, mailing_state, mailing_zip
FROM employee
WHERE employee_id = 100010;
--7
CREATE OR REPLACE PROCEDURE insert_flight
(
    flight_id_param NUMBER DEFAULT flight_id_seq.NEXTVAL,
    flight_number_param VARCHAR2,
    departure_datetime_param DATE,
    departure_city_param CHAR,
    arrival_city_param CHAR,
    assigned_employee_param NUMBER
)
AS
BEGIN
    INSERT INTO flight
    VALUES (
        flight_id_seq.NEXTVAL,
        flight_number_param,
        SYSDATE,
        departure_city_param,
        arrival_city_param,
        assigned_employee_param
    );
    DBMS_OUTPUT.PUT_LINE('1 row was inserted into the flight table.');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN    
        DBMS_OUTPUT.PUT_LINE('Row was not inserted. Unexpected exception occurred.');
        ROLLBACK;
END;
/

CALL insert_flight(flight_id_seq.NEXTVAL, 131, SYSDATE, 'SAT', 'DAL', 100023);
CALL insert_flight(flight_id_seq.NEXTVAL, 161, SYSDATE - 1, 'SAT', 'HOU', 100024);
--8
CREATE OR REPLACE FUNCTION ff_miles_lookup 
(
    passenger_id_param NUMBER
)
RETURN NUMBER
AS ff_miles_var NUMBER;
BEGIN 
    SELECT miles_balance
    INTO ff_miles_var
    FROM frequent_flyer_profile ffp
    JOIN passenger p
    ON ffp.passenger_id = p.passenger_id
    WHERE ffp.passenger_id = passenger_id_param;
    
    RETURN ff_miles_var;
END;
/

SELECT first_name, last_name, email, ff_miles_lookup(passenger_id) as passenger_miles
FROM passenger; 
