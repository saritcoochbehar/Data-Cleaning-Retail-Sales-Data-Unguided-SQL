-- Data Cleaning Project
Select * From Sales

-- 1. Let's find the Null Values first

DECLARE @TableName NVARCHAR(128) = 'Sales';
DECLARE @SQL NVARCHAR(MAX) = '';

SELECT @SQL = STRING_AGG(
    'SELECT ''' + COLUMN_NAME + ''' AS ColumnName, 
            COUNT(*) AS NullCount 
     FROM ' + @TableName + ' 
     WHERE ' + COLUMN_NAME + ' IS NULL'
, ' UNION ALL ')
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @TableName;

EXEC sp_executesql @SQL;

/*
Transaction_ID	0
Customer_ID	0
Category	0
Item	1213
Price_Per_Unit	609
Quantity	604
Total_Spent	604
Payment_Method	0
Location	0
Transaction_Date	0
Discount_Applied	4199
*/

-- I'm going to go after each evey null value column
-- ITEM--
Select Distinct(Item) From Sales

-- Going to Replace all the Null values with 'Unknown'

Update Sales
Set Item = 'Unknown'
Where Item is Null

-- (1213 rows affected) (Fixed)

Select Distinct(Discount_applied) From Sales

-- Going to Update with 0

Update Sales
Set Discount_Applied = 0
Where Discount_Applied is NUll
-- (4199 rows affected) (Fixed)

-- Now Price_Per_Unit to be Fixed

Update Sales
Set Price_Per_Unit = Total_Spent / Quantity
Where Price_Per_Unit is Null

-- (609 rows affected) -- Fixed

Select * From Sales

-- Now Let us see the Quantity Column

Select Distinct(Quantity) From Sales

-- Finding the Mean, median and mode

-- Mean

Select AVG(Quantity) as Avg_Qty From Sales
-- Avg = 5.53637958399465

-- Median

SELECT 
percentile_Cont(0.5) Within Group (Order By Quantity) 
Over () AS Median
FROM Sales;

-- Ans is 6

-- Mode

Select Quantity, Count(Quantity) as Count
From Sales
Group by Quantity
Order By Count(Quantity) desc

-- Ans is 10

-- So, it is safe to replace the null values withing the column of Quantity would be the Median Value.

Update Sales
Set Quantity = 6
Where Quantity is Null

-- (604 rows affected) -- Changed

Update Sales
Set Total_Spent = Price_Per_Unit * Quantity
Where Total_Spent is Null

-- (604 rows affected) Fixed

-- Now No Null values are there
/*
ColumnName	NullCount
Transaction_ID	0
Customer_ID	0
Category	0
Item	0
Price_Per_Unit	0
Quantity	0
Total_Spent	0
Payment_Method	0
Location	0
Transaction_Date	0
Discount_Applied	0
*/

-- 2. Lets Find the duplicate value
-- There is only one column here, duplicate value should not be there. That is 'Transaction_ID'

Select Transaction_ID, Count(Transaction_ID) as Count 
From Sales
Group By Transaction_ID
Having Count(Transaction_ID) > 1

-- Run Successfully, and does not show any duplicate value.

Select * From Sales
Where Transaction_ID like '% %' or
      Customer_ID like '% %' or
      Category like '% %' or
      Item like '% %' or
      Price_Per_Unit like '% %' or
      Quantity like '% %' or
      Total_Spent like '% %' or
      Payment_Method like '% %' or
      Location like '% %' or
      Transaction_Date like '% %' or
      Discount_Applied like '% %'

-- No Extra Space found

-- 3. Now I have to find the outliers of the columns of Quantity and Total_Spent


With CTE as (
SELECT 
    Quantity,
    abs(Quantity - AVG(Quantity) OVER()) / STDEV(Quantity) OVER() AS z_score
FROM Sales
)

Select * From CTE
Where z_score > 3

-- No outlier there

-- Now Total_Spent
With CTE as (
SELECT 
    Quantity,
    abs(Total_Spent - AVG(Total_Spent) OVER()) / STDEV(Total_Spent) OVER() AS z_score
FROM Sales
)

Select * From CTE
Where z_score > 3

-- No issue there

-- 4. Now, need to check the data types and treat them accordingly
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH, 
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Sales';

/*
COLUMN_NAME	DATA_TYPE	CHARACTER_MAXIMUM_LENGTH	IS_NULLABLE
Transaction_ID	nvarchar	50	NO
Customer_ID	nvarchar	50	NO
Category	nvarchar	50	NO
Item	nvarchar	50	YES
Price_Per_Unit	float	NULL	YES
Quantity	float	NULL	YES
Total_Spent	float	NULL	YES
Payment_Method	nvarchar	50	NO
Location	nvarchar	50	NO
Transaction_Date	date	NULL	NO
Discount_Applied	bit	NULL	YES
*/

Alter Table Sales
Alter Column Transaction_ID varchar(50) not null;

-- Commands completed successfully.

Alter Table Sales
Alter Column Customer_ID varchar(50) not null;

-- Commands completed successfully.

Alter Table Sales
Alter Column Category varchar(50) not null;

-- Commands completed successfully.

Alter Table Sales
Alter Column Item varchar(50) not null;

-- Commands completed successfully.

Alter Table Sales
Alter Column Payment_Method varchar(50) not null;

-- Commands completed successfully.

Alter Table Sales
Alter Column Location varchar(50) not null;

-- Commands completed successfully.

Alter Table Sales
Alter Column Discount_Applied int;

-- Commands completed successfully.

Alter Table Sales
Alter Column Price_Per_Unit float not null;

-- Commands completed successfully.

Alter Table Sales
Alter Column Quantity int not null;

-- Commands completed successfully.

Alter Table Sales
Alter Column Price_Per_Unit float not null;

-- Commands completed successfully.

Alter Table Sales
Alter Column Total_Spent float not null;

-- Commands completed successfully.

/*
COLUMN_NAME	DATA_TYPE	CHARACTER_MAXIMUM_LENGTH	IS_NULLABLE
Transaction_ID	varchar	50	NO
Customer_ID	varchar	50	NO
Category	varchar	50	NO
Item	varchar	50	NO
Price_Per_Unit	float	NULL	NO
Quantity	int	NULL	NO
Total_Spent	float	NULL	NO
Payment_Method	varchar	50	NO
Location	varchar	50	NO
Transaction_Date	date	NULL	NO
Discount_Applied	int	NULL	YES
*/

