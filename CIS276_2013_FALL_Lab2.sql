/*
LAB 2, FALL, 2013
CIS276 @PCC using SQL Server 2013
20130930 Adam Lindsey
20131001 Completed
********************************************************************************
CIS276_2013_FALL_Lab2 at PCC using Microsoft SQL Server 2012
Five points possible for each of ten questions.
You will need a PRINT statement as well as the code for each question.
20130724 Vicki Jonathan, Instructor
********************************************************************************
CERTIFICATION:
I, Adam W Lindsey, certify that the following is original code written 
by myself without unauthorized assistance. I agree to abide by class restrictions 
and understand that if I have violated them, I may receive reduced Credit 
(or no Credit) for this assignment.
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
CIS276_Lab2
1.	How are all of the salespeople doing? 
Projection:    SALESPERSONS.EmpID, SALESPERSONS.Ename, 
               SUM(ORDERITEMS.Qty*INVENTORY.Price) 
Instructions:  Display the total dollar value that each and every sales person 
has sold.  List in dollar value descending.
--------------------------------------------------------------------------------
';

GO
PRINT '
SELECT 
	CAST(SALESPERSONS.EmpID AS CHAR(4)) AS employee_id
  , CAST(Ename AS CHAR(32)) AS employee_name
  , total_sold = CASE 
		WHEN grand_total_sold IS NULL THEN ''$0.00''
		ELSE ''$'' + STR(grand_total_sold,8,2)
	END
FROM SALESPERSONS
LEFT JOIN (SELECT EmpID, SUM(order_total) AS grand_total_sold
		   FROM ORDERS
		   LEFT JOIN (SELECT OrderID, SUM(Qty*Price) AS order_total
					  FROM ORDERITEMS
					  LEFT JOIN INVENTORY
					  ON ORDERITEMS.PartID = INVENTORY.PartID
					  GROUP BY OrderID) AS ORDER_TOTALS
		   ON ORDERS.OrderID = ORDER_TOTALS.OrderID
		   GROUP BY EmpID) AS PERSON_TOTALS
ON SALESPERSONS.EmpID = PERSON_TOTALS.EmpID
ORDER BY grand_total_sold DESC;
';

GO
SELECT 
	CAST(SALESPERSONS.EmpID AS CHAR(4)) AS employee_id
  , CAST(Ename AS CHAR(32)) AS employee_name
  , total_sold = CASE 
		WHEN grand_total_sold IS NULL THEN '$0.00'
		ELSE '$' + STR(grand_total_sold,8,2)
	END
FROM SALESPERSONS
LEFT JOIN (SELECT EmpID, SUM(order_total) AS grand_total_sold
		   FROM ORDERS
		   LEFT JOIN (SELECT OrderID, SUM(Qty*Price) AS order_total
					  FROM ORDERITEMS
					  LEFT JOIN INVENTORY
					  ON ORDERITEMS.PartID = INVENTORY.PartID
					  GROUP BY OrderID) AS ORDER_TOTALS
		   ON ORDERS.OrderID = ORDER_TOTALS.OrderID
		   GROUP BY EmpID) AS PERSON_TOTALS
ON SALESPERSONS.EmpID = PERSON_TOTALS.EmpID
ORDER BY grand_total_sold DESC;

GO
PRINT '
--------------------------------------------------------------------------------
CIS276_Lab2
2.	What is the dollar value for each of every order order? 
Projection:    ORDERS.OrderID, SUM(ORDERITEM.Qty*INVENTORY.Price) 
Instructions:  Display the dollar value for each and every order.  List in 
dollar value descending.
--------------------------------------------------------------------------------
';

GO
PRINT '
SELECT 
	CAST(ORDERS.OrderID AS CHAR(4)) AS order_number
  , order_total = CASE
		WHEN total IS NULL THEN ''$0.00''
		ELSE ''$'' + STR(total,8,2)
	END
FROM ORDERS
LEFT JOIN (SELECT OrderID, SUM(Qty*Price) AS total
		   FROM ORDERITEMS
		   LEFT JOIN INVENTORY
		   ON ORDERITEMS.PartID = INVENTORY.PartID
		   GROUP BY OrderID) AS ORDER_TOTALS
ON ORDERS.OrderID = ORDER_TOTALS.OrderID
ORDER BY total DESC;
';

GO
SELECT 
	CAST(ORDERS.OrderID AS CHAR(4)) AS order_number
  , order_total = CASE
		WHEN total IS NULL THEN '$0.00'
		ELSE '$' + STR(total,8,2)
	END
FROM ORDERS
LEFT JOIN (SELECT OrderID, SUM(Qty*Price) AS total
		   FROM ORDERITEMS
		   LEFT JOIN INVENTORY
		   ON ORDERITEMS.PartID = INVENTORY.PartID
		   GROUP BY OrderID) AS ORDER_TOTALS
ON ORDERS.OrderID = ORDER_TOTALS.OrderID
ORDER BY total DESC;

GO
PRINT '
--------------------------------------------------------------------------------
CIS276_Lab2
3.	Which orders contain widgets? 
Projection:    ORDERS.OrderID, ORDERS.SalesDate 
Instructions:  The word ''widget'' may not be the only word in the part 
description (use a wildcard).  Display the orders where a ''widget'' part 
appears in at least one ORDERITEMS rows for the order.  List in sales date 
sequence with the newest first.  Do not use the EXISTS clause.
--------------------------------------------------------------------------------
';

GO
PRINT '
SELECT 
	CAST(ORDERS.OrderID AS CHAR(4)) AS order_number
  , CONVERT(CHAR(12), SalesDate, 101) AS sales_date
FROM ORDERS
LEFT JOIN (SELECT OrderID
		   FROM ORDERITEMS
		   WHERE ORDERITEMS.PartID = (SELECT PartID
							   	      FROM INVENTORY
									  WHERE Description LIKE ''widget%'')) AS SELECTED
ON ORDERS.OrderID = SELECTED.OrderID
ORDER BY SalesDate DESC;
';

GO
SELECT 
	CAST(ORDERS.OrderID AS CHAR(4)) AS order_number
  , CONVERT(CHAR(12), SalesDate, 101) AS sales_date
FROM ORDERS
LEFT JOIN (SELECT OrderID
		   FROM ORDERITEMS
		   WHERE ORDERITEMS.PartID = (SELECT PartID
							   	      FROM INVENTORY
									  WHERE Description LIKE 'widget%')) AS SELECTED
ON ORDERS.OrderID = SELECTED.OrderID
ORDER BY SalesDate DESC;

GO
PRINT '
--------------------------------------------------------------------------------
CIS276_Lab2
4.  Which orders contain widgets? 
Projection:    ORDERS.OrderID, ORDERS.SalesDate 
Instructions:  The word ''widget'' may not be the only word in the part 
description (use a wildcard).  Display the orders where a ''widget'' part 
appears in at least one ORDERITEMS rows for the order.  List in sales date 
sequence with the newest first.  Use the EXISTS clause.
--------------------------------------------------------------------------------
';

GO
PRINT '
SELECT
	CAST(OrderID AS CHAR(4)) AS order_number
  , CONVERT(CHAR(12), SalesDate, 101) AS sales_date
FROM ORDERS
WHERE EXISTS (SELECT *
			  FROM (SELECT OrderID
					FROM ORDERITEMS
					WHERE ORDERITEMS.PartID = (SELECT PartID
				   							   FROM INVENTORY
					 						   WHERE Description LIKE ''widget%''))
					AS ITEMS
			  WHERE ORDERS.OrderID = ITEMS.OrderID)
ORDER BY SalesDate DESC;
';

GO
SELECT
	CAST(OrderID AS CHAR(4)) AS order_number
  , CONVERT(CHAR(12), SalesDate, 101) AS sales_date
FROM ORDERS
WHERE EXISTS (SELECT *
			  FROM (SELECT OrderID
					FROM ORDERITEMS
					WHERE ORDERITEMS.PartID = (SELECT PartID
				   							   FROM INVENTORY
					 						   WHERE Description LIKE 'widget%'))
					AS ITEMS
			  WHERE ORDERS.OrderID = ITEMS.OrderID)
ORDER BY SalesDate DESC;

GO
PRINT '
--------------------------------------------------------------------------------
CIS276_Lab2
5.	What are the gadget and gizmo only orders? 
Projection:    OrderID 
Instructions:  The words ''gadget'' and ''gizmo'' may not be the only word in 
the part description. Code accordingly.  List in ascending order of OrderID.
--------------------------------------------------------------------------------
';

GO
PRINT '
SELECT DISTINCT
	CAST(OrderID AS CHAR(4)) AS order_number
FROM ORDERITEMS
LEFT JOIN (SELECT PartID
		   FROM INVENTORY
		   WHERE Description LIKE ''gadget%''
			  OR Description LIKE ''gizmo%'') AS ITEMS
ON ORDERITEMS.PartID = ITEMS.PartID
ORDER BY order_number;
';

GO
SELECT DISTINCT
	CAST(OrderID AS CHAR(4)) AS order_number
FROM ORDERITEMS
LEFT JOIN (SELECT PartID
		   FROM INVENTORY
		   WHERE Description LIKE 'gadget%'
			  OR Description LIKE 'gizmo%') AS ITEMS
ON ORDERITEMS.PartID = ITEMS.PartID
ORDER BY order_number;

GO
PRINT '
--------------------------------------------------------------------------------
CIS276_Lab2
6.	Who are the profit-less customers? 
Projection:    CUSTOMERS.CustID, CUSTOMERS.Cname 
Instructions:  Display the customers that have not placed orders.  Show in 
customer name order (either ascending or descending).  Use the EXISTS clause.
--------------------------------------------------------------------------------
';

GO
PRINT '
SELECT 
	CAST(CustID AS CHAR(3)) AS customer_ID
  , CAST(Cname AS CHAR(32)) AS customer_name
FROM CUSTOMERS
WHERE NOT EXISTS (SELECT *
				  FROM ORDERS
				  WHERE CUSTOMERS.CustID = ORDERS.CustID)
ORDER BY Cname;
';

GO
SELECT 
	CAST(CustID AS CHAR(3)) AS customer_ID
  , CAST(Cname AS CHAR(32)) AS customer_name
FROM CUSTOMERS
WHERE NOT EXISTS (SELECT *
				  FROM ORDERS
				  WHERE CUSTOMERS.CustID = ORDERS.CustID)
ORDER BY Cname;

GO
PRINT '
--------------------------------------------------------------------------------
CIS276_Lab2
7.	What is the average dollar value of an order? 
Projection:    "Orders Average", "OrderItems Average"
Instructions:  Columns to display are determined by whether your output is 
horizontal (two columns) or vertical (one column holding both averages on 
separate lines with a literal string telling what each average is).  There are 
two possible averages on this question. There are a certain number of orders in 
the ORDERS table, but not all of these orders are in the ORDERITEMS table.  Write 
one query that produces both averages.  To get this answer, you need to add up 
all the order values and divide by the number of orders.  The number of orders in 
the ORDERS table is different from the number of orders in the ORDERITEMS table.
Do not use AVG().
--------------------------------------------------------------------------------
';

GO
PRINT '
SELECT 
	''$'' + STR((SUM(order_total)/COUNT(ORDERS.OrderID)),8,2) AS ORDERS_average
  , ''$'' + STR((SUM(OI.order_total)/COUNT(OI.OrderID)),8,2) AS ORDERITEMS_average
FROM ORDERS
LEFT JOIN (SELECT OrderID, SUM(Qty*Price) AS order_total
		   FROM ORDERITEMS
		   LEFT JOIN INVENTORY
		   ON ORDERITEMS.PartID = INVENTORY.PartID
		   GROUP BY OrderID) AS OI
		   ON ORDERS.OrderID = OI.OrderID;
';

GO 
SELECT 
	'$' + STR((SUM(order_total)/COUNT(ORDERS.OrderID)),8,2) AS ORDERS_average
  , '$' + STR((SUM(OI.order_total)/COUNT(OI.OrderID)),8,2) AS ORDERITEMS_average
FROM ORDERS
LEFT JOIN (SELECT OrderID, SUM(Qty*Price) AS order_total
		   FROM ORDERITEMS
		   LEFT JOIN INVENTORY
		   ON ORDERITEMS.PartID = INVENTORY.PartID
		   GROUP BY OrderID) AS OI
		   ON ORDERS.OrderID = OI.OrderID;


GO
PRINT '
--------------------------------------------------------------------------------
CIS276_Lab2
8.	Who is our most profitable salesperson? 
Projection:    SALESPERSONS.EmpID, SALESPERSONS.Ename, 
              (SUM(ORDERITEMS.Qty*INVENTORY.Price) - SALESPERSONS.Salary) 
Instructions:  A salesperson''s profit (or loss) is the difference between what 
the person sold and what the person earns: 
((SUM(ORDERITEMS.Qty*INVENTORY.Price) - SALESPERSONS.Salary)).  
If the value is positive then there is a profit, otherwise there is a loss.  
The most profitable salesperson, therefore, is the person with the greatest 
profit or smallest loss.  Display the most profitable salesperson (there can be 
more than one).
--------------------------------------------------------------------------------
';

GO
PRINT '
SELECT 
	CAST(S.EmpID AS CHAR(3)) AS employee_ID
  , CAST(Ename AS CHAR(32)) AS employee_name
  , ''$'' + STR((employee_total - Salary),8,2) AS total_profit
FROM SALESPERSONS AS S LEFT JOIN
	(SELECT EmpID, SUM(order_total) AS employee_total 
	 FROM ORDERS AS O LEFT JOIN 
		(SELECT OrderID, SUM(Qty*Price) AS order_total
		 FROM ORDERITEMS LEFT JOIN INVENTORY
		 ON ORDERITEMS.PartID = INVENTORY.PartID
		 GROUP BY OrderID) AS OT ON O.OrderID = OT.OrderID
	 GROUP BY EmpID) AS TOTALS ON S.EmpID = TOTALS.EmpID
WHERE (employee_total - Salary) = (SELECT MAX(employee_total - Salary) 
								   FROM SALESPERSONS AS S LEFT JOIN
									  (SELECT EmpID, SUM(order_total) AS employee_total 
									   FROM ORDERS AS O LEFT JOIN 
									      (SELECT OrderID, SUM(Qty*Price) AS order_total
										   FROM ORDERITEMS LEFT JOIN INVENTORY
										   ON ORDERITEMS.PartID = INVENTORY.PartID GROUP BY OrderID) AS OT 
									   ON O.OrderID = OT.OrderID GROUP BY EmpID) AS TOTALS 
								   ON S.EmpID = TOTALS.EmpID);
';

GO
SELECT 
	CAST(S.EmpID AS CHAR(3)) AS employee_ID
  , CAST(Ename AS CHAR(32)) AS employee_name
  , '$' + STR((employee_total - Salary),8,2) AS total_profit
FROM SALESPERSONS AS S LEFT JOIN
	(SELECT EmpID, SUM(order_total) AS employee_total 
	 FROM ORDERS AS O LEFT JOIN 
		(SELECT OrderID, SUM(Qty*Price) AS order_total
		 FROM ORDERITEMS LEFT JOIN INVENTORY
		 ON ORDERITEMS.PartID = INVENTORY.PartID
		 GROUP BY OrderID) AS OT ON O.OrderID = OT.OrderID
	 GROUP BY EmpID) AS TOTALS ON S.EmpID = TOTALS.EmpID
WHERE (employee_total - Salary) = (SELECT MAX(employee_total - Salary) 
								   FROM SALESPERSONS AS S LEFT JOIN
									  (SELECT EmpID, SUM(order_total) AS employee_total 
									   FROM ORDERS AS O LEFT JOIN 
									      (SELECT OrderID, SUM(Qty*Price) AS order_total
										   FROM ORDERITEMS LEFT JOIN INVENTORY
										   ON ORDERITEMS.PartID = INVENTORY.PartID GROUP BY OrderID) AS OT 
									   ON O.OrderID = OT.OrderID GROUP BY EmpID) AS TOTALS 
								   ON S.EmpID = TOTALS.EmpID);

GO
PRINT '
--------------------------------------------------------------------------------
CIS276_Lab2
9.	Who is our second-most profitable salesperson?
Projection:    SALESPERSONS.EmpID, SALESPERSONS.Ename, 
              (SUM(ORDERITEMS.Qty*INVENTORY.Price) - SALESPERSONS.Salary)
Instructions:  A salesperson''s profit (or loss) is the difference between what 
the person sold and what the person earns:
((SUM(ORDERITEMS.Qty*INVENTORY.Price) - SALESPERSONS.Salary)).  
If the value is positive then there is a profit, otherwise there is a loss.  
The most profitable salesperson, therefore, is the person with the greatest 
profit or smallest loss.  The second-most profitable salesperson is the person 
with the next greatest profit or next smallest loss.  Display the second-most
profitable salesperson (there can be more than one).  Do not hard-code the 
results of a previous query - that simply creates a data-dependent query.
--------------------------------------------------------------------------------
';

GO
PRINT '
SELECT TOP (1) 
	CAST(EmpID AS CHAR(3)) AS employee_ID
  , CAST(Ename AS CHAR(32)) AS employee_name
  , ''$'' + STR(total_profit,8,2) AS employee_profit
FROM (SELECT DISTINCT TOP (2) TOTALS.EmpID, Ename, (employee_total - Salary) AS total_profit 
	  FROM SALESPERSONS AS S LEFT JOIN
		 (SELECT EmpID, SUM(order_total) AS employee_total 
		  FROM ORDERS AS O LEFT JOIN 
			  (SELECT OrderID, SUM(Qty*Price) AS order_total
			   FROM ORDERITEMS LEFT JOIN INVENTORY
			   ON ORDERITEMS.PartID = INVENTORY.PartID
			   GROUP BY OrderID) AS OT ON O.OrderID = OT.OrderID
		  GROUP BY EmpID) AS TOTALS ON S.EmpID = TOTALS.EmpID
	  WHERE employee_total IS NOT NULL
	  ORDER BY (employee_total - Salary) DESC) AS SP
ORDER BY total_profit ASC;
';

GO
SELECT TOP (1) 
	CAST(EmpID AS CHAR(3)) AS employee_ID
  , CAST(Ename AS CHAR(32)) AS employee_name
  , '$' + STR(total_profit,8,2) AS employee_profit
FROM (SELECT DISTINCT TOP (2) TOTALS.EmpID, Ename, (employee_total - Salary) AS total_profit 
	  FROM SALESPERSONS AS S LEFT JOIN
		 (SELECT EmpID, SUM(order_total) AS employee_total 
		  FROM ORDERS AS O LEFT JOIN 
			  (SELECT OrderID, SUM(Qty*Price) AS order_total
			   FROM ORDERITEMS LEFT JOIN INVENTORY
			   ON ORDERITEMS.PartID = INVENTORY.PartID
			   GROUP BY OrderID) AS OT ON O.OrderID = OT.OrderID
		  GROUP BY EmpID) AS TOTALS ON S.EmpID = TOTALS.EmpID
	  WHERE employee_total IS NOT NULL
	  ORDER BY (employee_total - Salary) DESC) AS SP
ORDER BY total_profit ASC;

GO
PRINT '
--------------------------------------------------------------------------------
CIS276_Lab2
10.	What are the discounts for each line item on orders of five or more units?
Projection:    Orderid, Partid, Description, Qty, "Unit Price", "Original Price", 
               "Quantity Deduction", and "Final Price"
Instructions:  We have decided to give quantity discounts to encourage more sales.  
• If an order contains five or more units of a given product we will give a 
  two percent discount for that line item.  
• If an order contains ten or more units of a given product we will give a 
  five percent discount on that line item.
Produce output that prints the OrderID, PartID, Description, Qty ordered, 
unit Price, the total original Price(Qty ordered * Price), the total 
discount value (shown as money or percent), and the total final Price of the 
product after the discount.  Display only those line items subject to the 
discount in ascending order by the OrderID and PartID.  Use the CASE statement.
--------------------------------------------------------------------------------
';

GO
PRINT '
SELECT 
	CAST(OrderID AS CHAR(4)) AS order_number
  , CAST(I.PartID AS CHAR(4)) AS item_number
  , CAST(Description AS CHAR(24)) AS description
  , CAST(Qty AS CHAR(3)) AS quanity
  , ''$'' + STR(Price,8,2) AS unit_price
  , ''$'' + STR((Price*Qty),8,2) AS order_total
  ,	discount_amount = CASE
		WHEN Qty >= 10 THEN ''5% Discount''
		WHEN Qty >= 5 THEN ''2% Discount''
		ELSE ''No Discount''
	END
  , discounted_total = CASE
		WHEN Qty >= 10 THEN ''$'' + STR((0.95 * (Price * Qty)),8,2)
		WHEN Qty >= 5 THEN ''$'' + STR((0.98 * (Price * Qty)),8,2)
		ELSE ''$'' + STR((Price * Qty),8,2)
	END
FROM INVENTORY AS I
JOIN ORDERITEMS AS O
ON I.PartID = O.PartID
WHERE Qty >= 5
ORDER BY OrderID ASC, I.PartID ASC;
';

GO
SELECT 
	CAST(OrderID AS CHAR(4)) AS order_number
  , CAST(I.PartID AS CHAR(4)) AS item_number
  , CAST(Description AS CHAR(24)) AS description
  , CAST(Qty AS CHAR(3)) AS quanity
  , '$' + STR(Price,8,2) AS unit_price
  , '$' + STR((Price*Qty),8,2) AS order_total
  ,	discount_amount = CASE
		WHEN Qty >= 10 THEN '5% Discount'
		WHEN Qty >= 5 THEN '2% Discount'
		ELSE 'No Discount'
	END
  , discounted_total = CASE
		WHEN Qty >= 10 THEN '$' + STR((0.95 * (Price * Qty)),8,2)
		WHEN Qty >= 5 THEN '$' + STR((0.98 * (Price * Qty)),8,2)
		ELSE '$' + STR((Price * Qty),8,2)
	END
FROM INVENTORY AS I
JOIN ORDERITEMS AS O
ON I.PartID = O.PartID
WHERE Qty >= 5
ORDER BY OrderID ASC, I.PartID ASC;

GO
PRINT '
End of CIS276_Lab2
';

