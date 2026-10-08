--הוספת נתונים לטבלת קטגוריה
INSERT INTO Categories (CategoryName) VALUES ('מאפים מתוקים')
INSERT INTO Categories (CategoryName) VALUES ('קינוחים אישיים')
INSERT INTO Categories (CategoryName) VALUES ('עוגות גבינה')
INSERT INTO Categories (CategoryName) VALUES ('מוסים')
INSERT INTO Categories (CategoryName) VALUES ('עוגות פירות')
INSERT INTO Categories (CategoryName) VALUES ('חגים')
INSERT INTO Categories(CategoryName)values('שוקולדים')

--הכנסת נתונים לטבלת אלרגיות
INSERT INTO Allergies(AllergyName) VALUES ('גלוטן')
INSERT INTO Allergies(AllergyName) VALUES ('חלב')
INSERT INTO Allergies(AllergyName) VALUES ('אגוזים')
INSERT INTO Allergies(AllergyName) VALUES ('בוטנים')
--הכנסת נתונים לטבלת מוצרים
-- הוספת קינוח אישי - מוס שוקולד
INSERT INTO Products (ProductName, Price, CategoryId, Units) VALUES ('מוס שוקולד בלגי אישי', 12.50, (SELECT CategoryId FROM Categories WHERE CategoryName = 'מוסים'), 50)
--עוגת תפוחים קלאסית עם קינמון
INSERT INTO Products(ProductName, Price, CategoryId, Units) VALUES('עוגת תפוחים עם קינמון', 19.50, (SELECT CategoryId FROM Categories WHERE CategoryName = 'עוגות פירות'), 30)
--עוגת דבש
INSERT INTO Products(ProductName, Price, CategoryId, Units) VALUES('עוגת דבש', 15.00, (SELECT CategoryId FROM Categories WHERE CategoryName = 'חגים'), 45)
--קראסון חמאה
INSERT INTO Products(ProductName, Price, CategoryId, Units) VALUES('קראוסון חמאה', 10, (SELECT CategoryId FROM Categories WHERE CategoryName = 'מאפים מתוקים'), 50)
--קראסון שוקולד
INSERT INTO Products(ProductName, Price, CategoryId, Units) VALUES('קראוסון שוקולד', 10, (SELECT CategoryId FROM Categories WHERE CategoryName = 'מאפים מתוקים'), 50)
--עוגת גבינה ולוטוס
INSERT INTO Products(ProductName, Price, CategoryId, Units) VALUES('עוגת גבינה ולוטוס', 65.9, (SELECT CategoryId FROM Categories WHERE CategoryName = 'עוגות גבינה'), 30)
--פאי פיצוחים 
INSERT INTO Products(ProductName, Price, CategoryId, Units) VALUES('פאי פיצוחים', 12.5, (SELECT CategoryId FROM Categories WHERE CategoryName = 'קינוחים אישיים'), 50)

--הכנסת נתונים לטבלת לקוחות
INSERT INTO Customers (FirstName, LastName,ClubMember) VALUES('שלומי', 'ביטון', 1)
INSERT INTO Customers(FirstName, LastName, ClubMember) VALUES('רותי','ישראלי',0)
INSERT INTO Customers(FirstName, LastName, ClubMember) VALUES('נועה','גולדשטיין',0)
INSERT INTO Customers(FirstName, LastName, ClubMember) VALUES('אורית','ששון',1)
INSERT INTO Customers(FirstName, LastName, ClubMember) VALUES('הדס','קליין',1)
INSERT INTO Customers(FirstName, LastName, ClubMember) VALUES('תמר','ברק',1)
--הכנסת נתונים לטבלת הזמנות
INSERT INTO Orders(CustomerId, CustomerComments)VALUES(1,'!תודה רבה')
INSERT INTO Orders(CustomerId)VALUES(2)
INSERT INTO Orders(CustomerId, CustomerComments)VALUES(6,'מבקשת לארוז כל עוגה בנפרד')
INSERT INTO Orders(CustomerId, CustomerComments)VALUES(4,'אשמח שהקרואסונים יהיו הכי טריים שיש')
INSERT INTO Orders(CustomerId, CustomerComments)VALUES(2,'אני אלרגית לבוטנים, אנא ודאו שאין עקבות של אגוזים')
--הכנסת נתונים לטבלת מוצרים אלרגיות
INSERT INTO ProductsAllergies(ProductId, AllergyId) VALUES(3,1)
INSERT INTO ProductsAllergies(ProductId, AllergyId) VALUES(3,2)
INSERT INTO ProductsAllergies(ProductId, AllergyId) VALUES(4,3)
INSERT INTO ProductsAllergies(ProductId, AllergyId) VALUES(4,4)
INSERT INTO ProductsAllergies(ProductId, AllergyId) VALUES(17,2)
INSERT INTO ProductsAllergies(ProductId, AllergyId) VALUES(15,1)
INSERT INTO ProductsAllergies(ProductId, AllergyId) VALUES(16,1)

--הכנסת נתונים לטבלת פרטי הזמנה
INSERT INTO OrderDetails(OrderId, ProductId, Quantity, UnitPriceAtPurchase)VALUES(1,6,1,19.9)
INSERT INTO OrderDetails(OrderId, ProductId, Quantity, UnitPriceAtPurchase)VALUES(1,3,1,30)
INSERT INTO OrderDetails(OrderId, ProductId, Quantity, UnitPriceAtPurchase)VALUES(2,14,2,16.5)
INSERT INTO OrderDetails(OrderId, ProductId, Quantity, UnitPriceAtPurchase)VALUES(3,14,1,16.5)
INSERT INTO OrderDetails(OrderId, ProductId, Quantity, UnitPriceAtPurchase)VALUES(4,15,3,7.5)
INSERT INTO OrderDetails(OrderId, ProductId, Quantity, UnitPriceAtPurchase)VALUES(5,13,1,20)
INSERT INTO OrderDetails(OrderId, ProductId, Quantity, UnitPriceAtPurchase)VALUES(5,14,1,16.5)

--הכנסת נתונים לטבלת לקווחות-אלרגנים
INSERT INTO CustomerAllergyPriority(CustomerId, AllergyId)VALUES(2,4)
INSERT INTO CustomerAllergyPriority(CustomerId, AllergyId)VALUES(6,1)
INSERT INTO CustomerAllergyPriority(CustomerId, AllergyId)VALUES(6,2)





