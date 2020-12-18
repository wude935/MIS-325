--1
SELECT first_name, last_name, email, primary_phone
FROM Passenger
WHERE ROWNUM <= 5
ORDER BY last_name;
--2
SELECT first_name || ' ' || last_name as passenger_full_name
FROM Passenger
WHERE last_name LIKE 'A%' OR last_name LIKE 'B%' OR last_name LIKE 'C%';
--3
SELECT employee_id, first_name, last_name, birthday, mailing_address
FROM Employee
WHERE birthday > '01-JAN-70' AND birthday <= '31-DEC-79'
ORDER BY birthday desc;
--4
SELECT employee_id, first_name, last_name, birthday, mailing_address
FROM Employee
WHERE birthday BETWEEN '01-JAN-70' AND '31-DEC-79'
ORDER BY birthday desc;
--5
SELECT passenger_id, frequent_flyer_id, ff_level as status, miles_balance as miles_earned, TRUNC(miles_balance/12500, 0) as free_flights
FROM frequent_flyer_profile
WHERE ROWNUM <= 8
ORDER BY miles_earned DESC;
--6
SELECT passenger_id, frequent_flyer_id, ff_level as status_level, miles_balance as balance
FROM frequent_flyer_profile
WHERE TRUNC((miles_balance-5000)/10000)>4;
--7
SELECT first_name, last_name, mailing_address_1, mailing_address_2, mailing_state, mailing_zip
FROM Passenger
WHERE mailing_address_2 IS NOT NULL;
--8
SELECT SYSDATE as today_unformatted, TO_CHAR(SYSDATE, 'MM/DD/YYY') as today_formatted, price, tax_rate, price * tax_rate as tax_sum, price * tax_rate + price as final_total
FROM 
(
    SELECT 100 as price, .0825 as tax_rate
    FROM DUAL
);
--9
SELECT * 
FROM 
(
    SELECT passenger_id, frequent_flyer_id, ff_level, miles_balance
    FROM Frequent_Flyer_Profile
    ORDER BY miles_balance DESC
)
WHERE ROWNUM <= 5;
--10 
SELECT ff_level as status, first_name, last_name
FROM Passenger p 
JOIN Frequent_Flyer_Profile f
ON p.passenger_id = f.passenger_id
ORDER BY miles_balance DESC;
--11
SELECT reservation_id, first_name || ' ' || last_name as passenger_name, flight_id, seat_assignment
FROM Passenger p
JOIN Pass_Resv_Flight_Linking prf
ON p.passenger_id = prf.passenger_id
WHERE email = 'meredithburrel@pmail.com';
--12
SELECT departure_city, arrival_city, first_name, last_name, seat_assignment, checked_in_flag
FROM Passenger p 
JOIN Pass_Resv_Flight_Linking prf
ON p.passenger_id = prf.passenger_id
JOIN Flight f 
ON prf.flight_id = f.flight_id
WHERE prf.flight_id = 44
ORDER BY last_name;
--13
SELECT DISTINCT first_name, last_name, email
FROM Passenger p
LEFT JOIN reservation r 
ON p.passenger_id = r.reservation_id
ORDER BY last_name;
--14
    SELECT '1-Top-Tier' AS passenger_tier, frequent_flyer_id, ff_level, miles_balance
    FROM Frequent_Flyer_Profile
    WHERE miles_balance > 75000
UNION
    SELECT '2-Mid-Tier' AS passenger_tier, frequent_flyer_id, ff_level, miles_balance
    FROM Frequent_Flyer_Profile
    WHERE miles_balance >= 25000 AND miles_balance <= 75000
UNION
    SELECT '3-Low-Tier' AS passenger_tier, frequent_flyer_id, ff_level, miles_balance
    FROM Frequent_Flyer_Profile
    WHERE miles_balance < 25000
ORDER BY miles_balance DESC;
