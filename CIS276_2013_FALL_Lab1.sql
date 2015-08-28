/*
Lab 1, Fall, 2013
CIS276 @PCC using SQL Server 2012
20130923 Adam W. Lindsey
20130924 Finished
********************************************************************************
CIS276_2013_FALL_Lab1 at PCC using Microsoft SQL Server 2012
Five points possible for each of ten questions.
You will need a PRINT statement as well as the code for each question.
20130724 Vicki Jonathan, Instructor
********************************************************************************
CERTIFICATION:
I, Adam W. Lindsey, certify that the following is original code written 
by myself without unauthorized assistance. I agree to abide by class restrictions 
and understand that if I have violated them, I may receive reduced credit 
(or no credit) for this assignment.
--------------------------------------------------------------------------------
Point(s) off for no formatting, incorrect output, no question and/or query PRINT,
query that does not run, query that does not answer the question or does so
inefficiently or not according to directions.
********************************************************************************
*/
USE SalesDB

GO
PRINT '
--------------------------------------------------------------------------------
CIS276_Lab1
1.  Who earns less than or equal to $1,750?
Projection:    SALESPERSONS.Ename, SALESPERSONS.Salary
Instructions:  Display the name and salary for all salespersons whose salary is 
less than or equal to $1,750.  Sort on salary low to high.
--------------------------------------------------------------------------------
';

GO
PRINT '
GO
SELECT DISTINCT
	 CAST(Ename AS CHAR(24)) AS employee_name
   , ''$'' + STR(Salary,8,2) AS employee_salary
FROM SALESPERSONS
WHERE Salary <= 1750
ORDER BY employee_salary ASC;
';

GO
SELECT DISTINCT
	 CAST(Ename AS CHAR(24)) AS employee_name
   , '$' + STR(Salary,8,2) AS employee_salary
FROM SALESPERSONS
WHERE Salary <= 1750
ORDER BY employee_salary ASC;

GO
PRINT '
--------------------------------------------------------------------------------
CIS276_Lab1
2.  Which parts cost between ten and seventeen dollars (inclusive)?
Projection:    INVENTORY.PartID, INVENTORY.Description, INVENTORY.Price 
Instructions:  Display the partid, description, and price of all parts where 
the price is between the numbers given (inclusive). Sort on descending order 
of price. Use the BETWEEN clause in your selection criteria.
--------------------------------------------------------------------------------
';

GO
PRINT '
GO
SELECT DISTINCT
	CAST(PartID AS CHAR(4)) AS item_number
  , CAST(Description AS CHAR(12)) AS item_description
  , ''$'' + STR(Price,8,2) AS item_price
FROM INVENTORY
WHERE Price <= 17
  AND Price >= 10
ORDER BY Price DESC;
';

GO
SELECT DISTINCT
	CAST(PartID AS CHAR(4)) AS item_number
  , CAST(Description AS CHAR(12)) AS item_description
  , '$' + STR(Price,8,2) AS item_price
FROM INVENTORY
WHERE Price <= 17
  AND Price >= 10
ORDER BY item_price DESC;

GO
PRINT '
--------------------------------------------------------------------------------
CIS276_Lab1
3.  What is the highest priced part and what is the lowest priced part?
Projection:    INVENTORY.PartID, INVENTORY.Description, INVENTORY.Price 
Instructions:  Display the partid, description, and price for the highest and 
lowest priced parts in our inventory. Sort on partid ascending. ONE QUERY!
--------------------------------------------------------------------------------
';

GO
PRINT '
GO
SELECT DISTINCT
	CAST(PartID AS CHAR(4)) AS item_number
  , CAST(Description AS CHAR(12)) AS item_description
  , ''$'' + STR(Price,8,2) AS item_price
FROM INVENTORY
WHERE Price = (SELECT MAX(Price) FROM INVENTORY)
   OR Price = (SELECT MIN(Price) FROM INVENTORY)
ORDER BY item_number ASC;
';

GO
SELECT DISTINCT
	CAST(PartID AS CHAR(4)) AS item_number
  , CAST(Description AS CHAR(12)) AS item_description
  , '$' + STR(Price,8,2) AS item_price
FROM INVENTORY
WHERE Price = (SELECT MAX(Price) FROM INVENTORY)
   OR Price = (SELECT MIN(Price) FROM INVENTORY)
ORDER BY item_number ASC;

GO
PRINT '
--------------------------------------------------------------------------------
CIS276_Lab1
4.  Which part descriptions begin with the letter G (or g)?
Projection:    INVENTORY.PartID, INVENTORY.Description 
Instructions:  Display the partid and description of all parts where the 
description begins with the letter ''G'' (that''s either ''G'' or ''g'').  
Show the output in descending order of price.
--------------------------------------------------------------------------------
';

GO
PRINT '
GO
SELECT DISTINCT
	CAST(PartID AS CHAR(4)) AS item_number
  , CAST(Description AS CHAR(12)) AS item_description
FROM INVENTORY
WHERE Description LIKE ''G%''
   OR Description LIKE ''g%''
ORDER BY Price DESC;
';

GO
SELECT
	CAST(PartID AS CHAR(4)) AS item_number
  , CAST(Description AS CHAR(12)) AS item_description
FROM INVENTORY
WHERE Description LIKE 'G%'
   OR Description LIKE 'g%'
ORDER BY Price DESC;

GO
PRINT '
--------------------------------------------------------------------------------
CIS276_Lab1
5.  Which parts need to be ordered from our supplier now?
Projection:    INVENTORY.PartID, INVENTORY.Description, and 
               (INVENTORY.ReorderPnt - INVENTORY.StockQty) 
Instructions:  Display the partid and description of all parts where the 
stock quantity is less than the reorder point.  For each part where this 
is true also display the amount that the stock quantity is below the reorder 
point.  Display in descending order of calculated differences.
--------------------------------------------------------------------------------
';

GO
PRINT '
GO
SELECT
	CAST(PartID AS CHAR(4)) AS item_number
  , CAST(Description AS CHAR(12)) AS item_description
  , CAST(Shortage AS CHAR(4)) AS shortage
FROM (SELECT PartID, Description, (ReorderPnt - StockQty) AS Shortage
	  FROM INVENTORY) AS I
WHERE Shortage > 0
ORDER BY Shortage DESC;
';

GO
SELECT
	CAST(PartID AS CHAR(4)) AS item_number
  , CAST(Description AS CHAR(12)) AS item_description
  , CAST(Shortage AS CHAR(4)) AS shortage
FROM (SELECT PartID, Description, (ReorderPnt - StockQty) AS Shortage
	  FROM INVENTORY) AS I
WHERE Shortage > 0
ORDER BY Shortage DESC;

GO
PRINT '
--------------------------------------------------------------------------------
CIS276_Lab1
6.  Which sales people have NOT sold anything?  Subquery version.
Projection:    SALESPERSONS.Ename
Instructions:  Display all employees that are not involved with an order, 
i.e. where the empid of the salesperson does not appear in the ORDERS table. 
Display the names in alphabetical order.  Do not use JOINs - use subqueries only. 
You should be able to write both a correlated and a non-correlated subquery
but only one query is needed to answer the question.
--------------------------------------------------------------------------------
';

GO
PRINT '
GO
SELECT DISTINCT 
	CAST(Ename AS CHAR(24)) AS employee_name
FROM SALESPERSONS
WHERE EmpID NOT IN (SELECT EmpID
					FROM ORDERS)
ORDER BY employee_name ASC;
';

GO
SELECT DISTINCT 
	CAST(Ename AS CHAR(24)) AS employee_name
FROM SALESPERSONS
WHERE EmpID NOT IN (SELECT EmpID
					FROM ORDERS)
ORDER BY employee_name ASC;

GO
PRINT '
--------------------------------------------------------------------------------
CIS276_Lab1
7.  Which sales people have NOT sold anything? JOIN version.
Projection:    SALESPERSONS.Ename 
Instructions:  Display all employees that are not involved with an order, 
i.e. where the empid of the sales person does not appear in the ORDERS table. 
Display the names in alphabetical order. Do not use sub-queries - use only JOINs.
--------------------------------------------------------------------------------
';

GO
PRINT '
GO
SELECT DISTINCT 
	CAST(Ename AS CHAR(24)) AS employee_name
FROM SALESPERSONS
LEFT OUTER JOIN ORDERS 
ON SALESPERSONS.EmpID = ORDERS.EmpID
WHERE OrderID IS NULL
ORDER BY employee_name ASC;
';

GO
SELECT DISTINCT 
	CAST(Ename AS CHAR(24)) AS employee_name
FROM SALESPERSONS
LEFT OUTER JOIN ORDERS 
ON SALESPERSONS.EmpID = ORDERS.EmpID
WHERE OrderID IS NULL
ORDER BY employee_name ASC;

GO
PRINT '
--------------------------------------------------------------------------------
CIS276_Lab1
8.  Who placed the most orders?
Projection:    CUSTOMERS.CustID, CUSTOMERS.Cname, COUNT(DISTINCT ORDERS.OrderID) 
Instructions:  Display the customer ID, customer name, and number of orders 
for the customer who has placed the most orders, i.e. the customer(s) who 
appear(s) the most times in the ORDERS table. Sort on orders then IDs.
--------------------------------------------------------------------------------
';

GO
PRINT '
GO
SELECT DISTINCT
	CAST(CUSTOMERS.CustID AS CHAR(4)) AS customer_id
  , CAST(Cname AS CHAR(32)) AS customer_name
  , (SELECT COUNT(DISTINCT ORDERS.OrderID)
				  FROM ORDERS
				  WHERE CustID = CUSTOMERS.CustID) AS order_quanity
FROM CUSTOMERS
ORDER BY order_quanity DESC, customer_id ASC;
';

GO
SELECT DISTINCT
	CAST(CUSTOMERS.CustID AS CHAR(4)) AS customer_id
  , CAST(Cname AS CHAR(32)) AS customer_name
  , (SELECT COUNT(DISTINCT ORDERS.OrderID)
				  FROM ORDERS
				  WHERE CustID = CUSTOMERS.CustID) AS order_quanity
FROM CUSTOMERS
ORDER BY order_quanity DESC, customer_id ASC;

GO
PRINT '
--------------------------------------------------------------------------------
CIS276_Lab1
9.  Who ordered the most quantity?
Projection:    CUSTOMERS.CustID, CUSTOMERS.Cname, SUM(ORDERITEMS.Qty)
Instructions:  Display the customer ID, customer name, and total quantity of 
parts ordered by the customer who has ordered the greatest quantity. 
For this query you will sum the quantity for all order items of all orders 
associated with each customer to determine which customer has ordered the most 
(largest) quantity. Sort on quantity high to low.
--------------------------------------------------------------------------------
';

GO
PRINT '
GO
SELECT
	CAST(CUSTOMERS.CustID AS CHAR(4)) AS customer_id
  , CAST(Cname AS CHAR(32)) AS customer_name
  , CAST(gTotal AS CHAR(4)) AS total_items
FROM CUSTOMERS
LEFT JOIN (SELECT SUM(total) AS gTotal, CustID
		   FROM ORDERS
		   LEFT JOIN (SELECT SUM(Qty) AS total, OrderID
					  FROM ORDERITEMS
					  GROUP BY OrderID) AS QTY
		   ON ORDERS.OrderID = QTY.OrderID
		   GROUP BY CustID) AS gQTY
ON CUSTOMERS.CustID = gQTY.CustID
ORDER BY gTotal DESC;
';

GO
SELECT
	CAST(CUSTOMERS.CustID AS CHAR(4)) AS customer_id
  , CAST(Cname AS CHAR(32)) AS customer_name
  , CAST(gTotal AS CHAR(4)) AS total_items
FROM CUSTOMERS
LEFT JOIN (SELECT SUM(total) AS gTotal, CustID
		   FROM ORDERS
		   LEFT JOIN (SELECT SUM(Qty) AS total, OrderID
					  FROM ORDERITEMS
					  GROUP BY OrderID) AS QTY
		   ON ORDERS.OrderID = QTY.OrderID
		   GROUP BY CustID) AS gQTY
ON CUSTOMERS.CustID = gQTY.CustID
ORDER BY gTotal DESC;

GO
PRINT '
--------------------------------------------------------------------------------
CIS276_Lab1
10.  Who ordered the most value?
Projection:   CUSTOMERS.CustID, CUSTOMERS.Cname, and
              SUM(INVENTORY.Price * ORDERITEMS.Qty) 
Instructions:  Display the customer id, customer name, and total value of all 
orders for the customer(s) whose orders total the highest value. 
To find the total value for a customer you need to sum the price times quantity 
for each line item of each order associated with the customer. Sort on value
high to low.
--------------------------------------------------------------------------------
';

GO
PRINT '
GO
SELECT CUSTOMERS.CustID, Cname, gTotal
FROM CUSTOMERS
LEFT JOIN (SELECT SUM(total) AS gTotal, CustID
		   FROM ORDERS
		   LEFT JOIN (SELECT SUM(Price * Qty) AS total, OrderID
					  FROM ORDERITEMS
					  LEFT JOIN INVENTORY
					  ON ORDERITEMS.PartID = INVENTORY.PartID
					  GROUP BY OrderID) AS QTY
		   ON ORDERS.OrderID = QTY.OrderID
		   GROUP BY CustID) AS gQTY
ON CUSTOMERS.CustID = gQTY.CustID
ORDER BY gTotal DESC;
';

GO
SELECT 
	CAST(CUSTOMERS.CustID AS CHAR(4)) AS customer_id
  , CAST(Cname AS CHAR(32)) AS customer_name
  , '$' + STR(gTotal,8,2) AS total_spent
FROM CUSTOMERS
LEFT JOIN (SELECT SUM(total) AS gTotal, CustID
		   FROM ORDERS
		   LEFT JOIN (SELECT SUM(Price * Qty) AS total, OrderID
					  FROM ORDERITEMS
					  LEFT JOIN INVENTORY
					  ON ORDERITEMS.PartID = INVENTORY.PartID
					  GROUP BY OrderID) AS QTY
		   ON ORDERS.OrderID = QTY.OrderID
		   GROUP BY CustID) AS gQTY
ON CUSTOMERS.CustID = gQTY.CustID
ORDER BY gTotal DESC;

GO
PRINT '
End of CIS276_Lab1
';

