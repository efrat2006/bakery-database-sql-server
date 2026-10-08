--פונקציה המחזירה האם חברי מועדון קונים יותר משאר הלקוחות
--כמה חברי מועדיון יש
--מה מחיר הקניות שלהם
--כמה לקוחות אינם חברי מועדון

--ISNULL היא פונקציה שמחזירה ערך חלופי במקום ערך שהוא NULL
CREATE FUNCTION dbo.IsClubMembersBuyMore()
RETURNS BIT
AS
BEGIN
   declare @member float
   declare @notMember float

--ממוצע קניה לחבר מועדון
   set @member = ISNULL((select SUM(od.UnitPriceAtPurchase * od.Quantity)/ COUNT(DISTINCT c.CustomerId)
                  from Customers c join Orders o on o.CustomerId = c.CustomerId
                  join OrderDetails od on od.OrderId = o.OrderId
                  where c.ClubMember = 1),0)

   --ממוצע קניה ללקוח שאינו חבר מועדון
   set @notMember = ISNULL((select SUM(od.UnitPriceAtPurchase * od.Quantity) / COUNT(DISTINCT c.CustomerId)
   from Customers c join Orders o on o.CustomerId = c.CustomerId 
   join OrderDetails od on od.OrderId = o.OrderId
   where c.ClubMember = 0),0)

   IF(@member > @notMember)
      RETURN 1
   RETURN 0 
END
--קריאה לפונקציה
select dbo.IsClubMembersBuyMore()

--פונקציה המקבלת שם של מוצר ומחזירה את הקוד מוצר שלו
CREATE FUNCTION dbo.GetProductId(@ProductName NVARCHAR(25))
RETURNS INT
AS
BEGIN
	    declare @productId INT

	    IF @ProductName IS NOT NULL AND EXISTS(select 1 from Products where ProductName = @ProductName) --מחזיר האם יש שורה שעונה על התנאי
		BEGIN
		  select TOP 1 @productId= p.ProductId
          from Products p 
          where p.ProductName = @ProductName
	      RETURN @productId
		END
		 RETURN NULL
END
--קריאה לפונקציה
select dbo.GetProductId('פאי פיצוחים') as 'ProSductId'
 --פונקציה המחזירה את היום  הראשון הרווחי ביותר בחודש בשנה ספציפיים
CREATE FUNCTION dbo.GetTheMostProfitableDay(@year INT, @month INT)
RETURNS DATE
AS
BEGIN       declare @Result DATE
		SET @Result = (	               select TOP 1 CAST(o.OrderDate AS DATE)	               from Orders o join OrderDetails od on o.OrderId = od.OrderId               	   --where DATEPART(year, o.OrderDate) = @year AND DATEPART(month, o.OrderDate) = @month -- מוציא מהתאריך רק את החודש והשנה	                	   where year(o.OrderDate) = @year and month(o.OrderDate) = @month -- מוציא מהתאריך רק את החודש והשנה	                    group by CAST(o.OrderDate AS DATE) --מאחדת את כל השורות של אותו יום ביחד	               order by SUM(od.UnitPriceAtPurchase * od.Quantity) desc 				 ) 	RETURN @result
END
--קריאה לפונקציה
select dbo.GetTheMostProfitableDay(2025, 6) as 'היום הכי רווחי'

--פונקציה המקבלת קוד הזמנה ומחזירה את המחיר הסופי של הקניה
CREATE FUNCTION dbo.FinalOrderPrice(@OrderId INT)
RETURNS Money
AS
BEGIN
     Declare @FinalPrice Money
	 Declare @ClubMember BIT
	 IF @OrderId IS NOT NULL AND EXISTS (select 1 from Orders where OrderId = @OrderId)
	 BEGIN
	      select @FinalPrice  = SUM(od.UnitPriceAtPurchase * od.Quantity)
		  from OrderDetails od
		  where od.OrderId = @OrderId
		  IF Exists(select 1 
		            from Orders o join Customers c on o.CustomerId = c.CustomerId
					 where c.ClubMember = 1 AND o.OrderId = @OrderId)
		  BEGIN 
		      RETURN @FinalPrice * 0.95
		  END
		  RETURN @FinalPrice
	 END
	 RETURN NULL
END
--קריאה לפונקציה
--בדיקה בפונקציות זהות
select dbo.FinalOrderPrice(2) AS FinalPrice --לא חבר מועדון
select dbo.FinalOrderPrice(3) AS FinalPrice --חבר מועדון

