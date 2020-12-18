--Regular SQL
SELECT SUM(invoice_total - payment_total - credit_total) AS balance_due
FROM invoices
WHERE vendor_id = 95;

--PL-SQL
SET SERVEROUTPUT ON;
DECLARE  sum_balance_due_var NUMBER(9, 2);
BEGIN
    SELECT SUM(invoice_total - payment_total - credit_total) balance_due
    INTO sum_balance_due_var
    FROM invoices
    WHERE vendor_id = 95; 
    IF sum_balance_due_var > 0 THEN DBMS_OUTPUT.PUT_LINE('Balance due: $' || ROUND(sum_balance_due_var, 2));  
    ELSE DBMS_OUTPUT.PUT_LINE('Balance paid in full');
    END IF;
EXCEPTION  
    WHEN OTHERS THEN  DBMS_OUTPUT.PUT_LINE('An error occurred');
END;
/

--Regular SQL
SELECT SUM(invoice_total - payment_total - credit_total) AS balance_due
FROM invoices
WHERE vendor_id = 34;

--PL-SQL
SET SERVEROUTPUT ON;
DECLARE  sum_balance_due_var NUMBER(9, 2);
BEGIN
    SELECT SUM(invoice_total - payment_total - credit_total) balance_due
    INTO sum_balance_due_var
    FROM invoices
    WHERE vendor_id = 34; 
    IF sum_balance_due_var > 0 THEN DBMS_OUTPUT.PUT_LINE('Balance due: $' || ROUND(sum_balance_due_var, 2));  
    ELSE DBMS_OUTPUT.PUT_LINE('Balance paid in full');
    END IF;
EXCEPTION  
    WHEN OTHERS THEN  DBMS_OUTPUT.PUT_LINE('An error occurred');
END;
/

DECLARE 
    my_age_var NUMBER(3) := 20;
BEGIN 
    DBMS_OUTPUT.PUT_LINE('Hello, my name is Derek.');
    DBMS_OUTPUT.PUT_LINE('I am ' || my_age_var || ' years old.');
END;
/

SET DEFINE ON
--DECLARE 
--    user_defined_age_var NUMBER(3);
BEGIN 
    :user_defined_age_var :=  &Your_age;
    DBMS_OUTPUT.PUT_LINE('Hello, my name is Derek.');
    DBMS_OUTPUT.PUT_LINE('I am ' || :user_defined_age_var || ' years old.');
END;
/