/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 3: using SQL SERVER 2012 and the FiredUp database
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   Adam W. Lindsey
                DATE:      OCT 09, 2013

*******************************************************************************************
*/

USE FiredUp    -- ensures correct database is active


GO
PRINT '|---' + REPLICATE('+----',15) + '|'
PRINT 'Read the questions below and insert your queries where prompted.  When  you are finished,
you should be able to run the file as a script to execute all answers sequentially (without errors!)' + CHAR(10)
PRINT 'Queries should be well-formatted.  SQL is not case-sensitive, but it is good form to
capitalize keywords and table names; you should also put each projected column on its own line
and use indentation for neatness.  Example:

   SELECT Name,
          CustomerID
   FROM   CUSTOMER
   WHERE  CustomerID < 106;

All SQL statements should end in a semicolon.  Whatever format you choose for your queries, make
sure that it is readable and consistent.' + CHAR(10)
PRINT 'Be sure to remove the double-dash comment indicator when you insert your code!';
PRINT '|---' + REPLICATE('+----',15) + '|' + CHAR(10) + CHAR(10)
GO


GO
PRINT 'CIS2275, Lab Week 3, Question 1  [3pts possible]:
Display each StateProvince value in the CUSTOMER table; eliminate duplicate values in your results.' + CHAR(10)
--
SELECT DISTINCT StateProvince
FROM CUSTOMER;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 3, Question 2  [3pts possible]:
Project the all columns from the PURCHASE_ORDER table; limit your results to suppliers 802 and 803.
Use the OR condition in your WHERE clause.' + CHAR(10)
--
SELECT *
FROM PURCHASE_ORDER
WHERE FK_SupplierNbr = 802
   OR FK_SupplierNbr = 803;
--
GO



GO
PRINT CHAR(10) + 'CIS2275, Lab Week 3, Question 3  [3pts possible]:
Project the all columns from the PURCHASE_ORDER table; limit your results to suppliers 802 and 803.
Use the IN condition in your WHERE clause.' + CHAR(10)
--
SELECT *
FROM PURCHASE_ORDER
WHERE FK_SupplierNbr IN (802,803);
--
GO



GO
PRINT CHAR(10) + 'CIS2275, Lab Week 3, Question 4  [3pts possible]:
Show the name and title  for all employees with an EmpID value less than 6:' + CHAR(10)
--
SELECT Name,
	   Title
FROM EMPLOYEE
WHERE EmpID < 6;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 3, Question 5  [3pts possible]:
Display the invoice number and customer ID for all records in the INVOICE table which have a TotalPrice
value less than $100; sort the results by customer ID (in descending order).' + CHAR(10)
--
SELECT InvoiceNbr,
	   FK_CustomerID
FROM INVOICE
WHERE TotalPrice < 100
ORDER BY FK_CustomerID DESC;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 3, Question 6  [3pts possible]:
Show the Type and Version of every stove in the STOVE table - except the ones which are RED or BLUE.
Sort your results in order of Type, then Version; eliminate duplicate values.' + CHAR(10)
--
SELECT DISTINCT
	 Type,
	 Version
FROM STOVE
WHERE Color NOT LIKE 'RED%'
  AND Color NOT LIKE 'BLUE%'
ORDER BY Type,
		 Version;


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 3, Question 7  [3pts possible]:
Show the invoice number and total price from the INVOICE table for all of the invoices for customer number 125.
List them in order of invoice date, and re-name the columns using AS.' + CHAR(10)
--
SELECT InvoiceNbr AS invoice_number,
	   '$' + STR(TotalPrice,8,2) AS total_price
FROM INVOICE
WHERE FK_CustomerID = 125
ORDER BY InvoiceDt;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 3, Question 8  [3pts possible]:
Get the information for all invoices which have a total price between $100 and $200 (inclusive); show the invoice 
number, total price, and employee number.  Order the output by invoice number.' + CHAR(10)
--
SELECT InvoiceNbr AS invoice_number,
	   '$' + STR(TotalPrice,8,2) AS total_price,
	   FK_EmpID AS employee_ID
FROM INVOICE
WHERE TotalPrice BETWEEN 100 AND 200
ORDER BY InvoiceNbr;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 3, Question 9  [3pts possible]:
Display all columns from the PART table for Grill and Widget parts (i.e. the Description value begins
with either of those two words - use LIKE and a wildcard to match).' + CHAR(10)
--
SELECT *
FROM PART
WHERE Description LIKE 'Grill%'
   OR Description LIKE 'Widget%';
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 3, Question 10  [3pts possible]:
Show the name, street address, City, State and ZIP code for all customers who have the last name "White" 
(hint: use LIKE and a wildcard).' + CHAR(10)
--
SELECT Name,
	   StreetAddress,
	   City,
	   StateProvince,
	   ZipCode
FROM CUSTOMER
WHERE Name LIKE '%White';
--
GO



GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 3' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


