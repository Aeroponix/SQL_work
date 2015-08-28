/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 6: using SQL SERVER 2012 and the FiredUp database
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   Adam W. Lindsey
                DATE:      10/30/2013

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
PRINT 'CIS2275, Lab Week 6, Question 1  [3pts possible]:
Show a unique list of supplier states (i.e. no duplication!).' + CHAR(10)
--
SELECT DISTINCT State
FROM SUPPLIER;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 6, Question 2  [3pts possible]:
Write the query to project from invoices the average total price, the minimum total price, and the maximum total 
price.  Money should be formatted to two decimal places (use CAST or CONVERT).' + CHAR(10)
--
SELECT CAST(AVG(TotalPrice) AS DECIMAL(8,2)) AS 'Average Price'
	 , CAST(MAX(TotalPrice) AS DECIMAL(8,2)) AS 'Maximum Price'
	 , CAST(MIN(TotalPrice) AS DECIMAL(8,2)) AS 'Minimum Price'
FROM INVOICE;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 6, Question 3  [3pts possible]:
Write a query to list each Type in the STOVE table along with the total number of stoves for that value (use 
GROUP BY with the aggregate function COUNT).  Now write another query to list each unique combination of 
Type and Version, along with the total number of stoves for that combination.' + CHAR(10)
--
SELECT Type
	 , COUNT(Type) AS 'Total Count'
FROM STOVE
GROUP BY Type;

SELECT Type
	 , Version
	 , COUNT(Version) AS 'Total Count'
FROM STOVE 
GROUP BY Type,Version
ORDER BY Type;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 6, Question 4  [3pts possible]:
Display the total Extended Price values from the INV_LINE_ITEM table broken doen by invoice number.
Sort the results in descending order by the extended price total.' + CHAR(10)
--
SELECT FK_InvoiceNbr AS 'Invoice Number'
	 , '$' + STR(SUM(ExtendedPrice),8,2) AS 'Extended Price Total'
FROM INV_LINE_ITEM
GROUP BY FK_InvoiceNbr
ORDER BY 'Extended Price Total' DESC;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 6, Question 5  [3pts possible]:
Display the invoice number and the total number of parts for every invoice (hint: add up the Quantity value). 
Do NOT include stoves in your part totals.  Order the list by invoice number, and format output using CAST, 
CONVERT, and/or STR.' + CHAR(10)
--
SELECT CAST(FK_InvoiceNbr AS CHAR(3)) AS 'Invoice Number'
	 , CAST(COUNT(Quantity) AS CHAR(4)) AS 'Total Number of Parts'
FROM INV_LINE_ITEM
WHERE FK_StoveNbr IS NULL
GROUP BY FK_InvoiceNbr
ORDER BY FK_InvoiceNbr;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 6, Question 6  [3pts possible]:
Show the invoice number and total extended price (use SUM) for every invoice in the INV_INE_ITEM table; but omit
invoices whose total extended price is less than $100 (use the HAVING clause).' + CHAR(10)
--
SELECT FK_InvoiceNbr AS 'Invoice Number'
	 , '$' + STR(SUM(ExtendedPrice),8,2) AS 'Invoice Total'
FROM INV_LINE_ITEM
GROUP BY FK_InvoiceNbr
HAVING SUM(ExtendedPrice) < 100;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 6, Question 7  [3pts possible]:
Show the part number and total quantity for all parts in the PO_LINE_ITEM table whose total quantity is one gross
(144) or less.  Display results in ascending order by total quantity.' + CHAR(10)
--
SELECT Fk_PartNbr
	 , SUM(Quantity) AS 'Total Qty'
FROM PO_LINE_ITEM
GROUP BY Fk_PartNbr
HAVING SUM(Quantity) <= 144
ORDER BY 'Total Qty' ASC;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab 6, Question 8  [3pts possible]:
For each repair, show the repair number and total extended price (from the REPAIR_LINE_ITEM table).
i.e. show one line per repair number, with the SUM of ExtendedPrice values for that repair.
Display query results as [T]ext, and avoid this warning message:

    Warning: Null value is eliminated by an aggregate or other SET operation.' + CHAR(10)
--
SELECT CAST(FK_RepairNbr AS CHAR(4)) AS 'Repair Number'
	 , '$' + STR(SUM(ExtendedPrice),8,2) AS 'Total Extended Price'
FROM REPAIR_LINE_ITEM
GROUP BY FK_RepairNbr;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab 6, Question 9  [3pts possible]:
Show the name, address, and city/state/ZIP code (these last three concatenated into a single line) for all customers 
who do not live in an apartment.  Sort by customer number.' + CHAR(10)
--
SELECT Name
	 , StreetAddress
	 , City + ' ' + StateProvince + ' ' + ZipCode AS 'City/State/Zip'
FROM CUSTOMER
WHERE ApartmentNbr IS NULL
ORDER BY CustomerID;
--


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 6, Question 10  [3pts possible]:
Use the CREATE TABLE statememnt to make a table in the database; include at least three columns of different data types.
You have access to 275Sandbox where you can actually run your SQL Statement to see if it works;
change from the default FiredUp database by using the pull-down database list on the taskbar, or by 
selecting Query -> Connection -> Change Connection.' + CHAR(10)
--
Use CIS275Sandbox    -- switch to Sandbox database
--
CREATE TABLE USERS
(
	UserID INT PRIMARY KEY,
	UserName CHAR(64),
	StreetAddress VARCHAR(255)
);
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 6, Question 11  [3pts possible]:
Based upon your work in last week''s lab, identify two entities which are involved in a one-to-many relationship.
Write the SQL statement to create the table on the "one" side of the relationship.
Make sure that you define a primary key for your table.' + CHAR(10)
--
Use CIS275Sandbox    -- switch to Sandbox database
--
CREATE TABLE STORE
(
	StoreID INT PRIMARY KEY,
	Location VARCHAR(255)
);
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 6, Question 12  [3pts possible]:
Write two separate SQL statements to insert data into the table that you just created.  Explicitly specify the columns,
into which the data should be inserted in corresponding order.' + CHAR(10)
--
Use CIS275Sandbox    -- switch to Sandbox database
--
INSERT INTO STORE (StoreID, Location)
VALUES (1,'Eugene, OR');

INSERT INTO STORE (StoreID, Location)
VALUES (2, 'Portland, OR');
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 6, Question 13  [3pts possible]:
Select all rows from the new table you''ve just created (there should only be the two rows you just inserted!). 
Order the output by your table''s primary key; format all columns using CAST, CONVERT and/or STR.' + CHAR(10)
--
Use CIS275Sandbox    -- switch to Sandbox database
--
SELECT CAST(StoreID AS CHAR(2)) AS 'Store Number'
	 , CAST(Location AS CHAR(64)) AS 'Store Location' 
FROM STORE
ORDER BY StoreID;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 6, Question 14  [3pts possible]:
Write the SQL statement to add a column called "LastModified" to your table; this should be of the data type DATETIME.
Ensure that the column may not contain NULLs, and provide a DEFAULT value for rows that may have this value missing.' + CHAR(10)
--
Use CIS275Sandbox    -- switch to Sandbox database
--
ALTER TABLE STORE
ADD LastModified DATETIME NOT NULL
DEFAULT CURRENT_TIMESTAMP;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 6, Question 15  [3pts possible]:
Write the SQL statement to create the other table from the 1:N relationship above; link the two tables using the 
appropriate database CONSTRAINT.  What effect will this have on data inserted into the new table?  (answer with a PRINT
statement or in comments)' + CHAR(10)
--
Use CIS275Sandbox    -- switch to Sandbox database
--
CREATE TABLE EMPLOYEE
(
	EmpID INT PRIMARY KEY,
	Name VARCHAR(64),
	Position VARCHAR(64),
	Salary DECIMAL(8,2),
	StoreID INT,
	FOREIGN KEY (StoreID) REFERENCES STORE(StoreID)
);
PRINT 'The FOREIGN KEY constraint is used to help prevent actions that would destroy 
the links between tables.
	The FOREIGN KEY constraint also prevents invalid data from being inserted 
into the foreign key column, because it has to be one of the values contained
in the table it points to.';
--
GO


USE FiredUp -- Switch back to default database

GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 6' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


