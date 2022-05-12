-- Find total sales for each country
SELECT Customer.COUNTRY, SUM(OrderLineItem.SALES) AS TotalSales
FROM OrderLineItem INNER JOIN Orders ON OrderLineItem.ORDERNUMBER = Orders.ORDERNUMBER
INNER JOIN  Customer ON Orders.CUSTOMERNAME = Customer.CUSTOMERNAME
GROUP BY Customer.COUNTRY;

--Find total sales by year
SELECT Orders.YEAR_ID, SUM(OrderLineItem.SALES) AS TotalSales
FROM OrderLineItem INNER JOIN Orders ON OrderLineItem.ORDERNUMBER = Orders.ORDERNUMBER
GROUP BY Orders.YEAR_ID;

--How much of each product was sold?
SELECT Product.PRODUCTLINE, SUM(OrderLineItem.QUANTITYORDERED) AS TotalProductSold
FROM OrderLineItem INNER JOIN Product ON OrderLineItem.PRODUCTCODE = Product.PRODUCTCODE
GROUP BY Product.PRODUCTLINE;

--Find top 3 customers with the highest sales
SELECT TOP 3 WITH TIES Customer.CUSTOMERNAME AS Company, SUM(OrderLineItem.SALES) AS TotalSales
FROM OrderLineItem INNER JOIN Orders ON OrderLineItem.ORDERNUMBER = Orders.ORDERNUMBER
INNER JOIN  Customer ON Orders.CUSTOMERNAME = Customer.CUSTOMERNAME
GROUP BY Customer.CUSTOMERNAME
ORDER BY TotalSales DESC;

--Find total sales per order 
--Create view to save data
CREATE VIEW Sales AS
SELECT Orders.ORDERNUMBER, Orders.MONTH_ID, Orders.QTR_ID, Orders.YEAR_ID, OrderLineItem.ORDERLINENUMBER, OrderLineItem.QUANTITYORDERED,
OrderLineItem.PRICEEACH, OrderLineItem.SALES, Orders.CUSTOMERNAME,
(SUM(OrderLineItem.SALES) OVER (PARTITION BY Orders.ORDERNUMBER)) AS TotalSalesPerOrder
FROM OrderLineItem INNER JOIN Orders ON OrderLineItem.ORDERNUMBER = Orders.ORDERNUMBER;

-- Find Classic Cars that sold for more than the average price 
SELECT DISTINCT Product.PRODUCTLINE, Product.PRODUCTCODE, PRICEEACH, MSRP
FROM OrderLineItem INNER JOIN Product ON OrderLineItem.PRODUCTCODE = Product.PRODUCTCODE
WHERE PRODUCTLINE = 'Classic Cars' AND PRICEEACH > (SELECT AVG(OrderLineItem.PRICEEACH) AS AvgSalePriceClassicCars
FROM OrderLineItem INNER JOIN Product ON OrderLineItem.PRODUCTCODE = Product.PRODUCTCODE
WHERE PRODUCTLINE = 'Classic Cars')


