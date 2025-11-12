USE Lab1
GO
With OrderFacts (OrdersPK, OrderID, LineItemNumber, ProductID, CustomerID
				,EmployeeID, ShipVia, OrderDate, DaysUntilRequired
				,DaysToShipped, UnitPrice, Quantity, Discount
				,LineItemTotal)
AS
(
SELECT (ord.OrderID * 100000) + ROW_NUMBER() OVER (PARTITION BY od.OrderID ORDER BY od.ProductID)
	  ,od.OrderID
	  ,ROW_NUMBER() OVER (PARTITION BY od.OrderID ORDER BY od.ProductID) AS 'LineItemNumber'
	  ,od.ProductID
	  ,ord.CustomerID
	  ,ord.EmployeeID
	  ,ord.ShipVia
	  ,CAST(ord.OrderDate as DATE) AS OrderDate
	  ,DATEDIFF(day, ord.OrderDate, ord.RequiredDate) AS DaysUntilRequired
	  ,ISNULL(DATEDIFF(day, ord.OrderDate, ord.ShippedDate), -1) AS DaysToShipped
--	  ,ord.Freight
	  ,od.UnitPrice
	  ,od.Quantity
	  ,od.Discount
	  ,(od.UnitPrice * od.Quantity) * (1 - od.Discount) AS LineItemTotal
FROM Northwind_TC.sales.OrderDetails od
	LEFT OUTER JOIN Northwind_TC.sales.Orders ord
ON od.OrderID = ord.OrderID
)
INSERT INTO Lab1.dbo.Orders (OrdersPK, OrderID, LineItemNumber, ProductID, CustomerID
				,EmployeeID, ShipVia, OrderDate, DaysUntilRequired
				,DaysToShipped, UnitPrice, Quantity, Discount
				,LineItemTotal)
SELECT *
FROM OrderFacts

/**** Create for Products and populate into matching table in Lab1 ****/

WITH ProductDim (ProductID, ProductName, ProductCategoryID, ProductCategory
				,ProductCategoryDescription, SupplierID, Supplier)
AS
(
SELECT prod.ProductID
	  ,prod.ProductName
	  ,cat.CategoryID
	  ,cat.CategoryName
	  ,cat.[Description]
	  ,sup.SupplierID
	  ,sup.CompanyName
FROM Northwind_TC.prod.Products prod
	INNER JOIN Northwind_TC.prod.Categories cat
	ON prod.CategoryID = cat.CategoryID
	INNER JOIN Northwind_TC.prod.Suppliers sup
	ON prod.SupplierID = sup.SupplierID
)
INSERT INTO Lab1.dbo.ProductDim(ProductID, ProductName, ProductCategoryID, ProductCategory
				,ProductCategoryDescription, SupplierID, Supplier)
SELECT *
FROM ProductDim

/**** Create for Employee and populate into matching table in Lab1 ****/


WITH EmployeeDim (EmployeeID, LastName, FirstName, Title, BirthDate, HireDate
				,City, Region, Country)
AS
(
SELECT emp.EmployeeID
	  ,emp.LastName
	  ,emp.FirstName
	  ,emp.Title
	  ,emp.BirthDate
	  ,emp.HireDate
	  ,emp.City
	  ,ISNULL(emp.Region, emp.Country)
	  ,emp.Country
FROM Northwind_TC.emp.Employees emp
)
INSERT INTO Lab1.dbo.EmployeeDim(EmployeeID, LastName, FirstName, Title
									,BirthDate, HireDate, City, Region, Country)
SELECT *
FROM EmployeeDim

/**** Create for Customer and populate into matching table in Lab1 ****/


With CustomerDim (CustomerID, CompanyName, CustomerName, ContactTitle, [Address]
				  ,City, Region, Country)
AS
(
SELECT cus.CustomerID
	  ,cus.CompanyName
	  ,cus.ContactName 
	  ,cus.ContactTitle 
	  ,cus.[Address]
	  ,cus.City 
	  ,ISNULL(cus.Region, cus.Country)
	  ,cus.Country 
FROM Northwind_TC.sales.Customers cus
)
INSERT INTO Lab1.dbo.CustomerDim (CustomerID, CompanyName, CustomerName, ContactTitle, [Address]
				  ,City, Region, Country)
SELECT*
FROM CustomerDim
;


