INSERT INTO ubc_members
(uteid, first_name, last_name, email, phone, birthdate)
VALUES ('dw29924', 'Derek', 'Wu', 'derekwu35@gmail.com', '2143269953', '12-AUG-99');

INSERT INTO ubc_member_committees
VALUES ('dw29924', 1);

UPDATE ubc_members 
SET first_name = 'Iggy'
WHERE uteid = 'ieo328';

UPDATE ubc_members 
SET phone = NULL
WHERE year_oc > 1;

UPDATE ubc_members 
SET year_oc = year_oc + 1;

DELETE FROM ubc_member_committees
WHERE uteid = 'dw29924';

DELETE FROM ubc_members
WHERE uteid = 'dw29924';

DELETE FROM ubc_member_committees
WHERE uteid IN 
(
    SELECT uteid
    FROM ubc_members
    WHERE year_oc = 4
);

SELECT vendor_id
FROM vendors
WHERE vendor_state = 'CA';

UPDATE invoices
SET invoice_date = '20-FEB-20'
WHERE vendor_id IN
(
    SELECT vendor_id
    FROM vendors
    WHERE vendor_state = 'CA'
);

DELETE FROM invoices
WHERE vendor_id IN 
(
    SELECT vendor_id
    FROM vendors
    WHERE vendor_state = 'CA'
);

ROLLBACK;