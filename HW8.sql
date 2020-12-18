--2
CREATE TABLE client_dw (
id_ NUMBER,
first_name VARCHAR(50),
last_name VARCHAR(50),
email VARCHAR(50),
zip CHAR(5),
phone VARCHAR(12),
data_source VARCHAR(4),
CONSTRAINT client_dw_pk PRIMARY KEY (id_, data_source));

--3
CREATE OR REPLACE VIEW passenger_view AS
    SELECT 
        passenger_id, 
        first_name, 
        last_name, 
        email, 
        mailing_zip as zip_code, 
        REPLACE(primary_phone,'-', '') as phone
    FROM passenger;
    
CREATE OR REPLACE VIEW prospective_client_view AS
    SELECT 
        prospective_id, 
        pc_first_name as first_name, 
        pc_last_name as last_name, 
        email, 
        zip_code, 
        phone
    FROM prospective_client;

--4, 5, 6
CREATE OR REPLACE PROCEDURE client_etl_proc
AS 
BEGIN 
    MERGE INTO client_dw dw
    USING
    (SELECT * FROM passenger_view) p
    ON (dw.id_ = p.passenger_id)
    WHEN MATCHED THEN 
        UPDATE SET
        dw.first_name = p.first_name,
        dw.last_name = p.last_name, 
        dw.email = p.email,
        dw.zip = p.zip_code,
        dw.phone = SUBSTR(p.phone,1, 3) || '-' || SUBSTR(p.phone, 4, 3) || '-' || SUBSTR(p.phone, 7, 4)
        WHERE dw.data_source = 'PASS'
    WHEN NOT MATCHED THEN
        INSERT
        (id_, first_name, last_name, email, zip, phone, data_source)
        VALUES (p.passenger_id, p.first_name, p.last_name, p.email, p.zip_code, SUBSTR(p.phone,1, 3) || '-' || SUBSTR(p.phone, 4, 3) || '-' || SUBSTR(p.phone, 7, 4), 'PASS');
    
    MERGE INTO client_dw dw
    USING
    (SELECT * FROM prospective_client_view) p
    ON (dw.id_ = p.prospective_id)
    WHEN MATCHED THEN 
        UPDATE SET
        dw.first_name = p.first_name,
        dw.last_name = p.last_name, 
        dw.email = p.email,
        dw.zip = p.zip_code,
        dw.phone = SUBSTR(p.phone,1, 3) || '-' || SUBSTR(p.phone, 4, 3) || '-' || SUBSTR(p.phone, 7, 4)
        WHERE dw.data_source = 'PROS'
    WHEN NOT MATCHED THEN
        INSERT
        (id_, first_name, last_name, email, zip, phone, data_source)
        VALUES (p.prospective_id, p.first_name, p.last_name, p.email, p.zip_code, SUBSTR(p.phone,1, 3) || '-' || SUBSTR(p.phone, 4, 3) || '-' || SUBSTR(p.phone, 7, 4), 'PROS');
        
        COMMIT;
END;
/