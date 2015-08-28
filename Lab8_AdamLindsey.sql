/*
********************************************************************************
CIS276 @PCC using SQL Server 2012
LAB 8 -- Transact SQL
20131125 Adam Weston Lindsey
********************************************************************************
*/
-- specify database to be used
USE s276ALindsey
GO

PRINT '
--------------------------------------------------------------------------------
ValidateCustID 
1.	DROP, CREATE, and test of the procedure, ValidateCustID, that validates 
the entered Custid against the current Custids in the CUSTOMERS table.
--------------------------------------------------------------------------------
';
GO
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'ValidateCustID')
    DROP PROCEDURE ValidateCustID;

GO
CREATE PROCEDURE ValidateCustID
	@CustomerID SMALLINT,
	@vResult CHAR(5) OUTPUT
AS 
BEGIN
	IF EXISTS(SELECT * FROM CUSTOMERS WHERE CustID = @CustomerID)
		SET @vResult = 'true'
	ELSE
		SET @vResult = 'false'
END;

GO
--Test script for ValidateCustID procedure
BEGIN
    DECLARE @myCustID SMALLINT;  -- holds value for INPUT to procedure
    DECLARE @myResult CHAR(5);  -- holds value returned from procedure

    SET @myCustID = 1;  -- this is for a good validation
    EXECUTE ValidateCustID @myCustID, @myResult OUTPUT;
    PRINT 'ValidateCustID successful for CustID ' + LTRIM(STR(@myCustID)) + ' - ' + @myResult;

    SET @myCustID = 5;  -- this is for a bad validation
    EXECUTE ValidateCustID @myCustID, @myResult OUTPUT;
    IF @myResult = 'false'
        BEGIN
            PRINT 'ValidateCustID says bad CustID entered: ' + LTRIM(STR(@myCustID))
			PRINT 'That customer id does not exist - ' + @myResult;
        END;
    ELSE
        BEGIN
            PRINT 'ValidateCustID successful for ' + STR(@myCustID) + ' - ' + @myResult;
        END;
END;

GO
PRINT '
--------------------------------------------------------------------------------
ValidateOrderID
2.	DROP, CREATE, and test of the procedure, ValidateOrderID, that validates the 
entered Orderid against the current OrderIDs in the ORDERS table for the entered 
CustID. 
--------------------------------------------------------------------------------
';
GO
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'ValidateOrderID')
    DROP PROCEDURE ValidateOrderID;

GO
CREATE PROCEDURE ValidateOrderID
	@CustID SMALLINT,
	@OrderID SMALLINT,
	@vResult CHAR(5) OUTPUT
AS
BEGIN
	IF EXISTS(SELECT * FROM ORDERS 
			  WHERE OrderID = @OrderID
			  AND CustID = @CustID)
		SET @vResult = 'true'
	ELSE
		SET @vResult = 'false'
END;

GO
--Test script for ValidateOrderID procedure
BEGIN
	DECLARE @myCustID SMALLINT;		--holds value for CustID INPUT
    DECLARE @myOrderID SMALLINT;  -- holds value for OrderID INPUT
    DECLARE @myResult CHAR(5);  -- holds value returned as OUTPUT

    SET @myCustID = 1;
	SET @myOrderID = 6099; -- this is for a good validation
    EXECUTE ValidateOrderID @myCustID, @myOrderID, @myResult OUTPUT;
    PRINT 'ValidateCustID successful for CustID: ' + LTRIM(STR(@myCustID)) + ' and OrderID: ' + LTRIM(STR(@myOrderID)) + ' - ' + @myResult;

    SET @myCustID = 1;
	SET @myOrderID = 13; -- this is for a bad validation
    EXECUTE ValidateOrderID @myCustID, @myOrderID, @myResult OUTPUT;
    IF @myResult = 'false'
        BEGIN
            PRINT 'ValidateOrderID says bad OrderID entered: ' + LTRIM(STR(@myOrderID))
			PRINT 'That customer id and order id does not exist - ' + @myResult;
        END;
    ELSE
        BEGIN
            PRINT 'ValidateOrderID successful for ' + STR(@myOrderID) + ' - ' + @myResult;
        END;
END;

GO
PRINT'
--------------------------------------------------------------------------------
ValidatePartID
3.	DROP, CREATE, and test of the procedure, ValidatePartID, that validates the 
entered Partid against the current Partids in the INVENTORY table.
--------------------------------------------------------------------------------
';
GO
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'ValidatePartID')
    DROP PROCEDURE ValidatePartID;

GO
CREATE PROCEDURE ValidatePartID
	@PartID SMALLINT,
	@myResult CHAR(5) OUTPUT
AS
BEGIN
	IF EXISTS(SELECT * FROM INVENTORY WHERE PartID = @PartID)
		SET @myResult = 'true'
	ELSE
		SET @myResult = 'false'
END;

GO
-- testing block for ValidatePartID
BEGIN
    DECLARE @myPartID SMALLINT;  -- holds value for INPUT
    DECLARE @myResult CHAR(5);  -- holds value for OUTPUT

    SET @myPartID = 1001;  -- this is for a good validation
    EXECUTE ValidatePartID @myPartID, @myResult OUTPUT;
    PRINT 'ValidatePartID successful for Part #' + LTRIM(STR(@myPartID)) + ' - ' + @myResult;

    SET @myPartID = 15;  -- this is for a bad validation
    EXECUTE ValidatePartID @myPartID, @myResult OUTPUT;
    IF @myResult = 'false'
        BEGIN
            PRINT 'ValidatePartID says bad PartID entered: ' + LTRIM(STR(@myPartID))
			PRINT 'That customer id does not exist - ' + @myResult;
        END
    ELSE
        BEGIN
            PRINT 'ValidatePartID successful for ' + STR(@myPartID) + ' - ' + @myResult;
        END;
END;

PRINT'
--------------------------------------------------------------------------------
ValidateQty
4.	DROP, CREATE, and test of the procedure, ValidateQty, that validates the 
entered Qty is greater than zero. 
--------------------------------------------------------------------------------
';
GO
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'ValidateQty')
    DROP PROCEDURE ValidateQty;

GO
CREATE PROCEDURE ValidateQty
	@vQty SMALLINT,
	@vResult CHAR(5) OUTPUT
AS
BEGIN
	IF @vQty > 0
		SET @vResult = 'true'
	ELSE
		SET @vResult = 'false'
END;

GO
-- testing block for ValidateQty
BEGIN
    DECLARE @myQty SMALLINT;  -- holds value for INPUT
    DECLARE @myResult CHAR(5);  -- holds value for OUTPUT

    SET @myQty = 1001;  -- this is for a good validation
    EXECUTE ValidateQty @myQty, @myResult OUTPUT;
    PRINT 'ValidateQty successful for Part #' + LTRIM(STR(@myQty)) + ' - ' + @myResult;

    SET @myQty = 0;  -- this is for a bad validation
    EXECUTE ValidatePartID @myQty, @myResult OUTPUT;
    IF @myResult = 'false'
        BEGIN
            PRINT 'ValidateQty says bad Qty entered: ' + LTRIM(STR(@myQty))
			PRINT 'That Qty is not valid - ' + @myResult;
        END
    ELSE
        BEGIN
            PRINT 'ValidateQty successful for ' + STR(@myQty) + ' - ' + @myResult;
        END;
END;

GO
PRINT'
--------------------------------------------------------------------------------
InventoryUpdateTrg
5.	DROP, CREATE, and test of the UPDATE trigger on INVENTORY table.
Checks value for updated StockQty and includes error handling
--------------------------------------------------------------------------------
';
GO
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'InventoryUpdateTRG')
    BEGIN DROP TRIGGER InventoryUpdateTRG; END;

GO
CREATE TRIGGER InventoryUpdateTRG
ON INVENTORY
FOR UPDATE
AS
BEGIN
	IF(SELECT StockQty FROM INSERTED) < 0
	BEGIN
	-- your error handling
		RAISERROR('NOT ENOUGH QTY IN STOCK!',0,1)
		ROLLBACK
	END
END;

GO
-- testing blocks for InventoryUpdateTrg
-- There should be at least three tests
BEGIN
	DECLARE @myPartID SMALLINT;  -- holds value for INPUT
	DECLARE @myQty SMALLINT;  -- holds value for INPUT

    SET @myPartID = 1001;
	SET @myQty = 15;  -- this is for a good validation
    UPDATE INVENTORY
	SET StockQty = StockQty - @myQty
	WHERE PartID = @myPartID
    PRINT 'UPDATE QTY successful for Part #' + LTRIM(STR(@myPartID)) + ' - QTY reduced by ' + LTRIM(STR(@myQty));

    SET @myQty = 101;  -- this is for a bad validation
    UPDATE INVENTORY
	SET StockQty = StockQty - @myQty
	WHERE PartID = @myPartID

	UPDATE INVENTORY-- also a bad validation
	SET StockQty = -1
	WHERE PartID = 1001
END;

GO
PRINT'
--------------------------------------------------------------------------------
OrderitemsInsertTrg

6.	DROP, CREATE, and test of the INSERT trigger on ORDERITEMS table. 
Performs the INVENTORY UPDATE and includes error handling
--------------------------------------------------------------------------------
';
GO
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'OrderitemsInsertTRG')
    BEGIN DROP TRIGGER OrderitemsInsertTRG; END;

GO
CREATE TRIGGER OrderitemsInsertTRG
ON ORDERITEMS
FOR INSERT
AS
BEGIN 
	DECLARE @vPartID SMALLINT;
	DECLARE @vQty SMALLINT;
	DECLARE @result CHAR(5);
    -- get the new values for Qty and PartID from the INSERTED table
	SET @vPartID = (SELECT PartID FROM INSERTED);
	SET @vQty = (SELECT Qty FROM INSERTED);

	EXECUTE ValidatePartID @vPartID, @result OUTPUT;
	IF @result = 'false'
		BEGIN
			RAISERROR('That PARTID Does Not Exist! ROLLBACK',0,1)
			ROLLBACK
		END
	ELSE
		BEGIN
			EXECUTE ValidateQty @vQty, @result OUTPUT;
			IF @result = 'false'
				BEGIN
					RAISERROR('That Qty is not valid! ROLLBACK',0,1)
					ROLLBACK
				END
			ELSE
				BEGIN
					UPDATE INVENTORY
					SET StockQty = StockQty - @vQty
					WHERE PartID = @vPartID
					PRINT 'INVENTORY UPDATED!'
					COMMIT;
				END
		END
END;

GO
-- testing blocks for OrderItemsInsertTrg
-- There should be at least three testing blocks here
DECLARE @myOrderID SMALLINT;
DECLARE @myDetail SMALLINT;
DECLARE @myPartID SMALLINT;
DECLARE @myQty SMALLINT;
BEGIN
	PRINT 'TEST 1: ordering more than inventory has'
	SET @myOrderID = 3003;
	SET @myDetail = 4;
	SET @myPartID = 3001;
	SET @myQty = 5;
	INSERT INTO ORDERITEMS (OrderID, Detail, PartID, Qty)
	VALUES (@myOrderID, @myDetail, @myPartID, @myQty);

	PRINT 'TEST 2: bad order ID'
	SET @myOrderID = 5;
	SET @myDetail = 4;
	SET @myPartID = 1001;
	SET @myQty = 1;
	INSERT INTO ORDERITEMS (OrderID, Detail, PartID, Qty)
	VALUES (@myOrderID, @myDetail, @myPartID, @myQty);

	PRINT 'TEST 3: bad qty'
	SET @myOrderID = 3003;
	SET @myDetail = 4;
	SET @myPartID = 1001;
	SET @myQty = -1;
	INSERT INTO ORDERITEMS (OrderID, Detail, PartID, Qty)
	VALUES (@myOrderID, @myDetail, @myPartID, @myQty);

	PRINT 'TEST 4: this bad boy should work just fine!'
	SET @myOrderID = 3003;
	SET @myDetail = 4;
	SET @myPartID = 1001;
	SET @myQty = 1;
	INSERT INTO ORDERITEMS (OrderID, Detail, PartID, Qty)
	VALUES (@myOrderID, @myDetail, @myPartID, @myQty);
END;

GO
PRINT'
--------------------------------------------------------------------------------
GetNewDetail
7.	DROP, CREATE, and test of the procedure, GetNewDetail, that determines the 
Detail value for new line item. (SQL Server will not allow you to assign a column 
value to the newly inserted row inside of the trigger).
You can handle NULL within the projection or it can be done in two steps
(SELECT and then test). It is important to deal with the possibility of NULL
because Detail is part of the primary key and therefore cannot contain NULL.
--------------------------------------------------------------------------------
';
GO
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'GetNewDetail')
    BEGIN DROP PROCEDURE GetNewDetail; END;

GO
CREATE PROCEDURE GetNewDetail 
-- OrderID in, new or next Detail out
	@vOrderID SMALLINT,
	@vResult SMALLINT OUTPUT
AS 
BEGIN
	IF (SELECT COUNT(Detail) FROM ORDERITEMS WHERE OrderID = @vOrderID) = 0
		SET @vResult = 1
	ELSE
		SET @vResult = (SELECT COUNT(Detail) + 1 FROM ORDERITEMS WHERE OrderID = @vOrderID)
END;

GO
-- testing block for GetNewDetail assumes OrderID has already been validated
BEGIN  
	DECLARE @myOrderID SMALLINT;  -- holds value for INPUT to procedure
    DECLARE @myResult SMALLINT;  -- holds value returned from procedure

    SET @myOrderID = 3001;  -- Test with a valid OrderID having NO detail lines
    EXECUTE GetNewDetail @myOrderID, @myResult OUTPUT;
    PRINT 'No orderitems exist for that order - Detail# is ' + LTRIM(STR(@myResult));
	
    SET @myOrderID = 3003;  -- Test with a valid OrderID having detail lines already
    EXECUTE GetNewDetail @myOrderID, @myResult OUTPUT;
	PRINT 'Orderitems do exist for that order - Detail# is ' + LTRIM(STR(@myResult));
END;

GO
PRINT'
--------------------------------------------------------------------------------
AddLineItem
8.	DROP and CREATE of the procedure that does the transaction processing, 
AddLineItem. Before the transaction does a COMMIT or ROLLBACK, print a statement 
that says the transaction is committed or rolled back.
This procedure calls GetNewDetail procedure and, with successful return,
performs an INSERT to the ORDERITEMS table which in turn performs an UPDATE 
to the INVENTORY table. Error handling determines COMMIT/ROLLBACK.
--------------------------------------------------------------------------------
';
GO
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'AddLineItem')
    BEGIN DROP PROCEDURE AddLineItem; END;

GO
CREATE PROCEDURE AddLineItem
-- with orderid, partid and qty input
	@myOrderID SMALLINT,
	@myQty SMALLINT,
	@myPartID SMALLINT
	
AS
BEGIN
DECLARE @detail SMALLINT
BEGIN TRANSACTION    -- this is the only BEGIN TRANSACTION for the lab assignment
    EXECUTE GetNewDetail @myOrderID, @detail OUTPUT;
    INSERT INTO ORDERITEMS (OrderID, Detail, PartID, Qty)
    VALUES (@myOrderID, @detail, @myPartID, @myQty);
    -- your error handling
--END TRANSACTION;
END;


GO
PRINT'
--------------------------------------------------------------------------------
Lab8proc
9.	DROP and CREATE of the procedure, Lab8proc, that receives the Custid, 
Orderid, Partid, and Qty as input parameters and essentially brings all the 
other parts together:
	1.	Print a statement that Lab8proc begins.
	2.	EXECUTE the Custid validation procedure and print a line giving the input 
	Custid and a statement that it is valid or invalid.
	3.	EXECUTE the Orderid validation procedure and print a line giving the input 
	Orderid value and a statement that it is valid or invalid. Print another line 
	stating the Orderid and Custid values are valid together or not.
	4.	EXECUTE the Partid validation procedure and print a line giving the input 
	Partid value and a statement that it is valid or invalid.
	5.	EXECUTE the Qty validation procedure and print a line giving the input Qty 
	value and a statement that it is valid or invalid.
	6.	If all is good, print a message stating that Lab8proc validations were good 
	so the transaction continues and then EXECUTE the add line item procedure; 
	otherwise print a message stating that Lab8proc is ending the transaction and 
	do not run the add line item procedure.
This is a stored procedure that accepts the 4 pieces of input: Custid, Orderid, 
Partid, and Qty (in that order please). Lab8proc will validate all the data and 
do the transaction processing by calling the previously written and tested modules.
--------------------------------------------------------------------------------
';
GO
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'Lab8proc')
    BEGIN DROP PROCEDURE Lab8proc; END;

GO
CREATE PROCEDURE Lab8proc 
    @vCustID SMALLINT,
	@vOrderID SMALLINT,
	@vPartID SMALLINT,
	@vQty SMALLINT
AS
BEGIN
	DECLARE @result CHAR(5)
    -- DECLARE user defined variables for use in this procedure
    EXECUTE ValidateCustID @vCustID, @result OUTPUT
	IF @result <> 'false'
		BEGIN
		EXECUTE ValidateOrderID @vCustID, @vOrderID, @result OUTPUT
		IF @result <> 'false'
			BEGIN
			EXECUTE ValidatePartID @vPartID, @result OUTPUT
			IF @result <> 'false'
				BEGIN
				EXECUTE ValidateQty @vQty, @result OUTPUT
				IF @result <> 'false'
					BEGIN
					EXECUTE AddLineItem @vOrderID, @vPartID, @vQty
					PRINT 'UPDATED!'
					COMMIT
					END
				ELSE PRINT 'Invalid Qty!'
				END
			ELSE PRINT 'Invalid PartID!'
			END
		ELSE PRINT 'Invalid OrderID!'
		END
	ELSE PRINT 'Invalid CustID!'
END;

GO
PRINT'
--------------------------------------------------------------------------------
Testing of Lab8proc 
10.	Testing of Lab8proc (similar to the testing you did previously for the Oracle 
labs 6 and 7). Please use different data for your tests.
--------------------------------------------------------------------------------
';
SELECT * FROM ORDERITEMS
GO
DECLARE
	@myCustID SMALLINT,
	@myOrderID SMALLINT,
	@myPartID SMALLINT,
	@myQty SMALLINT
BEGIN
	SET @myCustID = 0;
	SET @myOrderID = 0;
	SET @myPartID = 0;
	SET @myQty = 0;
    EXECUTE Lab8proc @myCustID, @myOrderID, @myPartID, @myQty;

	SET @myCustID = 1;
	SET @myOrderID = 0;
	SET @myPartID = 0;
	SET @myQty = 0;
    EXECUTE Lab8proc @myCustID, @myOrderID, @myPartID, @myQty;

	SET @myCustID = 1;
	SET @myOrderID = 6099;
	SET @myPartID = 0;
	SET @myQty = 0;
    EXECUTE Lab8proc @myCustID, @myOrderID, @myPartID, @myQty;

	SET @myCustID = 1;
	SET @myOrderID = 6099;
	SET @myPartID = 1001;
	SET @myQty = 0;
    EXECUTE Lab8proc @myCustID, @myOrderID, @myPartID, @myQty;

	SET @myCustID = 1;
	SET @myOrderID = 6099;
	SET @myPartID = 1001;
	SET @myQty = -1;
    EXECUTE Lab8proc @myCustID, @myOrderID, @myPartID, @myQty;

	SET @myCustID = 1;
	SET @myOrderID = 6099;
	SET @myPartID = 1001;
	SET @myQty = 101;
    EXECUTE Lab8proc @myCustID, @myOrderID, @myPartID, @myQty;

	SET @myCustID = 1;
	SET @myOrderID = 6099;
	SET @myPartID = 1001;
	SET @myQty = 1;
    EXECUTE Lab8proc @myCustID, @myOrderID, @myPartID, @myQty;

END;