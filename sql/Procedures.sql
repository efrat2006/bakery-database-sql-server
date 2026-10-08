--הוספת מוצר
CREATE PROCEDURE AddProduct
@ProductName nvarchar(25),
@Price float,
@CategoryId INT,
@Units INT
AS
BEGIN
  BEGIN TRANSACTION
    BEGIN TRY
       IF(@ProductName IS NULL OR @ProductName = '')
	   BEGIN
	      PRINT 'שם מוצר אינו חוקי' 
		  ROLLBACK TRANSACTION
	      RETURN 
       END
	   IF(@Price IS NULL OR @Price <=0)
	   BEGIN
	      PRINT 'מחיר אינו חוקי' 
		  ROLLBACK TRANSACTION
	      RETURN
       END
	   IF NOT EXISTS(select 1 from Categories where CategoryId = @CategoryId)
	   BEGIN
	      PRINT 'קוד קטגוריה לא קיים' 
		  ROLLBACK TRANSACTION
	      RETURN
       END
	   IF(@Units IS NULL OR @Units <=0)
	   BEGIN
	      PRINT 'כמות אינה חוקית'
		   ROLLBACK TRANSACTION
	      RETURN
       END
	   INSERT INTO Products (ProductName, Price, CategoryId, Units)VAlues(@ProductName, @Price, @CategoryId, @Units)
       PRINT '!נוסף בהצלחה'
	   COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
       ROLLBACK TRANSACTION
       PRINT 'ארעה שגיאה, המוצר לא נוסף'
   END CATCH
END
--הוספת מוצרים
exec AddProduct 'טראפל שוקולד',5.9,7,50

--הוספת אלרגנים למוצר
CREATE PROCEDURE AddAllergiesToProduct
@ProductId INT,
@AllergyId INT
AS
BEGIN
    IF NOT EXISTS(select 1 from Products where ProductId = @ProductId)
	BEGIN
	   PRINT 'קוד מוצר לא קיים' 
	   RETURN
	END
	IF NOT EXISTS(select 1 from Allergies where AllergyId = @AllergyId)
	BEGIN
	   PRINT 'קוד אלרגיה לא קיים' 
	   RETURN
	END
	IF EXISTS(select 1 from ProductsAllergies where ProductId = @ProductId and AllergyId = @AllergyId)
	BEGIN 
	   PRINT 'האלרגן כבר קיים למוצר זה'
	   RETURN
	END
	INSERT INTO ProductsAllergies(ProductId, AllergyId)VALUES(@ProductId, @AllergyId)
	PRINT '!נוסף בהצלחה'
END
--קריאה לפרוצדורה
exec AddAllergiesToProduct 4,4
exec AddAllergiesToProduct 18,1

--הוספת הזמנה
CREATE PROCEDURE AddOrder
@CustomerId INT,
@CustomerComment NVARCHAR(MAX) = NULL
AS
BEGIN
   IF NOT EXISTS(SELECT 1 FROM Customers where CustomerId = @CustomerId)
	 BEGIN
		PRINT 'אינך רשום במערכת, אנא צור חשבון'
	 END
        INSERT INTO Orders (CustomerId, CustomerComments) VALUES(@CustomerId, @CustomerComment) -- בונה הזמנה
		PRINT '!נוסף בהצלחה'
END
--הוספת הזמנות
exec AddOrder 3, "תודה רבה!"

--הוספת מוצר להזמנה
CREATE PROCEDURE AddOrderItem
@OrderId INT,
@ProductId INT,
@Quantity INT
AS
BEGIN
    DECLARE @UnitPriceAtPurchase Float
	IF NOT EXISTS(select 1 from Orders where OrderId = @OrderId)
	BEGIN
	   PRINT 'קוד הזמנה לא קיים' 
	   RETURN 
	END
    IF NOT EXISTS(select 1 from Products where ProductId = @ProductId)
	   BEGIN
	      PRINT 'קוד מוצר לא קיים'
		  RETURN
	   END
	IF (@Quantity <=0)
	BEGIN
	   PRINT 'כמות לא חוקית'
	   RETURN
    END 
	SELECT @UnitPriceAtPurchase = Price
    FROM Products
    WHERE ProductId = @ProductId

    INSERT INTO OrderDetails(OrderId, ProductId, Quantity, UnitPriceAtPurchase)VALUES(@OrderId, @ProductId, @Quantity, @UnitPriceAtPurchase)
	PRINT '!נוסף בהצלחה'
END
--הוספת מוצרים להזמנה
exec AddOrderItem 5,19,1
exec AddOrderItem 6, 3, 1
exec AddOrderItem 6, 4, 2000

--הוספת אלרגנים מהם הלקוח מבקש להימנע
CREATE PROCEDURE AddCustomerAllergiesPriority 
@CustomerId INT, 
@AllergyId INT
AS
BEGIN
    IF NOT EXISTS(select 1 from Customers where CustomerId = @CustomerId)
	BEGIN
	   PRINT 'לקוח לא קיים במערכת, אנא צור חשבון' 
	   RETURN
	END
	IF NOT EXISTS(select 1 from Allergies where AllergyId = @AllergyId)
	BEGIN
	   PRINT 'קוד אלרגן לא קיים' 
	   RETURN
	END
	IF EXISTS(select 1 from CustomerAllergyPriority where CustomerId = @CustomerId and AllergyId = @AllergyId)
	BEGIN 
	   PRINT 'האלרגן כבר רשום ללקוח זה'
	   RETURN
	END
	INSERT INTO CustomerAllergyPriority(CustomerId, AllergyId)VALUES(@CustomerId, @AllergyId)
	PRINT '!נוסף בהצלחה'
END
--קריאה לפרוצדורה
exec AddCustomerAllergiesPriority 3,1

--הוספת לקוח
CREATE PROCEDURE AddCustomer
@FirstName nvarchar(25),
@LastName nvarchar(25),
@ClubMember bit = 1
AS
BEGIN
   IF(@FirstName = '' OR @LastName = ''  OR @FirstName IS NULL OR @LastName IS NULL)
     BEGIN
	     PRINT 'השם שהוזן לא חוקי'
	     RETURN
	 END
	 INSERT INTO Customers(FirstName,LastName, ClubMember)VALUES(@FirstName,@LastName,@ClubMember)
     PRINT '!נוסף בהצלחה'
END
--הפעלת הפרוצדורה
exec AddCustomer 'מיכל','גולן'

--הוספת אלרגיה
CREATE PROCEDURE AddAllergy  
@AllergyName nvarchar(25)
AS
BEGIN
--בודק אם המשתנה @AllergyName הוא ריק לחלוטין (NULL) או מחרוזת ריקה ('' ) אחרי שמסירים ממנה רווחים מיותרים בהתחלה ובסוף
    IF (@AllergyName IS NULL OR LTRIM(RTRIM(@AllergyName)) = '')
	BEGIN
	   PRINT 'ערך לא חוקי'
	END
    IF  EXISTS(select 1 from Allergies where AllergyName = @AllergyName)
	BEGIN
	   PRINT 'האלרגן כבר מעודכן במערכת' 
	   RETURN
	END
	INSERT INTO Allergies(AllergyName)VALUES(@AllergyName)
	PRINT '!נוסף בהצלחה'
END
--קריאה לפוצדורה
exec AddAllergy 'סויה'

--עדכון מחיר מוצר
CREATE  PROCEDURE UpdatePrice
@ProductId INT,
@NewPrice FLOAT
AS
BEGIN
   IF(@NewPrice <=0 or @NewPrice IS NULL)
   BEGIN
      PRINT 'מחיר לא חוקי'
   END
   IF NOT EXISTS(select 1 from Products where ProductId = @ProductId)
	   BEGIN
	      PRINT 'קוד מוצר לא קיים'
		  RETURN
	   END 
	UPDATE Products set Price = @NewPrice 
	where ProductId = @ProductId
	PRINT '!המחיר שונה בהצלחה'
END
--עדכון מחיר
exec UpdatePrice 1,12.9

--מחיקת לקוח
CREATE PROCEDURE DeleteCustomer
@CustomerId INT
AS
BEGIN
     If(@CustomerId IS NULL OR @CustomerId = '' )
	 BEGIN 
	      PRINT 'ערך לא חוקי'
		  RETURN
	END
	IF NOT EXISTS(select 1 from Customers where CustomerId = @CustomerId)
	BEGIN 
	      PRINT 'קוד לקוח לא קיים'
		  RETURN
	END
	delete from Customers
	 where CustomerId = @CustomerId
END 


--מחיקת מוצר 
CREATE PROCEDURE DeleteProduct
@ProductId INT
AS
BEGIN
    IF NOT EXISTS(select 1 from Products where ProductId = @ProductId)
	 BEGIN
	    PRINT ' קוד מוצר לא קיים'
		RETURN 
	 END
	 delete from Products
	 where ProductId = @ProductId
END
