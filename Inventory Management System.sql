create database inventory_management_system

use inventory_management_system

create table Customer(
CustomerID varchar(10) primary key,
CustomerName varchar(40),
Email varchar(40),
City  varchar(30),
Subcity  varchar(30),
houseNo  varchar(10)
)

create table Store(
StoreID varchar(10) primary key,
StoreName varchar(40),
City  varchar(30),
Subcity  varchar(30),
Street varchar(30)
)

create table Employee(
EmployeeID varchar(10) primary key,
EmployeeName varchar(40) NOT NULL,
Gender char(1) NOT NULL,
Position varchar(20) NOT NULL,
City  varchar(30) NOT NULL,
Subcity  varchar(30) NOT NULL,
houseNo  varchar(10),
StoreID varchar(10) NOT NULL,
FOREIGN KEY (StoreID) REFERENCES Store(StoreID)
)


create table Product(
ProductId varchar(10) primary key,
ProductName varchar(40) UNIQUE ,
productBrand varchar(25),
productQuantity int, --count
ProductCatagory varchar(25),
ProductExpireDate date NOT NULL,
Unit_price decimal(10,2) NOT NULL
)

create table Supplier(
SupplierId varchar(10) primary key,
SupplierName varchar(40),
SupplierEmail varchar(40),
City  varchar(30),
Subcity  varchar(30),
Street varchar(30)
)

create table Sales (
SalesID varchar(10) primary key,
Quantity int,
PaymentMethod varchar(25),
AmountPaid DECIMAL(10, 2) NOT NULL,
PaymentDate DATETIME NOT NULL,
EmployeeID varchar(10),
CustomerID varchar(10),
FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
)

create table PurchaseOrder(
PurchaseOrderID varchar(10) primary key,
PurchaseDate date,  
QuantityOrdered int,
Unit_price decimal(10,2) NOT NULL,
TotalAmount decimal(10,2) NOT NULL,
EmployeeID varchar(10),
SupplierID varchar(10) NOT NULL,
FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
)

create table StoreProduct(
StoreID VARCHAR(10) NOT NULL,
ProductID VARCHAR(10) NOT NULL,
Quantity INT, ----
PRIMARY KEY (StoreID, ProductID),
FOREIGN KEY (StoreID) REFERENCES Store(StoreID),
FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
) 

CREATE TABLE ProductSupply (
SupplierID VARCHAR(10) NOT NULL, 
ProductID VARCHAR(10) NOT NULL,
SupplyDate DATE,
QuantitySupplied INT, ----
PRIMARY KEY (SupplierID, ProductID),
FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID),
FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
)

CREATE TABLE ProductPurchaseOrder (
PurchaseOrderID VARCHAR(10) NOT NULL,
ProductID VARCHAR(10) NOT NULL,
Quantity INT, ---
PRIMARY KEY (PurchaseOrderID, ProductID),
FOREIGN KEY (PurchaseOrderID) REFERENCES PurchaseOrder(PurchaseOrderID),
FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
)

CREATE TABLE ProductSales (
SalesID VARCHAR(10) NOT NULL,
ProductID VARCHAR(10) NOT NULL,
Quantity INT, ---
PRIMARY KEY (SalesID, ProductID),
FOREIGN KEY (SalesID) REFERENCES Sales(SalesID),
FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
)

CREATE TABLE StoreContact (
StoreID VARCHAR(10) NOT NULL,
Phone_number VARCHAR(15) NOT NULL,
PRIMARY KEY (StoreID),
FOREIGN KEY (StoreID) REFERENCES Store(StoreID)
)

CREATE TABLE EmployeeContact (
EmployeeID VARCHAR(10) NOT NULL,
Phone_number VARCHAR(15) NOT NULL,
PRIMARY KEY (EmployeeID),
FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
)

CREATE TABLE CustomerContact (
CustomerID VARCHAR(10),
Phone_number VARCHAR(15),
PRIMARY KEY (CustomerID),
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
)

CREATE TABLE SupplierContact (
SupplierID VARCHAR(10) NOT NULL,
Phone_number VARCHAR(15) NOT NULL,
PRIMARY KEY (SupplierID),
FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
)

-- Index for enhancing data retrieval

CREATE INDEX IX_Customer_CustomerName 
ON Customer(CustomerName);

CREATE INDEX IX_Product_ProductName 
ON Product(ProductName);

CREATE INDEX IX_Sales_SalesId 
ON Sales(SalesId);

CREATE INDEX IX_PurchaseOrder_PurchaseDate 
ON PurchaseOrder(PurchaseDate);

----VIEWS

CREATE VIEW Cashier_View AS
SELECT Customer.CustomerID, Customer.CustomerName, Sales.SalesID, Sales.Quantity, Sales.AmountPaid, Sales.PaymentMethod, Sales.PaymentDate , Product.ProductName
FROM Customer 
INNER JOIN Sales ON Customer.CustomerID = Sales.CustomerID 
CROSS JOIN Product

CREATE VIEW Manager_View AS
SELECT Employee.EmployeeID, Employee.EmployeeName, Employee.Position, EmployeeContact.Phone_number AS EmployeePhone , Customer.CustomerID, Customer.CustomerName, Product.ProductName, 
Product.Unit_price, Supplier.SupplierName, SupplierContact.Phone_number AS SupplierPhone , Sales.AmountPaid
FROM Sales 
INNER JOIN Employee 
INNER JOIN EmployeeContact ON Employee.EmployeeID = EmployeeContact.EmployeeID 
INNER JOIN Store ON Employee.StoreID = Store.StoreID ON Sales.EmployeeID = Employee.EmployeeID 
INNER JOIN Customer ON Sales.CustomerID = Customer.CustomerID 
CROSS JOIN Product 
CROSS JOIN SupplierContact 
INNER JOIN Supplier ON SupplierContact.SupplierID = Supplier.SupplierId

----Testing (with sample data)

INSERT INTO Customer (CustomerID, CustomerName, Email, City, Subcity, houseNo)
VALUES
('C001', 'Dereje melaku', 'Derejemelaku@gmail.com', 'addis ababa', 'arada', '3124');

INSERT INTO Store (StoreID, StoreName, City, Subcity, Street)
VALUES
('S001', 'Arada Mart', 'addis ababa', 'arada', 'Adwa street');

INSERT INTO Employee (EmployeeID, EmployeeName, Gender, Position, City, Subcity, houseNo, StoreID)
VALUES
('E001', 'Tamrat Zewedu', 'M', 'Cashier', 'addis ababa', 'bole', '1013', 'S001');

INSERT INTO Product (ProductID, ProductName, productBrand, productQuantity, ProductCatagory, ProductExpireDate, Unit_price)
VALUES
('P001', 'lotion', 'nivea', 150, 'skin care', '2026-01-17', 173.00);

INSERT INTO Supplier (SupplierId, SupplierName, SupplierEmail, City, Subcity, Street)
VALUES
('SUP001', 'Belete Haile', 'Beletehaile@gmail.com', 'addis ababa', 'kirkos', 'Gabon street');

INSERT INTO Sales (SalesID, Quantity, PaymentMethod, AmountPaid, PaymentDate, EmployeeID, CustomerID)
VALUES
('SA001', 5, 'Credit Card', 865.00, '2024-02-01 08:15:23', 'E001', 'C001');

INSERT INTO PurchaseOrder (PurchaseOrderID, PurchaseDate, QuantityOrdered, Unit_price, TotalAmount, EmployeeID, SupplierID)
VALUES
('PO001', '2024-01-15', 20, 9.99, 199.80, 'E001', 'SUP001');

INSERT INTO StoreContact (StoreID, Phone_number)
VALUES
('S001', '+251965410283');

INSERT INTO EmployeeContact (EmployeeID, Phone_number)
VALUES
('E001', '+251936252113');

INSERT INTO CustomerContact (CustomerID, Phone_number)
VALUES
('C001', '+251925320132');

INSERT INTO SupplierContact (SupplierID, Phone_number)
VALUES
('SUP001', '+251946383215');

