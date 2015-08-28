/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 8: using SQL SERVER 2012 and the FiredUp database
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   Adam W. Lindsey
                DATE:      11/13/2013

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
PRINT 'CIS2275, Lab Week 8, Question 1  [3pts possible]:
Show the customer ID number, name, and email address for all customers; order the list by ID number.  You will 
need to join the CUSTOMER table with the EMAIL table to do this (either implicit or explicit syntax is ok); 
include duplicates for customers with multiple email accounts.  Format all output using CAST, CONVERT and/or STR ' + CHAR(10)
--
SELECT CAST(CustomerID AS CHAR(3)) AS 'Customer ID'
	 , CAST(Name AS CHAR(24)) AS 'Customer Name'
	 , CAST(EMailAddress AS VARCHAR(32)) AS 'Email Address'
FROM CUSTOMER
LEFT JOIN EMAIL
ON CUSTOMER.CustomerID = EMAIL.FK_CustomerID;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 2  [3pts possible]:
Which stoves have been sold?  Project serial number, type, version, and color from the STOVE table; join with the 
INV_LINE_ITEM table to identify the stoves which have been sold.  Concatenate type and version to a single column 
with this format: "Firedup v.1".  Eliminate duplicate lines.  List in order by serial number, and format all output.' + CHAR(10)
--
SELECT DISTINCT
	   CAST(SerialNumber AS NUMERIC(2)) AS 'Serial Number'
	 , CAST(Type AS CHAR(12)) + 'v.' + CAST(Version AS CHAR(1)) AS 'Type and Version'
	 , CAST(Color AS CHAR(6)) AS 'Color'
FROM STOVE
LEFT JOIN INV_LINE_ITEM
ON STOVE.SerialNumber = INV_LINE_ITEM.FK_StoveNbr
WHERE FK_StoveNbr IS NOT NULL
ORDER BY 'Serial Number';
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 3  [3pts possible]:
For every invoice, show the invoice number, the name of the customer, and the name of the employee.  You will need to
join the INVOICE table with EMPLOYEE and CUSTOMER using the appropriate join conditions.  Show the results in ascending
order of invoice number.' + CHAR(10)
--
SELECT CAST(InvoiceNbr AS CHAR(3)) AS 'Invoice Number'
	 , CUSTOMER.Name AS 'Customer Name'
	 , Employee.Name AS 'Employee Name'
FROM INVOICE
LEFT JOIN CUSTOMER
ON INVOICE.FK_CustomerID = CUSTOMER.CustomerID
LEFT JOIN EMPLOYEE
ON INVOICE.FK_EmpID = EMPLOYEE.EmpID
ORDER BY InvoiceNbr ASC;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 4  [3pts possible]:
List all stove repairs; show the repair number, description, and the total cost of the repair.  You will need to 
join with the REPAIR_LINE_ITEM TABLE and add up the values of ExtendedPrice using SUM. ' + CHAR(10)
--
SELECT CAST(RepairNbr AS CHAR(4)) AS 'Repair Number'
	 , CAST(Description AS VARCHAR(24)) AS 'Repair Description'
	 , '$' + STR(RepairTotal,8,2) AS 'Total Cost'
FROM STOVE_REPAIR
LEFT JOIN
	(SELECT FK_RepairNbr
		 , SUM(ExtendedPrice) AS RepairTotal
	 FROM REPAIR_LINE_ITEM
	 GROUP BY FK_RepairNbr) AS REPAIR_TOTAL
ON REPAIR_TOTAL.FK_RepairNbr = STOVE_REPAIR.RepairNbr;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 5  [3pts possible]:
Show the name of every employee along with the total number of stove repairs performed by them
(this may be zero - be sure to show every employee!).  You will need to perform an outer join on
EMPLOYEE and STOVE_REPAIR.  Sort the results in descending order by the number of repairs.' + CHAR(10)
--
SELECT Name AS 'Employee Name' 
	 , COUNT(RepairNbr) AS Repairs
FROM EMPLOYEE
LEFT JOIN STOVE_REPAIR
ON EMPLOYEE.EmpID = STOVE_REPAIR.FK_EmpID
GROUP BY Name
ORDER BY Repairs DESC;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 6  [3pts possible]:
Which sales were made in May of 2002? Display the invoice number, invoice date, and stove number (if any).
Use BETWEEN to specify the date range and list in chronological order by invoice date.' + CHAR(10)
--
SELECT CAST(InvoiceNbr AS CHAR(3)) AS 'Invoice Number'
	 , CONVERT(VARCHAR(10),InvoiceDt,101) AS 'Invoice Date'
	 , ISNULL(CAST(FK_StoveNbr AS CHAR(4)), 'none') AS 'Stove Number'
FROM INVOICE
LEFT JOIN INV_LINE_ITEM
ON InvoiceNbr = FK_InvoiceNbr
WHERE InvoiceDt BETWEEN 'May 1, 2002' AND 'May 31, 2002'
ORDER BY InvoiceDt;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 7  [3pts possible]:
Show a list of all states from the CUSTOMER table; for each, display the state, the total 
number of customers in that state, and the total number of suppliers there.  Include all
states from CUSTOMER even if they have no suppliers.  Order results by state.' + CHAR(10)
--
SELECT StateProvince AS 'State'
	 , Customers AS '# of Customers'
	 , ISNULL(Suppliers,0) AS '# of Suppliers'
FROM
	(SELECT StateProvince
		 , COUNT(CustomerID) AS Customers
	 FROM CUSTOMER
	 GROUP BY StateProvince) AS CUSTOMERS
LEFT JOIN
	(SELECT State
		 , COUNT(SupplierNbr) AS Suppliers
	 FROM SUPPLIER
	 GROUP BY State) AS SUPPLIERS
ON CUSTOMERS.StateProvince = SUPPLIERS.State
ORDER BY StateProvince;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 8  [3pts possible]:
Display a list of all stove repairs; for each, show the customer name, address, city/state/zip code (concatenated 
these last three into a single readable column), the repair date, and a description of the repair.  Order by 
repair date, and format all output.  Use an alias for the table names, and apply the alias to the beginning of 
the columns projected; e.g.:

SELECT t.COLUMN1
FROM   TABLENAME AS t
WHERE  t.COLUMN2 = 10;' + CHAR(10)
--
SELECT CAST(C.Name AS CHAR(24)) AS 'Customer Name'
	 , CAST(C.StreetAddress AS VARCHAR(32)) AS 'Customer Street Address'
	 , CAST((C.City + ' ' + C.StateProvince + ' ' + C.ZipCode) AS VARCHAR(32)) AS 'Customer City/State/Zip'
	 , CONVERT(VARCHAR(10),SR.RepairDt,101) AS 'Repair Date'
	 , CAST(SR.Description AS CHAR(24)) AS 'Repair Description'
FROM STOVE_REPAIR AS SR
LEFT JOIN CUSTOMER AS C
ON SR.FK_CustomerID = C.CustomerID
ORDER BY SR.RepairDt;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 9  [3pts possible]:
Show a list of each supplier, along with a cash total of the extended price for all of their purchase orders. 
Display the supplier name and price total; sort alphabetically by supplier name and show the total in money 
format (i.e. $ and two decimal places ); rename the columns using AS.  Hint: you will need to join three tables,
use GROUP BY, and SUM(). ' + CHAR(10)
--
SELECT CAST(Name AS CHAR(24)) AS 'Supplier Name'
	 , '$' + STR(Totals,8,2) AS 'Supplier Totals'
FROM SUPPLIER
LEFT JOIN
	(SELECT FK_SupplierNbr
		 , SUM(SubTotals) AS Totals
	 FROM PURCHASE_ORDER
	 LEFT JOIN
		(SELECT FK_PONbr
			 , SUM(ExtendedPrice) AS SubTotals
		 FROM PO_LINE_ITEM
		 GROUP BY FK_PONbr) AS PO_SUBTOTALS
	 ON PURCHASE_ORDER.PONbr = PO_SUBTOTALS.FK_PONbr
	 GROUP BY FK_SupplierNbr)AS PO_TOTALS
ON SUPPLIER.SupplierNbr = PO_TOTALS.FK_SupplierNbr
ORDER BY Name;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 10  [3pts possible]:
For each invoice, show the total cost of all parts; this is calculated by multiplying the invoice Quantity by the 
Cost for the part.   Show the invoice number and total cost (one line per invoice!).  Format all output (show 
money appropriately).' + CHAR(10)
--
SELECT CAST(InvoiceNbr AS CHAR(3)) AS 'Invoice Number'
	 , '$' + STR(Total,8,2) AS 'Total Cost of PARTS'
FROM INVOICE
LEFT JOIN
	(SELECT FK_InvoiceNbr
		 , SUM(ISNULL((Quantity * Cost),0)) AS Total
	 FROM INV_LINE_ITEM
	 LEFT JOIN PART
	 ON FK_PartNbr = PartNbr
	 GROUP BY FK_InvoiceNbr) AS TOTALS
ON INVOICE.InvoiceNbr = TOTALS.FK_InvoiceNbr;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 11  [3pts possible]:
Show the customer id, name, and the total of invoice extended price values for all customers who live in Oregon 
(exclude all others!).  Your output should include only one line for each customer.  Sort by customer ID.' + CHAR(10)
--
SELECT CustomerID AS 'Customer ID'
	 , Name AS 'Customer Name'
	 , '$' + STR(Total,8,2) AS 'Customer Total'
FROM CUSTOMER
LEFT JOIN
	(SELECT FK_CustomerID
		 , SUM(TotalPrice) AS Total
	 FROM INVOICE
	 GROUP BY FK_CustomerID) AS TOTALS
ON CUSTOMER.CustomerID = TOTALS.FK_CustomerID
WHERE StateProvince = 'OR'
ORDER BY CustomerID;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 12  [3pts possible]:
For every invoice, display the invoice number, customer name, phone number, and email address.  Include duplicates 
where more than one email address or phone number exists.  List in order of customer name; format all output.' + CHAR(10)
--
SELECT CAST(InvoiceNbr AS CHAR(3)) AS 'Invoice Number'
	 , CAST(Name AS CHAR(24)) AS 'Customer Name'
	 , ISNULL(CAST(PhoneNbr AS VARCHAR(12)), 'no phone') AS 'Phone Number'
	 , ISNULL(CAST(EMailAddress AS VARCHAR(32)), 'no email') AS 'Email Address'
FROM INVOICE
LEFT JOIN
	(SELECT CustomerID
		 , Name
		 , PhoneNbr
		 , EMailAddress
	 FROM CUSTOMER
	 LEFT JOIN EMAIL
	 ON CUSTOMER.CustomerID = EMAIL.FK_CustomerID
	 LEFT JOIN PHONE
	 ON CUSTOMER.CustomerID = PHONE.FK_CustomerID) AS CUSTOMERS
ON INVOICE.FK_CustomerID = CUSTOMERS.CustomerID
ORDER BY Name;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 13  [3pts possible]:
Show a list of each supplier, along with a cash total of the extended price for all of their purchase orders. 
Display the supplier name and price total; sort alphabetically by supplier name and show the total in money 
format (i.e. $ and two decimal places after the .); rename the columns using AS.  Hint: you will need to join 
three tables, use GROUP BY, and SUM(). ' + CHAR(10)
--
SELECT CAST(Name AS CHAR(24)) AS 'Supplier Name'
	 , '$' + STR(Totals,8,2) AS 'Supplier Totals'
FROM SUPPLIER
LEFT JOIN
	(SELECT FK_SupplierNbr
		 , SUM(SubTotals) AS Totals
	 FROM PURCHASE_ORDER
	 LEFT JOIN
		(SELECT FK_PONbr
			 , SUM(ExtendedPrice) AS SubTotals
		 FROM PO_LINE_ITEM
		 GROUP BY FK_PONbr) AS PO_SUBTOTALS
	 ON PURCHASE_ORDER.PONbr = PO_SUBTOTALS.FK_PONbr
	 GROUP BY FK_SupplierNbr)AS PO_TOTALS
ON SUPPLIER.SupplierNbr = PO_TOTALS.FK_SupplierNbr
ORDER BY Name;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 14  [3pts possible]:
For every invoice, display the invoice number, customer name, phone number, and email address.  Include duplicates 
where more than one email address or phone number exists.  List in descending order by invoice date.' + CHAR(10)
--
SELECT InvoiceNbr AS 'Invoice Number'
	 , Name AS 'Customer Name'
	 , ISNULL(PhoneNbr, 'no phone') AS 'Phone Number'
	 , ISNULL(EMailAddress, 'no email') AS 'Email Address'
FROM INVOICE
LEFT JOIN
	(SELECT CustomerID
		 , Name
		 , PhoneNbr
		 , EMailAddress
	 FROM CUSTOMER
	 LEFT JOIN EMAIL
	 ON CUSTOMER.CustomerID = EMAIL.FK_CustomerID
	 LEFT JOIN PHONE
	 ON CUSTOMER.CustomerID = PHONE.FK_CustomerID) AS CUSTOMERS
ON INVOICE.FK_CustomerID = CUSTOMERS.CustomerID
ORDER BY InvoiceDt DESC;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 15  [3pts possible]:
Which invoices have involved parts whose name contains the words "widget" or "whatsit" (anywhere within the 
string)?  Display the invoice number and invoice date; sort output by invoice number.' + CHAR(10)
--
SELECT CAST(InvoiceNbr AS CHAR(3)) AS 'Invoice Number'
	 , CONVERT(VARCHAR(10),InvoiceDt,101) AS 'Invoice Date'
FROM INVOICE
LEFT JOIN
	(SELECT FK_InvoiceNbr
		 , Description
	 FROM INV_LINE_ITEM
	 LEFT JOIN
		(SELECT *
		 FROM PART
		 WHERE Description LIKE '%Widget%' OR Description LIKE '%widget%'
			OR Description LIKE '%whatsit%' OR Description LIKE '%Whatsit%') AS PARTS
	 ON INV_LINE_ITEM.FK_PartNbr = PARTS.PartNbr
	 WHERE PARTS.PartNbr IS NOT NULL) AS ITEMS
ON INVOICE.InvoiceNbr = ITEMS.FK_InvoiceNbr
WHERE FK_InvoiceNbr IS NOT NULL
ORDER BY InvoiceNbr;
--
GO


GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 8' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


