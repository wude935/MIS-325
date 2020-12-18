CREATE OR REPLACE PROCEDURE insert_vendor_contact 
( 
    vendor_id_param NUMBER,
    first_name_param VARCHAR2 DEFAULT '?', 
    last_name_param VARCHAR2
)
AS 
BEGIN 
    INSERT INTO vendor_contacts
    VALUES (vendor_id_param, last_name_param, first_name_param);
END;
/

--Call 1 
CALL insert_vendor_contact(1,'Thorton','Bob');
--Call 2
BEGIN  insert_vendor_contact(2,'Williams','Selma');
END;
/
--Call 2 By Name
BEGIN  insert_vendor_contact(2,first_name_param => 'Selma',last_name_param=>'Williams');
END;


CREATE OR REPLACE FUNCTION invoice_count
(
    vendor_id_param NUMBER
)
RETURN NUMBER 
AS invoice_count_var NUMBER;
BEGIN
    SELECT COUNT(invoice_id)
    INTO invoice_count_var
    FROM invoices
    WHERE vendor_id = vendor_id_param
    GROUP BY vendor_id;
    
    RETURN invoice_count_var;
END; 
/

SELECT vendor_id, vendor_name, invoice_count(vendor_id)
FROM vendors
WHERE invoice_count(vendor_id) > 0;
