CREATE DATABASE EcommerceDB;

USE EcommerceDB;

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL
);

INSERT INTO Categories (CategoryID, CategoryName)
VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Home Appliances'),
(4, 'Books'),
(5, 'Beauty');


CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    City VARCHAR(50),
    Email VARCHAR(100)
);

INSERT INTO Customers (CustomerID, CustomerName, City, Email)
VALUES
(101, 'Aarav Sharma', 'Pune', 'aarav@gmail.com'),
(102, 'Priya Patil', 'Mumbai', 'priya@gmail.com'),
(103, 'Rohan Verma', 'Delhi', 'rohan@gmail.com'),
(104, 'Sneha Joshi', 'Pune', 'sneha@gmail.com'),
(105, 'Karan Mehta', 'Nashik', 'karan@gmail.com'),
(106, 'Neha Singh', 'Nagpur', 'neha@gmail.com'),
(107, 'Aditya Kulkarni', 'Pune', 'aditya@gmail.com'),
(108, 'Pooja Deshmukh', 'Mumbai', 'pooja@gmail.com'),
(109, 'Rahul Shah', 'Ahmedabad', 'rahul@gmail.com'),
(110, 'Ananya Gupta', 'Delhi', 'ananya@gmail.com');

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

INSERT INTO Products (ProductID, ProductName, Price, CategoryID)
VALUES
(201, 'Laptop', 55000.00, 1),
(202, 'Smartphone', 25000.00, 1),
(203, 'Headphones', 2500.00, 1),
(204, 'T-Shirt', 800.00, 2),
(205, 'Jeans', 1800.00, 2),
(206, 'Mixer Grinder', 3500.00, 3),
(207, 'Microwave Oven', 12000.00, 3),
(208, 'SQL Book', 650.00, 4),
(209, 'Python Book', 750.00, 4),
(210, 'Face Wash', 450.00, 5);


CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Orders (OrderID, CustomerID, OrderDate)
VALUES
(1001, 101, '2026-01-05'),
(1002, 102, '2026-01-10'),
(1003, 103, '2026-01-15'),
(1004, 101, '2026-02-02'),
(1005, 104, '2026-02-10'),
(1006, 105, '2026-02-18'),
(1007, 106, '2026-03-03'),
(1008, 107, '2026-03-12'),
(1009, 108, '2026-03-20'),
(1010, 109, '2026-04-05'),
(1011, 110, '2026-04-15'),
(1012, 103, '2026-04-25'),
(1013, 104, '2026-05-08'),
(1014, 105, '2026-05-18'),
(1015, 107, '2026-06-10');
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity)
VALUES
(1, 1001, 201, 1),
(2, 1001, 203, 2),
(3, 1002, 202, 1),
(4, 1002, 204, 2),
(5, 1003, 205, 1),
(6, 1003, 208, 2),
(7, 1004, 201, 1),
(8, 1005, 206, 1),
(9, 1005, 210, 2),
(10, 1006, 207, 1),
(11, 1006, 209, 2),
(12, 1007, 202, 1),
(13, 1007, 203, 1),
(14, 1008, 204, 3),
(15, 1008, 205, 1),
(16, 1009, 208, 2),
(17, 1010, 201, 1),
(18, 1010, 210, 1),
(19, 1011, 202, 2),
(20, 1012, 206, 1),
(21, 1012, 208, 1),
(22, 1013, 209, 2),
(23, 1014, 207, 1),
(24, 1014, 210, 2),
(25, 1015, 203, 2);
SHOW TABLES;
SELECT * FROM Categories;
SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM OrderDetails;

USE EcommerceDB;

-- =====================================================
-- E-COMMERCE SALES ANALYSIS PROJECT
-- Database: EcommerceDB
-- Tool: MySQL
-- =====================================================


-- Query 1: Calculate Total Sales
SELECT 
    SUM(p.Price * od.Quantity) AS Total_Sales
FROM Products p
JOIN OrderDetails od
    ON p.ProductID = od.ProductID;


-- Query 2: Product-wise Sales Analysis
SELECT 
    p.ProductName,
    SUM(od.Quantity) AS Total_Quantity,
    SUM(p.Price * od.Quantity) AS Total_Sales
FROM Products p
JOIN OrderDetails od
    ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY Total_Sales DESC;


-- Query 3: Find Top 5 Best-Selling Products
SELECT 
    p.ProductName,
    SUM(od.Quantity) AS Total_Quantity,
    SUM(p.Price * od.Quantity) AS Total_Sales
FROM Products p
JOIN OrderDetails od
    ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY Total_Sales DESC
LIMIT 5;


-- Query 4: Category-wise Sales Analysis
SELECT 
    c.CategoryName,
    SUM(od.Quantity) AS Total_Quantity,
    SUM(p.Price * od.Quantity) AS Total_Sales
FROM Categories c
JOIN Products p
    ON c.CategoryID = p.CategoryID
JOIN OrderDetails od
    ON p.ProductID = od.ProductID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY Total_Sales DESC;


-- Query 5: Customer-wise Purchase Analysis
SELECT 
    c.CustomerName,
    COUNT(DISTINCT o.OrderID) AS Total_Orders,
    SUM(p.Price * od.Quantity) AS Total_Spent
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
JOIN OrderDetails od
    ON o.OrderID = od.OrderID
JOIN Products p
    ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY Total_Spent DESC;


-- Query 6: Monthly Sales Analysis

SELECT 
    MONTH(o.OrderDate) AS Month_Number,
    MONTHNAME(o.OrderDate) AS Month_Name,
    SUM(p.Price * od.Quantity) AS Monthly_Sales
FROM Orders o
JOIN OrderDetails od
    ON o.OrderID = od.OrderID
JOIN Products p
    ON od.ProductID = p.ProductID
GROUP BY MONTH(o.OrderDate), MONTHNAME(o.OrderDate)
ORDER BY Month_Number;


-- Query 7: Find the Highest-Spending Customer

SELECT 
    c.CustomerName,
    SUM(p.Price * od.Quantity) AS Total_Spent
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
JOIN OrderDetails od
    ON o.OrderID = od.OrderID
JOIN Products p
    ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY Total_Spent DESC
LIMIT 1;    


-- Query 8: Calculate Average Order Value

SELECT 
    AVG(Order_Total) AS Average_Order_Value
FROM (
    SELECT 
        o.OrderID,
        SUM(p.Price * od.Quantity) AS Order_Total
    FROM Orders o
    JOIN OrderDetails od
        ON o.OrderID = od.OrderID
    JOIN Products p
        ON od.ProductID = p.ProductID
    GROUP BY o.OrderID
) AS Order_Summary;


-- Query 9: Find Products with Sales Above Average Product Sales

SELECT 
    p.ProductName,
    SUM(p.Price * od.Quantity) AS Total_Sales
FROM Products p
JOIN OrderDetails od
    ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
HAVING SUM(p.Price * od.Quantity) >
(
    SELECT AVG(Product_Sales)
    FROM (
        SELECT 
            SUM(p2.Price * od2.Quantity) AS Product_Sales
        FROM Products p2
        JOIN OrderDetails od2
            ON p2.ProductID = od2.ProductID
        GROUP BY p2.ProductID
    ) AS Sales_Data
)
ORDER BY Total_Sales DESC;


-- Query 10: Find the Category with the Highest Sales

SELECT 
    c.CategoryName,
    SUM(p.Price * od.Quantity) AS Total_Sales
FROM Categories c
JOIN Products p
    ON c.CategoryID = p.CategoryID
JOIN OrderDetails od
    ON p.ProductID = od.ProductID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY Total_Sales DESC
LIMIT 1;
    
    
    -- Query 11: Find Customers Who Placed More Than One Order

SELECT 
    c.CustomerName,
    COUNT(o.OrderID) AS Total_Orders
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(o.OrderID) > 1
ORDER BY Total_Orders DESC;


-- Query 12: Customer Segmentation using CASE

SELECT 
    c.CustomerName,
    SUM(p.Price * od.Quantity) AS Total_Spent,
    CASE
        WHEN SUM(p.Price * od.Quantity) >= 50000 THEN 'High Value'
        WHEN SUM(p.Price * od.Quantity) >= 20000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Customer_Segment
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
JOIN OrderDetails od
    ON o.OrderID = od.OrderID
JOIN Products p
    ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY Total_Spent DESC;


-- Query 13: Find Products with Price Above Average

SELECT 
    ProductName,
    Price
FROM Products
WHERE Price > (
    SELECT AVG(Price)
    FROM Products
)
ORDER BY Price DESC;


-- Query 14: Monthly Sales Analysis using CTE

WITH MonthlySales AS (
    SELECT 
        MONTH(o.OrderDate) AS Month_Number,
        MONTHNAME(o.OrderDate) AS Month_Name,
        SUM(p.Price * od.Quantity) AS Monthly_Sales
    FROM Orders o
    JOIN OrderDetails od
        ON o.OrderID = od.OrderID
    JOIN Products p
        ON od.ProductID = p.ProductID
    GROUP BY MONTH(o.OrderDate), MONTHNAME(o.OrderDate)
)

SELECT *
FROM MonthlySales
ORDER BY Month_Number;


-- Query 15: Compare Current Month Sales with Previous Month using LAG()

WITH MonthlySales AS (
    SELECT 
        MONTH(o.OrderDate) AS Month_Number,
        MONTHNAME(o.OrderDate) AS Month_Name,
        SUM(p.Price * od.Quantity) AS Monthly_Sales
    FROM Orders o
    JOIN OrderDetails od
        ON o.OrderID = od.OrderID
    JOIN Products p
        ON od.ProductID = p.ProductID
    GROUP BY MONTH(o.OrderDate), MONTHNAME(o.OrderDate)
)

SELECT 
    Month_Name,
    Monthly_Sales,
    LAG(Monthly_Sales) OVER (
        ORDER BY Month_Number
    ) AS Previous_Month_Sales
FROM MonthlySales
ORDER BY Month_Number;


-- Query 16: Compare Current Month Sales with Next Month using LEAD()

WITH MonthlySales AS (
    SELECT 
        MONTH(o.OrderDate) AS Month_Number,
        MONTHNAME(o.OrderDate) AS Month_Name,
        SUM(p.Price * od.Quantity) AS Monthly_Sales
    FROM Orders o
    JOIN OrderDetails od
        ON o.OrderID = od.OrderID
    JOIN Products p
        ON od.ProductID = p.ProductID
    GROUP BY MONTH(o.OrderDate), MONTHNAME(o.OrderDate)
)

SELECT 
    Month_Name,
    Monthly_Sales,
    LEAD(Monthly_Sales) OVER (
        ORDER BY Month_Number
    ) AS Next_Month_Sales
FROM MonthlySales
ORDER BY Month_Number;


