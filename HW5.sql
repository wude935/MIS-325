--1
SELECT TRIM(SYSDATE) FROM dual;
SELECT TRIM(TO_CHAR(SYSDATE, 'YEAR')) FROM dual; 
SELECT TRIM(TO_CHAR(SYSDATE, 'DAY MONTH')) FROM dual;
SELECT TRIM(TO_CHAR(ROUND(SYSDATE, 'HH'), 'HH')) FROM dual;
SELECT TRIM(TRUNC(TO_DATE('31-DEC-20') - SYSDATE)) FROM dual;
SELECT TRIM(TO_CHAR(SYSDATE, 'mon dy YYYY')) FROM dual;

--2
SELECT flight_id, flight_number, 'Leaving on ' || TO_CHAR(departure_datetime, 'Day, Mon DD, YYYY') as departure_day,
    'Leaving from ' || CASE departure_city
        WHEN 'SAN' THEN 'San Diego'
        WHEN 'HOU' THEN 'Houston'
        WHEN 'ABQ' THEN 'Albaquerque'
        WHEN 'SAT' THEN 'San Antonio'
        WHEN 'LAS' THEN 'Las Vegas'
        WHEN 'DEN' THEN 'Denver'
        WHEN 'PHX' THEN 'Phoenix'
        WHEN 'DAL' THEN 'Dallas'
    END as departure_plan
FROM flight;

--3
SELECT SUBSTR(first_name, 1,1) || '. ' || last_name as passenger_name, NVL(seat_assignment, 'Need to add')
FROM passenger p
INNER JOIN pass_resv_flight_linking prfl
ON p.passenger_id = prfl.passenger_id;

--4
SELECT LOWER(frequent_flyer_id) as FF_ID, TRIM(TO_CHAR(miles_balance/100, '$99999')) as point_dollars, TO_CHAR(ROUND(miles_balance/600), '99999') || '%' as freeflight_percent
FROM frequent_flyer_profile;

--5
SELECT cardholder_last_name, LENGTH(billing_address) as billing_address_length, ROUND(expiration_date - SYSDATE) as days_until_card_expiration
FROM passenger_payment
WHERE ROUND(expiration_date - SYSDATE) < 0;

--6
SELECT cardholder_last_name, SUBSTR(billing_address, 1, INSTR(billing_address, ' ')) as street_num, SUBSTR(billing_address, INSTR(billing_address, ' ')) as street_name, NVL2(cardholder_mid_name, 'Does List', 'None Listed') as mid_name_listed, billing_city, billing_state, billing_zip
FROM passenger_payment;

--7 
SELECT first_name, last_name, LPAD(SUBSTR(cardnumber, LENGTH(cardnumber)-3), LENGTH(cardnumber), '*') as redacted_card_num
--hard-coded method: '****-****-****-' || SUBSTR(cardnumber, LENGTH(cardnumber)-3) as redacted_card_num
FROM passenger p
JOIN passenger_payment pp
ON p.passenger_id = pp.passenger_id
WHERE cardtype != 'AMEX';

--8
SELECT
CASE
    WHEN miles_balance > 75000 THEN '1-Top-Tier'
    WHEN miles_balance >= 25000 THEN '2-Mid-Tier'
    WHEN miles_balance < 25000 THEN '3-Lower-Tier'
END
as customer_tier, frequent_flyer_id, ff_level, miles_balance
FROM frequent_flyer_profile
ORDER BY miles_balance DESC;

--9
SELECT first_name, last_name, frequent_flyer_id, email, miles_balance, DENSE_RANK() OVER(ORDER BY miles_balance DESC) as Passenger_Rank
FROM passenger p
JOIN frequent_flyer_profile ffp
ON p.passenger_id = ffp.passenger_id;

--10
SELECT * 
FROM (
    SELECT ROW_NUMBER() OVER(ORDER BY miles_balance DESC) as row_number, first_name, last_name, frequent_flyer_id, email, miles_balance
    FROM passenger p
    JOIN frequent_flyer_profile ffp
    ON p.passenger_id = ffp.passenger_id
)
WHERE row_number = 4;

