--1
SELECT COUNT (frequent_flyer_id) AS frequent_flyer_count, MIN(miles_balance) AS min_miles, MAX(miles_balance) AS max_miles
FROM frequent_flyer_profile;
--2
SELECT p.passenger_id, COUNT(payment_id) AS cards_on_file, MAX(expiration_date) AS latest_exp_data
FROM passenger p
JOIN passenger_payment pp
ON p.passenger_id = pp.passenger_id
GROUP BY p.passenger_id;
--3
SELECT mailing_city, COUNT(f.passenger_id) AS passenger_count, ROUND(AVG(miles_balance)) AS average_miles_balance
FROM passenger p 
JOIN frequent_flyer_profile f
ON p.passenger_id = f.passenger_id
GROUP BY mailing_city
ORDER BY average_miles_balance DESC;
--4
SELECT passenger_id, trip_contact_email, COUNT(DISTINCT f.flight_id) AS flight_count
FROM flight f
JOIN pass_resv_flight_linking l 
ON f.flight_id = l.flight_id
JOIN reservation r
ON l.reservation_id = r.reservation_id
GROUP BY passenger_id, trip_contact_email
ORDER BY flight_count DESC;
--5
SELECT first_name, last_name,
TRUNC((miles_balance - 5000)/10000, 0) AS vouchers_earned
FROM passenger p
JOIN frequent_flyer_profile f 
ON p.passenger_id = f.passenger_id 
GROUP BY first_name, last_name, TRUNC((miles_balance - 5000)/10000, 0)
HAVING TRUNC((miles_balance - 5000)/10000, 0) > 1
ORDER BY vouchers_earned DESC, last_name;
--5, 6
SELECT first_name, last_name,
TRUNC((miles_balance - 5000)/10000, 0) AS vouchers_earned
FROM passenger p
JOIN frequent_flyer_profile f 
ON p.passenger_id = f.passenger_id 
WHERE ff_level = 'G'
GROUP BY first_name, last_name, TRUNC((miles_balance - 5000)/10000, 0)
HAVING TRUNC((miles_balance - 5000)/10000, 0) > 1
ORDER BY vouchers_earned DESC, last_name;
--7 
SELECT mailing_city, gender, COUNT(flight_id) as flight_counts
FROM passenger p
JOIN pass_resv_flight_linking prf
ON p.passenger_id = prf.passenger_id
WHERE state_of_residence = 'TX'
GROUP BY ROLLUP(mailing_city, gender)
ORDER BY mailing_city, gender;
--CUBE gives a summary of every combination of groupings and the enitre data set while ORDER BY only does it for a specified column. 
--8
SELECT flight_number, departure_city, arrival_city, COUNT(DISTINCT passenger_id) as unique_passengers
FROM reservation r
JOIN pass_resv_flight_linking prf
ON r.reservation_id = prf.reservation_id
JOIN flight f
ON prf.flight_id = f.flight_id
GROUP BY flight_number, departure_city, arrival_city
HAVING COUNT(DISTINCT passenger_id) > 1
ORDER BY flight_number;
--9
SELECT DISTINCT employee_id, first_name, last_name
FROM employee 
WHERE employee_id in (
    SELECT assigned_employee
    FROM flight)
;
--10
SELECT frequent_flyer_id, ff_level, miles_balance
FROM frequent_flyer_profile
WHERE miles_balance > (
    SELECT AVG(miles_balance)
    FROM frequent_flyer_profile)
ORDER BY miles_balance;
--11
SELECT first_name, last_name, email, primary_phone, secondary_phone, mailing_city
FROM passenger
WHERE passenger_id IN (
    SELECT p.passenger_id
    FROM passenger p 
    LEFT JOIN pass_resv_flight_linking prf
    ON p.passenger_id = prf.passenger_id
    WHERE reservation_id IS NULL)
ORDER BY mailing_city;
--12
SELECT last_name, first_name, num_flight - num_seat as flight_no_seat
FROM
(
    SELECT p.passenger_id, last_name, first_name, COUNT(flight_id) as num_flight, COUNT(seat_assignment) as num_seat
    FROM passenger p
    JOIN pass_resv_flight_linking prf 
    ON p.passenger_id = prf.passenger_id
    GROUP BY p.passenger_id, last_name, first_name
    )
ORDER BY last_name;
--13
SELECT r.reservation_id, date_booked, seat_assignment
FROM reservation r
JOIN pass_resv_flight_linking prf
ON r.reservation_id = prf.reservation_id 
WHERE prf.seat_assignment IN (
    SELECT seat_assignment
    FROM pass_resv_flight_linking
    GROUP BY seat_assignment
    HAVING COUNT(seat_assignment) = 1
)
ORDER BY seat_assignment;
--14
SELECT DISTINCT iv.passenger_id, email, f.flight_id, TRUNC(SYSDATE - latest_date, 0) as dates_since_latest_booking
FROM (
    SELECT p.passenger_id, email, MAX(date_booked) as latest_date
    FROM passenger p
    JOIN pass_resv_flight_linking prf 
    ON p.passenger_id = prf.passenger_id
    JOIN reservation r
    ON prf.reservation_id = r.reservation_id
    GROUP BY p.passenger_id, email) iv
JOIN pass_resv_flight_linking prf 
ON iv.passenger_id = prf.passenger_id
JOIN flight f
ON prf.flight_id = f.flight_id;