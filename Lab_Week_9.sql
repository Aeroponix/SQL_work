/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 9: using SQL SERVER 2012 and the FiredUp database
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   Adam W. Lindsey
                DATE:      11-20-2013

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
PRINT 'CIS2275, Lab Week 9, Question 1  [3pts possible]:
Show the serial numbers of all the "FiredAlways" stoves which have been invoiced.  Use whichever method you prefer 
(a join or a subquery).  List in order of serial number and eliminate duplicates.' + CHAR(10)
--
SELECT DISTINCT SerialNumber
FROM STOVE
WHERE Type='FiredAlways'
  AND SerialNumber IN
	(SELECT FK_StoveNbr
	 FROM INV_LINE_ITEM
	 WHERE FK_StoveNbr IS NOT NULL)
ORDER BY SerialNumber;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 2  [3pts possible]:
Show the name and email address of all customers who have ever brought a stove in for repair (include duplicates and 
ignore customers without email addresses). ' + CHAR(10)
--
SELECT Name AS 'Customer Name'
	 , EMailAddress AS 'Email Address'
FROM CUSTOMER,
	 EMAIL,
	 STOVE_REPAIR
WHERE CustomerID = EMAIL.FK_CustomerID
  AND CustomerID = STOVE_REPAIR.FK_CustomerID;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 3  [3pts possible]:
What stoves have been sold to customers with the last name of "Smith"?  Display the customer name, stove number, stove 
type, and stove version and show the results in customer name order.' + CHAR(10)
--
SELECT Name AS 'Customer Name'
	 , SerialNumber AS 'Stove Number'
	 , Type AS 'Stove Type'
	 , Version AS 'Stove Version'
FROM STOVE
LEFT JOIN
	(SELECT FK_StoveNbr, InvoiceNbr, Name
	 FROM INV_LINE_ITEM
	 LEFT JOIN
		(SELECT InvoiceNbr, Name
		 FROM INVOICE
		 LEFT JOIN 
			(SELECT CustomerID, Name
			 FROM CUSTOMER
			 WHERE Name LIKE '%Smith') AS C
		 ON FK_CustomerID = CustomerID
		 WHERE Name IS NOT NULL) AS I
	 ON FK_InvoiceNbr = InvoiceNbr
	 WHERE Name IS NOT NULL) AS M
ON SerialNumber = FK_StoveNbr
WHERE Name IS NOT NULL
ORDER BY Name;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 4  [3pts possible]:
What employee has sold the most stoves in the most popular state?  ("most popular state" means the state or states for 
customers who purchased the most stoves, regardless of the stove type and version; do not hardcode a specific state 
into your query)  Display the employee number, employee name, the name of the most popular state, and the number of 
stoves sold by the employee in that state.  If there is more than one employee then display them all.' + CHAR(10)
--
SELECT EmpID AS 'Employee Number'
	 , Name AS 'Employee Name'
	 , StateProvince AS 'State'
	 , StateCount AS '# of stoves sold'
FROM EMPLOYEE
LEFT JOIN
	(SELECT FK_EmpID
		  , StateProvince
		  , COUNT(StateProvince) StateCount
	 FROM INVOICE
	 LEFT JOIN
		(SELECT CustomerID,
			   StateProvince
		 FROM CUSTOMER) AS C
	 ON FK_CustomerID = CustomerID
	 GROUP BY FK_EmpID, StateProvince) AS I
ON EmpID = FK_EmpID
WHERE StateProvince IN
	(SELECT StateProvince 
	 FROM (SELECT StateProvince
			 , COUNT(StateProvince) StateCount 
		 FROM CUSTOMER
		 GROUP BY StateProvince) AS STATES
	 WHERE STATES.StateCount IN
		(SELECT MAX(StateCount) FROM
			(SELECT StateProvince
				  , COUNT(StateProvince) StateCount 
			 FROM CUSTOMER
			 GROUP BY StateProvince) AS COUNTS))
  AND StateCount IN
	(SELECT MAX(StateCount)
	 FROM EMPLOYEE
	 LEFT JOIN
		(SELECT FK_EmpID
			  , StateProvince
			  , COUNT(StateProvince) StateCount
		 FROM INVOICE
		 LEFT JOIN
			(SELECT CustomerID,
				   StateProvince
			 FROM CUSTOMER) AS C
		 ON FK_CustomerID = CustomerID
		 GROUP BY FK_EmpID, StateProvince) AS I
	 ON EmpID = FK_EmpID
	 WHERE StateProvince IN
		(SELECT StateProvince 
		 FROM (SELECT StateProvince
				 , COUNT(StateProvince) StateCount 
			 FROM CUSTOMER
			 GROUP BY StateProvince) AS STATES
		 WHERE STATES.StateCount IN
			(SELECT MAX(StateCount) FROM
				(SELECT StateProvince
					  , COUNT(StateProvince) StateCount 
				 FROM CUSTOMER
				 GROUP BY StateProvince) AS COUNTS)));
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 5  [3pts possible]:
Identify all the sales associates who have ever sold the FiredAlways version 1 stove; show a breakdown of the total 
number sold by color.  i.e. for each line, show the employee name, the stove color, and the total number sold.  Sort 
the results by name, then color.' + CHAR(10)
--
SELECT Name AS 'Employee Name'
	 , Color AS 'Stove Color'
	 , COUNT(Color) AS 'Total Number Sold'
FROM EMPLOYEE
INNER JOIN
	(SELECT FK_EmpID, Color
	 FROM INVOICE
	 INNER JOIN
		(SELECT FK_InvoiceNbr, Color
		 FROM INV_LINE_ITEM
		 INNER JOIN
			(SELECT SerialNumber, Color
			 FROM STOVE
			 WHERE Type = 'FiredAlways'
			   AND Version = 1) AS S
		 ON FK_StoveNbr = SerialNumber) AS ILI
	 ON InvoiceNbr = FK_InvoiceNbr) AS I
ON EmpID = FK_EmpID
WHERE Title = 'Sales Associate'
GROUP BY Name, Color
ORDER BY Name, Color;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 6  [3pts possible]:
Show the name and phone number for all customers who have a Hotmail address (i.e. an entry in the EMAIL table which 
ends in hotmail.com).  Include duplicate names where multiple phone numbers exist; sort results by customer name.' + CHAR(10)
--
SELECT Name AS 'Customer Name'
	 , PhoneNbr AS 'Phone Number'
FROM CUSTOMER
LEFT JOIN PHONE
ON CustomerID = FK_CustomerID
WHERE CustomerID IN
	(SELECT FK_CustomerID
	 FROM EMAIL
	 WHERE EMailAddress LIKE '%@hotmail.com')
ORDER BY Name;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 7  [3pts possible]:
Show the purchase order number, average SalesPrice, and average ExtendedPrice for parts priced between $1 and $2 which 
were ordered from suppliers in Virginia.  List in descending order of average ExtendedPrice.  Format all output. ' + CHAR(10)
--
SELECT CAST(FK_PONbr AS CHAR(3)) AS 'Purchase Order #'
	 , '$' + STR(AVG(SalesPrice),8,2) AS 'Average Sales Price'
	 , '$' + STR(AVG(ExtendedPrice),8,2) AS 'Average Extended Price'
FROM PO_LINE_ITEM,PART
WHERE Fk_PartNbr = PartNbr
  AND SalesPrice BETWEEN 1 and 2
  AND FK_PONbr IN
	(SELECT PONbr
	 FROM PURCHASE_ORDER
	 WHERE FK_SupplierNbr IN
		(SELECT SupplierNbr
		 FROM SUPPLIER
		 WHERE State = 'VA'))
GROUP BY FK_PONbr
ORDER BY 'Average Extended Price';
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 8  [3pts possible]:
Which invoice has the second-lowest total price among invoices that do not include a sale of a FiredAlways stove? 
Display the invoice number, invoice date, and invoice total price.  If there is more than one invoice then display all 
of them. (Note: finding invoices that do not include a FiredAlways stove is NOT the same as finding invoices where a 
line item contains something other than a FiredAlways stove -- invoices have more than one line.  Avoid a JOIN with the 
STOVE since the lowest price may not involve any stove sales.)' + CHAR(10)
--
SELECT CAST(InvoiceNbr AS CHAR(3)) AS 'Invoice Number'
	 , CONVERT(VARCHAR(10),InvoiceDt,101) AS 'Invoice Date'
	 , '$' + STR(TotalPrice,8,2) AS 'Total Price'
FROM INVOICE
WHERE TotalPrice IN
	(SELECT MAX(TotalPrice)
	 FROM
		(SELECT TOP(2) *
		 FROM
			(SELECT Distinct TotalPrice
			 FROM INVOICE
			 WHERE InvoiceNbr NOT IN
				(SELECT DISTINCT InvoiceNbr
				 FROM INVOICE, INV_LINE_ITEM, STOVE
				 WHERE InvoiceNbr = FK_InvoiceNbr
				   AND FK_StoveNbr = SerialNumber
				   AND  Type = 'FiredAlways')) AS PRICE) AS P);
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 9  [3pts possible]:
What employee(s) have sold the most stoves in the least popular color ("least popular color" means the color that has 
been purchased the least number of times, regardless of the stove type and version. Do not hardcode a specific color 
into your query)?  If there is more than one employee tied for the most then display them all.  If there is a tie for 
"least popular color" then you may pick ANY of them.  Display the employee name, number of stoves sold, and the least 
popular color.' + CHAR(10)
--
SELECT Name AS 'Employee Name'
	 , Color AS 'Least Popular Color'
	 , COUNT(Color) AS 'Number Sold'
FROM EMPLOYEE E, INVOICE I, INV_LINE_ITEM, STOVE
WHERE E.EmpID = I.FK_EmpID
  AND InvoiceNbr = FK_InvoiceNbr
  AND FK_StoveNbr = SerialNumber
  AND Color IN
	(SELECT Color FROM
		(SELECT Color, COUNT(Color) AS Counts
		 FROM STOVE, INV_LINE_ITEM
		 WHERE SerialNumber = FK_StoveNbr
		 GROUP BY Color) AS COUNTS
	 WHERE COUNTS.Counts IN
		(SELECT MIN(COUNTS) FROM
			(SELECT Color, COUNT(Color) AS Counts
			 FROM STOVE, INV_LINE_ITEM
			 WHERE SerialNumber = FK_StoveNbr
			 GROUP BY Color) AS C))
GROUP BY Name, Color
HAVING COUNT(Color) = 
(SELECT MAX(TotalCount) FooBar FROM
	(SELECT Name, Color, COUNT(Color) AS TotalCount
	 FROM EMPLOYEE E, INVOICE I, INV_LINE_ITEM, STOVE
	 WHERE E.EmpID = I.FK_EmpID
	   AND InvoiceNbr = FK_InvoiceNbr
	   AND FK_StoveNbr = SerialNumber
	   AND Color IN
		(SELECT Color FROM
			(SELECT Color, COUNT(Color) AS Counts
			 FROM STOVE, INV_LINE_ITEM
			 WHERE SerialNumber = FK_StoveNbr
			 GROUP BY Color) AS COUNTS
		 WHERE COUNTS.Counts IN
			(SELECT MIN(COUNTS) FROM
				(SELECT Color, COUNT(Color) AS Counts
				 FROM STOVE, INV_LINE_ITEM
				 WHERE SerialNumber = FK_StoveNbr
				 GROUP BY Color) AS C)) GROUP BY Name, Color) AS FINAL)
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 10  [3pts possible]:
Show a breakdown of all part entries in invoices.  For each invoice, show the customer name, invoice number, the number 
of invoice lines for parts (exclude stoves!), the total number of parts for the invoice (add up Quantity), and the total 
ExtendedPrice values for these parts.  Format all output; sort by customer name, then invoice number. ' + CHAR(10)
--
SELECT CAST(Name AS CHAR(24)) AS 'Employee Name'
	 , CAST(InvoiceNbr AS CHAR(3)) AS 'Invoice Number'
	 , CAST(TotalLines AS CHAR(2)) AS 'Total Invoice Lines'
	 , CAST(TotalQty AS CHAR(2)) AS 'Total Number of Parts'
	 , '$' + STR(T.TotalPrice,8,2) AS 'Total Extended Price'
FROM INVOICE, CUSTOMER,
	(SELECT FK_InvoiceNbr
		 , COUNT(LineNbr) AS TotalLines
		 , SUM(Quantity) AS TotalQty
		 , SUM(ExtendedPrice) AS TotalPrice
	 FROM INV_LINE_ITEM
	 WHERE FK_PartNbr IS NOT NULL
	 GROUP BY FK_InvoiceNbr) AS T
WHERE InvoiceNbr = FK_InvoiceNbr
  AND FK_CustomerID = CustomerID
ORDER BY Name, InvoiceNbr;
--
GO


GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 9' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


