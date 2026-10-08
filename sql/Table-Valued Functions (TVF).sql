--פונקציה שמחזירה את כל המוצרים ללא אלרגיה מסוימת
CREATE FUNCTION dbo.GetProdWithoutAllergy(@AllergyName nvarchar(25))
RETURNS TABLE
AS
RETURN(
select p.ProductId, p.ProductName, p.Price, c.CategoryName, p.Units, a.AllergyName
from Products p join Categories c on p.CategoryId = c.CategoryId  
left join ProductsAllergies pal on p.ProductId = pal.ProductId
left join Allergies a on a.AllergyId = pal.AllergyId
where p.Status = 1 AND p.ProductId not in (select p.ProductId
                         from Products p join ProductsAllergies pal on p.ProductId = pal.ProductId
						 join Allergies a on a.AllergyId = pal.AllergyId
						 where a.AllergyId = (select TOP 1 a.AllergyId
						                      from Allergies a
											  where a.AllergyName = @AllergyName))
)
--קריאה לפונקציה
select *
from dbo.GetProdWithoutAllergy('גלוטן')

--פונקציה שמקבלת קוד לקוח ומחזירה את המוצרים ללא האלרגנים שהוא מעוניין להימנע
--תת שאילתא המחזירה את כל המוצרים המכילים אלרגנים שהוא מעוניין להמנע מהם
CREATE FUNCTION dbo.GetPriorityProdCus(@CustomerId INT)
RETURNS TABLE
AS
	RETURN(
              select p.ProductId, p.ProductName, p.price,c.CategoryName, a.AllergyName
              from Products p left join ProductsAllergies pal on p.ProductId = pal.ProductId
              left join Allergies a on a.AllergyId =  pal.AllergyId
              left join Categories c on c.CategoryId = p.CategoryId
              where @CustomerId IS NOT NULL AND EXISTS(select 1 from Customers where CustomerId = @CustomerId)And
			       p.Status =1 AND 
				   p.ProductId not in(select p.ProductId
                                        from Customers c join CustomerAllergyPriority cap on c.CustomerId = cap.CustomerId
                                        join Allergies a on a.AllergyId = cap.AllergyId
                                        join ProductsAllergies pal on pal.AllergyId = a.AllergyId
                                        join Products p on p.ProductId = pal.ProductId
                                        where c.CustomerId = @CustomerId)

          
)
--קריאה לפונקציה
select * from dbo.GetPriorityProdCus(2)

--פונקציה המחזירה טבלה ובה כל האלרגנים שהמוצר מכיל
CREATE FUNCTION dbo.GetProductAllergies(@ProductName NVARCHAR(25))
RETURNS TABLE
AS
    RETURN(select p.ProductId, p.ProductName, a.AllergyName
	   from Products p join ProductsAllergies pal on p.ProductId = pal.ProductId
	   join Allergies a on a.AllergyId = pal.AllergyId 
	   where pal.ProductId = (select p.ProductId
	                          from Products p
	                          where p.ProductName = @ProductName))
--קריאה לפונקציה
select*
from dbo.GetProductAllergies('פאי פיצוחים')

--שליפת כל המוצרים (הפעילים) המשתייכים לשם הקטגוריה המתקבלת
CREATE FUNCTION dbo.GetCategoryProducts(@CategoryName nvarchar(25))
RETURNS TABLE
AS
RETURN(select p.ProductId, ProductName, p.Price, c.CategoryName, p.Units, p.Status
	        from Products p join Categories c on p.CategoryId = c.CategoryId
			where p.Status = 1 AND p.CategoryId = (select c.CategoryId from Categories c 
			                      where c.CategoryName = @CategoryName))
--קריאה לפונקציה
select *
from dbo.GetCategoryProducts('עוגות גבינה')

--שליפת כל המוצרים (הפעילים) שעולים החל ממחיר מסוים
CREATE FUNCTION dbo.GetProductsAbovePrice(@Price MONEY)
RETURNS TABLE
AS
   RETURN(select p.ProductId, p.ProductName, p.Price, c.CategoryName, p.Units, p.Status
          from Products p join Categories c on p.CategoryId = c.CategoryId
          where p.Status = 1 AND p.Price >= @Price)
--קריאה לפונקציה
select *
from dbo.GetProductsAbovePrice(25)

--שליפת המוצר הכי יקר מכל קטגוריה
CREATE FUNCTION dbo.GetExpensiveCategoryProd()
RETURNS TABLE
AS
   RETURN(select p.ProductId, p.ProductName, p.Price,  c.CategoryName, p.Units, p.Status
          from Products p join Categories c on p.CategoryId = c.CategoryId
		  where p.Status = 1 AND p.Price >=ALL (select p2.Price
		                                        from Products p2
							                    where p2.Status = 1 AND p2.CategoryId = p.CategoryId))
--קריאה לפונקציה
select *
from dbo.GetExpensiveCategoryProd()

