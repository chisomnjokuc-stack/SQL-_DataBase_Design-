SET XACT_ABORT ON

BEGIN TRANSACTION QUICKDBD

CREATE TABLE CalendarDim (
    DayID int  NOT NULL ,
    DateValue date  NOT NULL ,
    Year int  NULL ,
    Quarter int  NULL ,
    Month int  NULL ,
    MonthName varchar(10)  NULL ,
    MonthShort varchar(3)  NULL ,
    Week int  NULL ,
    Day int  NULL ,
    DayName varchar(10)  NULL ,
    DayShort varchar(3)  NULL ,
    IsWeekday bit  NULL ,
    CONSTRAINT PK_CalendarDim PRIMARY KEY CLUSTERED (
        DateValue ASC
    ),
    CONSTRAINT UK_CalendarDim_DayID UNIQUE (
        DayID
    )
)

CREATE TABLE ProductDim (
    ProductID int  NOT NULL ,
    productName varchar(50)  NOT NULL ,
    ProductCategoryID int  NOT NULL ,
    ProductCategory varchar(50)  NOT NULL ,
    ProductCategoryDescription varchar(MAX)  NOT NULL ,
    SupplierID int  NOT NULL ,
    Supplier varchar(50)  NOT NULL ,
    CONSTRAINT PK_ProductDim PRIMARY KEY CLUSTERED (
        ProductID ASC
    )
)

CREATE TABLE Orders (
    OrdersPK int  NOT NULL ,
    OrderID int  NOT NULL ,
    LineItemNumber int  NOT NULL ,
    ProductID int  NOT NULL ,
    CustomerID char(5)  NOT NULL ,
    EmployeeID int  NOT NULL ,
    ShipVia int  NOT NULL ,
    OrderDate date  NOT NULL ,
    DaysUntilRequired int  NOT NULL ,
    DaysToShipped int  NOT NULL ,
    UnitPrice float  NOT NULL ,
    Quantity int  NOT NULL ,
    Discount float  NOT NULL ,
    LineItemTotal float  NOT NULL ,
    CONSTRAINT PK_Orders PRIMARY KEY CLUSTERED (
        OrdersPK ASC
    )
)

CREATE TABLE CustomerDim (
    CustomerID char(5)  NOT NULL ,
    CompanyName varchar(50)  NOT NULL ,
    CustomerName varchar(50)  NOT NULL ,
    ContactTitle varchar(50)  NOT NULL ,
    Address varchar(100)  NOT NULL ,
    City varchar(50)  NOT NULL ,
    Region varchar(50)  NOT NULL ,
    Country varchar(50)  NOT NULL ,
    CONSTRAINT PK_CustomerDim PRIMARY KEY CLUSTERED (
        CustomerID ASC
    )
)

CREATE TABLE EmployeeDim (
    EmployeeID int  NOT NULL ,
    LastName varchar(50)  NOT NULL ,
    FirstName varchar(50)  NOT NULL ,
    Title varchar(50)  NOT NULL ,
    BirthDate DATE  NOT NULL ,
    HireDate DATE  NOT NULL ,
    City varchar(50)  NOT NULL ,
    Region varchar(50)  NOT NULL ,
    Country varchar(50)  NOT NULL ,
    CONSTRAINT PK_EmployeeDim PRIMARY KEY CLUSTERED (
        EmployeeID ASC
    )
)

ALTER TABLE Orders WITH CHECK ADD CONSTRAINT FK_Orders_ProductID FOREIGN KEY(ProductID)
REFERENCES ProductDim (ProductID)

ALTER TABLE Orders CHECK CONSTRAINT FK_Orders_ProductID

ALTER TABLE Orders WITH CHECK ADD CONSTRAINT FK_Orders_CustomerID FOREIGN KEY(CustomerID)
REFERENCES CustomerDim (CustomerID)

ALTER TABLE Orders CHECK CONSTRAINT FK_Orders_CustomerID

ALTER TABLE Orders WITH CHECK ADD CONSTRAINT FK_Orders_EmployeeID FOREIGN KEY(EmployeeID)
REFERENCES EmployeeDim (EmployeeID)

ALTER TABLE Orders CHECK CONSTRAINT FK_Orders_EmployeeID

ALTER TABLE Orders WITH CHECK ADD CONSTRAINT FK_Orders_OrderDate FOREIGN KEY(OrderDate)
REFERENCES CalendarDim (DateValue)

ALTER TABLE Orders CHECK CONSTRAINT FK_Orders_OrderDate

COMMIT TRANSACTION QUICKDBD