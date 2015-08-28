/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 7: using SQL SERVER 2012 and the FiredUp database
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   Adam W. Lindsey
                DATE:      11-07-2013

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
PRINT 'CIS2275, Lab Week 7, Question 1  [3pts possible]:
Show the invoice number and total price for all invoices which go to customers from Oregon.  Use an uncorrelated IN 
subquery to identify Oregon customers (you will not need to join any tables).  Format all output, and show in 
chronological order by invoice date. ' + CHAR(10)
--
SELECT CAST(InvoiceNbr AS CHAR(3)) AS 'Invoice Number'
	 , '$' + STR(TotalPrice,8,2) AS 'Total Price'
FROM INVOICE
WHERE FK_CustomerID IN
   (SELECT CustomerID
	FROM CUSTOMER
	WHERE StateProvince LIKE 'OR%')
ORDER BY InvoiceDt;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 2  [3pts possible]:
Display the serial number, manufacture date, and color for all FiredNow stoves which were not built by Mike Wentland. 
Do not assume that we know Mike''s employee number; use an uncorrelated NOT IN subquery to identify the correct 
employee (you will not need to join any tables).  Rename all columns, and format the date to MM/DD/YYYY.  Sort output 
in descending order by manufacture date.' + CHAR(10)
--
SELECT CAST(SerialNumber AS CHAR(3)) AS 'Serial Number'
	 , CONVERT(VARCHAR(10),DateOfManufacture,101) AS 'Manufacture Date'
	 , CAST(Color AS CHAR(6)) AS 'Stove Color'
FROM STOVE
WHERE FK_EmpId NOT IN
	(SELECT EmpID
	 FROM EMPLOYEE
	 WHERE NAME = 'Mike Wentland')
  AND Type = 'FiredNow'
ORDER BY DateOfManufacture DESC;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 3  [3pts possible]:
Show the invoice number, part number, and quantity for all invoices lines which are for parts which have a Cost value 
less than $1.50.  Use a correlated IN subquery to identify the parts (the correlation is not necessary, but apply it
anyway).  Format all output, and show in descending order by Quantity.    ' + CHAR(10)
--
SELECT CAST(FK_InvoiceNbr AS CHAR(3)) AS 'Invoice Number'
	 , CAST(FK_PartNbr AS CHAR(3)) AS 'Part Number'
	 , CAST(Quantity AS CHAR(2)) AS 'Quantity'
FROM INV_LINE_ITEM
WHERE FK_PartNbr IN
	(SELECT PartNbr
	 FROM PART
	 WHERE Cost < 1.50
	   AND FK_PartNbr = PartNbr)
ORDER BY Quantity DESC;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 4  [3pts possible]:
Which customers have not returned stoves for repair?  List the customer’s name only and show the results in customer 
name order (alphabetical, A-Z).  Use the SQL keyword EXISTS (or NOT EXISTS) and a correlated subquery. ' + CHAR(10)
--
SELECT Name AS 'Customer Name'
FROM CUSTOMER
WHERE NOT EXISTS
	(SELECT *
	 FROM STOVE_REPAIR
	 WHERE FK_CustomerID = CustomerID)
ORDER BY Name;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 5  [3pts possible]:
Identify invoices which contain charges for more than one of the same part (i.e. the Quantity is greater than 1). 
Use a correlated EXISTS subquery to identify the correct entries.  For each invoice, display the invoice 
number, date, and total price.  Format all output; show date in YYYYMMDD format. ' + CHAR(10)
--
SELECT CAST(InvoiceNbr AS CHAR(3)) AS 'Invoice Number'
	 , CONVERT(VARCHAR(8),InvoiceDt,112) AS 'Invoice Date'
	 , '$' + STR(TotalPrice,8,2) AS 'Total Price'
FROM INVOICE
WHERE EXISTS
	(SELECT *
	 FROM INV_LINE_ITEM
	 WHERE FK_InvoiceNbr = InvoiceNbr
	   AND FK_PartNbr IS NOT NULL
	   AND Quantity > 1);
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 6  [3pts possible]:
Identify the type/version (from the STOVE_TYPE table) of the stove model which has the highest Price value. 
Use an = subquery to find the correct value (you will need to ensure that your subquery returns only one column and 
only one row!).  Display the type and version together in this format: "FiredNow v1" and label the concatenated 
column Type/version.' + CHAR(10)
--
SELECT Type + 'v' + CAST(Version AS CHAR(1)) AS 'HIGHEST PRICED STOVE'
FROM STOVE_TYPE
WHERE Price = (SELECT MAX(Price)
			   FROM STOVE_TYPE);
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 7  [3pts possible]:
Show the invoice number, date, and total price for invoices which have been taken by ''Sales Associate'' employees, 
and which have sold to customers whose ZIP code begins with ''9''.  Format all output.  Use subqueries and no joins.' + CHAR(10)
--
SELECT CAST(InvoiceNbr AS CHAR (3)) AS 'Invoice Number'
	 , CONVERT(VARCHAR(10),InvoiceDt,101) AS 'Invoice Date'
	 , '$' + STR(TotalPrice,8,2) AS 'Total Price'
FROM INVOICE
WHERE FK_EmpID IN
	(SELECT EmpID
	 FROM EMPLOYEE
	 WHERE Title = 'Sales Associate')
  AND FK_CustomerID IN
	(SELECT CustomerID
	 FROM CUSTOMER
	 WHERE ZipCode LIKE '9%');
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 8  [3pts possible]:
Show the customer ID number and name (format and rename columns) for all customers who have purchased a FiredNow 
version 1 stove.  Use only subqueries, and no joins.' + CHAR(10)
--
SELECT CustomerID AS 'CustomerID'
	 , Name AS 'Customer Name'
FROM CUSTOMER
WHERE CustomerID IN
	(SELECT FK_CustomerID
	 FROM INVOICE
	 WHERE InvoiceNbr IN
		(SELECT FK_InvoiceNbr
		 FROM INV_LINE_ITEM
		 WHERE FK_StoveNbr IN
			(SELECT SerialNumber
			 FROM STOVE
			 WHERE Type = 'FiredNow'
			   AND Version = 1)));
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 9  [3pts possible]:
Which stoves were sold to Oregon customers?  Display stove type and version of stoves involved in invoices for Oregon 
customers.  Eliminate duplicate values in your results.  Sort output on type and version.' + CHAR(10)
--
SELECT Type AS 'Stove Type'
	 , Version AS 'Stove Version'
FROM STOVE
WHERE SerialNumber IN
	(SELECT FK_StoveNbr
	 FROM INV_LINE_ITEM
	 WHERE FK_InvoiceNbr IN
		(SELECT InvoiceNbr
		 FROM INVOICE
		 WHERE FK_CustomerID IN
			(SELECT CustomerID
			 FROM CUSTOMER
			 WHERE StateProvince = 'OR'))
	  AND FK_StoveNbr IS NOT NULL)
GROUP BY Type, Version
ORDER BY Type, Version;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 10  [3pts possible]:
Show the repair number and description for every stove repair which either (belongs to a
customer from California or Washington) or (is blue in color).  Be careful to use parentheses
to apply the correct logic!
Note that the primary key of the STOVE table (Serialnumber) corresponds to the foreign key
FK_StoveNbr in STOVE_REPAIR.' + CHAR(10)
--
SELECT RepairNbr AS 'Repair Number'
	 , Description AS 'Repair Description'
FROM STOVE_REPAIR
WHERE FK_CustomerID IN
	(SELECT CustomerID
	 FROM CUSTOMER
	 WHERE StateProvince LIKE 'CA%'
		OR StateProvince LIKE 'WA%')
   OR FK_StoveNbr IN
	(SELECT SerialNumber
	 FROM STOVE
	 WHERE Color LIKE 'BLUE%');
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 11  [3pts possible]:
Which employee(s) has all but one of their invoices written after February 15, 2002?  (Hint: "all but one after" is the 
same as saying "only one was written on or before Feb 15") Make sure that the employee also has some Invoices written 
after February 15, 2002.  (Other hint: review the use of GROUP BY with HAVING)  Display the employee name(s).' + CHAR(10)
--
SELECT Name AS 'Employee Name'
FROM EMPLOYEE
WHERE EmpID IN
	(SELECT FK_EmpID
	 FROM INVOICE
	 WHERE InvoiceDt <= 'February 15, 2002'
	 GROUP BY FK_EmpID
	 HAVING COUNT(FK_EmpID) = 1)
  AND EmpID IN
	(SELECT FK_EmpID
	 FROM INVOICE
	 WHERE InvoiceDt > 'February 15, 2002'
	 GROUP BY FK_EmpID
	 HAVING COUNT(FK_EmpID) > 1);
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 12  [3pts possible]:
Show the name of the employee who has built the most expensive stove (i.e. the one with the highest price listed in 
STOVE_TYPE).  Use subqueries and no joins.' + CHAR(10)
--
SELECT Name AS 'Employee Name'
FROM EMPLOYEE
WHERE EmpId IN
   (SELECT FK_EmpId
	FROM STOVE
	WHERE SerialNumber IN
	   (SELECT FK_StoveNbr
		FROM INV_LINE_ITEM
		WHERE FK_StoveNbr IS NOT NULL
		  AND ExtendedPrice = (SELECT MAX(ExtendedPrice)
							   FROM INV_LINE_ITEM)));
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 13  [3pts possible]:
Show the names of all customers who are on invoices which contain parts.  Use subqueries and no joins.' + CHAR(10)
--
SELECT Name AS 'Customers Who Ordered Parts'
FROM CUSTOMER
WHERE CustomerID IN
  (SELECT FK_CustomerID
   FROM INVOICE
   WHERE InvoiceNbr IN 
      (SELECT DISTINCT FK_InvoiceNbr
       FROM INV_LINE_ITEM
       WHERE FK_PartNbr IS NOT NULL));
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 14  [3pts possible]:
Show the purchase order number and Terms from the PURCHASE_ORDER table where the corresponding supplier''s
RepPhoneNumber is in the 541 area code.  Use subqueries and no joins.' + CHAR(10)
--
SELECT PONbr AS 'Purchase Order Number'
	 , Terms AS 'Purchase Order Terms'
FROM PURCHASE_ORDER
WHERE FK_SupplierNbr IN (SELECT SupplierNbr
						 FROM SUPPLIER
						 WHERE CSPhoneNumber LIKE '541%');
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 15  [3pts possible]:
Which stove models (combination of type and version) have NEVER been purchased by customers in California?
Display the stove type and stove version.  Hint: finding stoves never sold in CA is NOT the same as finding stoves
sold outside of CA; it''s easier to identify stoves which *have* sold in CA and filter them out via a subquery.' + CHAR(10)
--
SELECT Type, Version
FROM STOVE AS M_STOVE
WHERE NOT EXISTS
	(SELECT *
	 FROM STOVE AS CA_STOVE
	 WHERE SerialNumber IN
		(SELECT FK_StoveNbr
		 FROM INV_LINE_ITEM
		 WHERE FK_InvoiceNbr IN
			(SELECT InvoiceNbr
			 FROM INVOICE
			 WHERE FK_CustomerID IN
				(SELECT CustomerID
				 FROM CUSTOMER
				 WHERE StateProvince = 'CA')))
	  AND M_STOVE.Type = CA_STOVE.Type
	  AND M_STOVE.Version = CA_STOVE.Version)
GROUP BY Type, Version;
--
GO


GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 7' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


