-- שליפת הלקוחות שבצעו הזמנה ומספר ההזמנות שבצעו וסדר הצגת לפי כמות ההזמנות שהזמינו
select c.FirstName + ' ' + c.LastName as FullName,COUNT(o.OrderId) as NumOfOrders
from Customers c join Orders o on c.CustomerId = o.CustomerId
group by c.FirstName, c.LastName
order by COUNT(o.OrderId) desc
--מיון מוצרים לפי מחיר(מהנמוך לגבוה) + הצגת אלרגנים
select p.ProductId, p.ProductName, p.Price, p.CategoryId,al.AllergyName, p.Units
from Products p left join ProductsAllergies pal on p.ProductId = pal.ProductId 
 left join Allergies al on pal.AllergyId = al.AllergyId
order by p.Price asc
--שליפת כמות ההזמנות של לקוח מסוים
declare @CustomerId int
set @CustomerId = 5

Select c.FirstName + ' ' + c.LastName as FullName , count(o.OrderId)
from Customers c left join Orders o on c.CustomerId = o.CustomerId
where c.CustomerId = @CustomerId 
group by  c.FirstName, c.LastName
--שליפת כל חברי המועדון הפעילים
Select *
from Customers
where ClubMember = 1
--מצא את הלקוח שביצע את ההזמנה האחרונה
select TOP 1 c.FirstName + ' ' + c.LastName as 'הלקוח שבצע את הזמנה האחרונה', o.OrderDate
from Orders o join Customers c on o.CustomerId = c.CustomerId
order by OrderId desc
--שליפה של טבלת הזמנות כולל הערות לקוח + מיון מההזמנה האחרונה בסדר יורד
select c.FirstName + ' ' + c.LastName as FullName, o.OrderDate, o.CustomerComments
from Orders o join Customers c on o.CustomerId = c.CustomerId
order by o.OrderDate desc
--שליפה של טבלת מוצרים מלאה + קטגוריות
select p.ProductId, p.ProductName, p.Price, c.CategoryName, p.Units
from Products p join Categories c on p.CategoryId = c.CategoryId
-- הצגת כל המוצרים שעולים מחיר מסוים
declare @price FLOAT
set @price = 12.5

select *
from Products p
where p.Price = @price and p.Status = 1
--שליפת כל הלקוחות עם סך רכישות גבוה מ-50
select c.FirstName, c.LastName, SUM(od.UnitPriceAtPurchase * od.Quantity)
from Customers c join Orders o on o.CustomerId = c.CustomerId 
join OrderDetails od on od.OrderId = o.OrderId
group by c.FirstName, c.LastName
having SUM(od.UnitPriceAtPurchase * od.Quantity) > 50