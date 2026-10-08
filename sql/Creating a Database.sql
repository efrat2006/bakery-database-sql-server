--יצירת מסד נתונים
CREATE DATABASE Bakery;
--יצירת טבלת קטגוריה
CREATE TABLE Categories(
CategoryId INT CONSTRAINT PK_CategoryId PRIMARY KEY IDENTITY(1,1),
CategoryName NVARCHAR(25) NOT NULL
);
--יצירת טבלת אלרגיות
CREATE TABLE Allergies(
AllergyId INT CONSTRAINT PK_AllergyId PRIMARY KEY IDENTITY(1,1),
AllergyName NVARCHAR(25) NOT NULL
); 
--יצירת טבלת מוצרים
CREATE TABLE Products(
ProductId INT CONSTRAINT PK_ProductId PRIMARY KEY IDENTITY(1,1),
ProductName NVARCHAR(25) NOT NULL, 
Price FLOAT CHECK (Price > 0) NOT NULL,
CategoryId INT,
Units INT CHECK (Units > 0) NOT NULL,
CONSTRAINT FK_Products_Categories Foreign key (CategoryId) REFERENCES Categories(CategoryId)
);
--יצירת טבלת מוצרים - אלרגיות
CREATE TABLE ProductsAllergies(
ProductAllergyId INT CONSTRAINT PK_ProductAllergyId PRIMARY KEY IDENTITY(1,1),
ProductId INT NOT NULL, 
AllergyId INT NOT NULL, 
CONSTRAINT FK_ProductsAllergies_Products Foreign key (ProductId) REFERENCES Products(ProductId),
CONSTRAINT FK_ProductsAllergies_Allergies Foreign key (AllergyId) REFERENCES Allergies(AllergyId),
CONSTRAINT UQ_ProductAllergy UNIQUE (ProductId, AllergyId) --האילוץ מוכל על השילוב של הערכים בעמודות ProductId ו-AllergyId
);
--טבלת לקוחות
CREATE TABLE Customers(
CustomerId INT CONSTRAINT PK_CustomerId PRIMARY KEY IDENTITY(1,1),
FirstName NVARCHAR(25) NOT NULL,
LastName NVARCHAR(25) NOT NULL,
ClubMember BIT DEFAULT 0,
Status bit DEFAULT 1
);
--יצירת טבלת הזמנות
CREATE TABLE Orders(
OrderId INT CONSTRAINT PK_OrdersId PRIMARY KEY IDENTITY(1,1),
CustomerId INT NOT NULL, 
OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP, --DEFAULT CURRENT_TIMESTAMP מגדיר שתמיד שיכנס רשומה חדשה מגדירים את התאריך הנוכחי
CustomerComments NVARCHAR(MAX),
CONSTRAINT FK_Orders_Customers Foreign key (CustomerId) REFERENCES Customers(CustomerId)
);
--יצירת טבלת קישור מוצרים - הזמנות
CREATE TABLE OrderDetails(
OrderDetailsId INT CONSTRAINT PK_OrderDetailsId PRIMARY KEY IDENTITY(1,1),
OrderId INT NOT NULL,
ProductId INT NOT NULL,
Quantity INT NOT NULL DEFAULT 1,
CONSTRAINT FK_Orders_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
CONSTRAINT FK_OrderDetails_Orders Foreign key (OrderId) REFERENCES Orders(OrderId)
);
--יצירת טבלת קישור בין לקוחות לארלגיות(ללא האלרגיה) המועדפות
CREATE TABLE CustomerAllergyPriority(
CustomerAllergyPriorityID INT CONSTRAINT PK_CustomerAllergyPriorityId PRIMARY KEY IDENTITY(1,1),
CustomerId INT NOT NULL,
AllergyId INT NOT NULL,
CONSTRAINT FK_CustomerAllergyPriority_Customers FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId),
CONSTRAINT FK_CustomerAllergyPriority_Allergies Foreign key (AllergyId) REFERENCES Allergies(AllergyId),
CONSTRAINT UQ_CustomerAllergy UNIQUE (CustomerId, AllergyId) --האילוץ מוכל על השילוב של הערכים בעמודות CustomerId ו-AllergyId
);
--הוספת שדה "מחיר בעת רכישה "לטבלת קישור פרטי הזמנה
ALTER TABLE OrderDetails
ADD UnitPriceAtPurchase FLOAT NOT NULL
--הוספת השדה סטטוס למוצר
ALTER TABLE Products
ADD Status bit DEFAULT 1
--הוספת אילוץ של UNIQUE 
ALTER TABLE Allergies
ADD CONSTRAINT UQ_Allergies_AllergyName UNIQUE (AllergyName);
--הוספת אילוץ של UNIQUE 
ALTER TABLE Categories
ADD CONSTRAINT UQ_Categories_CategoryName UNIQUE (CategoryName);