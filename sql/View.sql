--שולפת קוד מוצר, שם מוצר, קוד קטגוריה, מחיר, כמות היחידות שנותרו, קוד אלרגן
CREATE VIEW ProductProductsAllergiesAllergies
AS
select p.ProductId, p.ProductName, p.CategoryId, p.Price, p.Units, a.AllergyName
from Products p
join ProductsAllergies pal on p.ProductId = pal.ProductId
join Allergies a on a.AllergyId = pal.AllergyId
where p.Status = 1
--קריאה לוויו
select * from ProductProductsAllergiesAllergies

--שולפת את פרטי ההזמנות
CREATE VIEW OrderOrderDetailsProducts
AS
select o.OrderId, o.CustomerId, o.OrderDate, p.ProductName,c.CategoryName, od.Quantity, od.UnitPriceAtPurchase
from Orders o
join OrderDetails od on o.OrderId = od.OrderId
join Products p on p.ProductId = od.ProductId
join Categories c on c.CategoryId = p.CategoryId
--קריאה לוויו
select * from OrderOrderDetailsProducts

