/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 4: using SQL SERVER 2012 and the FiredUp database
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   Adam W. Lindsey
                DATE:      October 14, 2013

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
PRINT 'CIS2275, Lab Week 4, Question 1  [3pts possible]:
Show the employee ID number, name, and title for all employees; list them in alphabetical order by job title.
Format all columns using CAST, CONVERT, and/or STR, and rename the columns (try to make the output look 
well-formatted by shortening the column widths).' + CHAR(10)
--
SELECT 
	CAST(EmpID AS CHAR(2)) AS ID
  , CAST(Name AS CHAR(17)) AS 'Employee Name'
  , CAST(Title AS CHAR(11)) AS 'Job Title'
FROM EMPLOYEE
ORDER BY Title ASC;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 4, Question 2  [3pts possible]:
Show the invoice number and total price from the INVOICE table for all of the invoices for customer number 125.
List them in order of invoice date, and rename the columns using AS.' + CHAR(10)
--
SELECT
	CAST(InvoiceNbr AS CHAR(4)) AS 'Invoice ID'
  , '$' + STR(TotalPrice,8,2) AS 'Total Price'
FROM INVOICE
WHERE FK_CustomerID = 125
ORDER BY InvoiceDt;
--
GO



GO
PRINT CHAR(10) + 'CIS2275, Lab Week 4, Question 3  [3pts possible]:
Show the employee ID number and name for only the first three employees (the ones with the three lowest ID numbers). 
Hint: use TOP while sorting by ID number.  Format all columns using CAST, CONVERT, and/or STRING, and rename the 
columns using AS.' + CHAR(10)
--
SELECT TOP (3)
	CAST(EmpID AS CHAR(1)) AS ID
  , CAST(Name AS CHAR(17)) AS 'Employee Name'
FROM EMPLOYEE
ORDER BY EmpID;
--
GO



GO
PRINT CHAR(10) + 'CIS2275, Lab Week 4, Question 4  [3pts possible]:
Select the part number and cost for the three parts with the lowest cost value; use TOP...WITH TIES.  How many 
values are returned?  Why?  (answer with a PRINT statement or in comments)' + CHAR(10)

PRINT 'MY ANSWER: 4 values are returned because there are 2 PARTS with the third lowest cost of $0.44'

SELECT TOP (3) WITH TIES
	CAST(PartNbr AS CHAR(4)) AS 'Part ID'
  , '$' + STR(Cost,8,2) AS 'Item Cost'
FROM PART
ORDER BY COST;
--
GO



GO
PRINT CHAR(10) + 'CIS2275, Lab Week 4, Question 5  [3pts possible]:
Select the Line number and quantity from the PO_LINE_ITEM table; use CONVERT to change the quantity into 
CHAR format, and rename the value "CHARQTY".  Sort the results by "CHARQTY".  Do you see anything wrong with 
the output?  What is it?  (answer with a PRINT statement or in comments)' + CHAR(10)

PRINT 'MY ANSWER: YES, THERE IS SOMETHING WRONG! THE QUANTITIES ARE BEING SORTED ALPHABETICALLY INSTEAD OF NUMERICALLY
	 SO THE VALUES ARE OUT OF ORDER'
	
SELECT
	LineNbr AS 'Line #'
  , CONVERT(CHAR(4),Quantity) AS 'CHARQTY'
FROM PO_LINE_ITEM
ORDER BY CHARQTY;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 4, Question 6  [3pts possible]:
Show the name, street address, and city/state/ZIP code for all customers who live in Oregon.  Combine 
city, state, and ZIP code into a single line in this format:

  "Portland, OR 97201"

...and rename this column City/State/ZIP (exactly this name! there is a way to do it).' + CHAR(10)
--
SELECT
	Name AS 'Customer Name'
  , StreetAddress AS 'Street Address'
  , City + ', ' + StateProvince + ' ' + ZipCode AS 'City/State/ZIP'
FROM CUSTOMER
WHERE StateProvince LIKE '%OR%';
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 4, Question 7  [3pts possible]:
For each row in the REPAIR_LINE_ITEM table, show the repair number, line number, and values of ExtendedPrice
and "Labor Charge" added together (rename this value to TotalCharge).  Sort results in descending order by TotalCharge.' + CHAR(10)
--
SELECT
	CAST(FK_RepairNbr AS CHAR(4)) AS 'Repair ID'
  , CAST(LineNbr AS CHAR(2)) AS '#'
  , '$' + STR((ExtendedPrice + [Labor Charge]),8,2) AS TotalCharge
FROM REPAIR_LINE_ITEM
ORDER BY TotalCharge DESC;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 4, Question 8  [3pts possible]:
For all STOVE_REPAIR records, show the repair number, stove number, repair description, and repair date.
Order the data chronologically by repair date (most recent first), and display the date in this 
format: MM/DD/YYYY.  Format the output to be readable (i.e. to fit neatly into a page).' + CHAR(10)
--
SELECT
	CAST(RepairNbr AS CHAR(4)) AS 'Repair ID'
  , CAST(FK_StoveNbr AS CHAR(2)) AS 'Stove ID'
  , Description AS 'Repair Description'
  , CONVERT(VARCHAR(10), RepairDt, 101) AS 'Repair Date'
FROM STOVE_REPAIR
ORDER BY RepairDt DESC;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 4, Question 9  [3pts possible]:
For all INVOICE rows which have a TotalPrice value between $100 and $200 (inclusive), show the invoice number,
total price, and employee number.  Order the output by invoice number.  Format all three columns using STR; 
display the cost as money (i.e. use two decimal places for cents, and put a dollar sign before it; e.g. $12.54).' + CHAR(10)
--
SELECT
	STR(InvoiceNbr,4,0) AS 'Invoice ID'
  , '$' + STR(TotalPrice,8,2) AS 'Total Price'
  , STR(FK_EmpID,2,0) AS 'Employee ID'
FROM INVOICE
WHERE TotalPrice <= 200
  AND TotalPrice >= 100
ORDER BY InvoiceNbr;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 4, Question 10  [3pts possible]:
Show the repair number, description, and cost of the most expensive STOVE_REPAIR entry (i.e. the line with the highest
Cost value).  Limit your results to only this record (Hint: use TOP).  Format output to be readable.' + CHAR(10)
--
SELECT TOP (1)
	CAST(RepairNbr AS CHAR(4)) AS 'Repair ID'
  , Description AS 'Repair Description'
  , '$' + STR(Cost,8,2) AS 'Repair Cost'
FROM STOVE_REPAIR
ORDER BY Cost DESC;
--
GO



GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 4' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


