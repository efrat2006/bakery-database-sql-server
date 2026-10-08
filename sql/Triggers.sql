--טריגר למניעת הזמנת מוצר עם אין מספיק במלאי
--inserted  - זוהי טבלה שמכילה את השורות שאמורות להכנס לטבלה שעליה מוגדר הטריגר
CREATE TRIGGER PreventOverOrder
on OrderDetails
INSTEAD OF INSERT 
AS
BEGIN
    IF EXISTS(select 1 from inserted i join Products p on i.ProductId = p.ProductId where p.Units < i.Quantity)
	BEGIN
	    PRINT 'אין מספיק במלאי'
	    ROLLBACK
		RETURN
	END
	INSERT INTO OrderDetails(OrderId,ProductId, Quantity, UnitPriceAtPurchase)
    select OrderId, ProductId, Quantity, UnitPriceAtPurchase FROM inserted
END
--הפעלת הפרוצדורה
exec AddOrderItem 1,1,2000

--טריגר לעדכון כמות המלאי לאחר הזמנה
CREATE TRIGGER UpdateUnits
on OrderDetails
AFTER INSERT 
AS
BEGIN
    UPDATE p
	SET P.Units = P.Units - OD.Quantity
	from Products p
	INNER JOIN inserted OD on OD.ProductId = p.ProductId
END

--טריגר לשינוי סטטטוס לקוח
CREATE TRIGGER ChangeCustomerStatus
on Customers
INSTEAD OF DELETE
AS
BEGIN
     UPDATE c
	 set c.Status = 0
	 from deleted d join Customers c on d.CustomerId = c.CustomerId
END
--מחיקת מוצר (שינוי סטטוס) והפעלת הטריגר
exec DeleteCustomer 1

--טריגר שינוי סטטוס המוצר
CREATE TRIGGER ChangeProductStatus
on Products
INSTEAD OF DELETE
AS
BEGIN
     UPDATE p
	 set p.Status = 0
	 from Products p join deleted d on p.ProductId = d.ProductId
END
--מחיקת מוצר (שינוי סטטוס) והפעלת הטריגר
exec DeleteProduct 1