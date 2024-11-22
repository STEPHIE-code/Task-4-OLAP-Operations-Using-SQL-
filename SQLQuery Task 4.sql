--Database Creation
Create Database SalesDatabase

--Table creation
CREATE TABLE sales_sample (
    product_id INT,
    region VARCHAR(50),
    date DATE,
    sales_amount NUMERIC
);

--Data Creation
INSERT INTO sales_sample (product_id, region, date, sales_amount)
VALUES
    (1, 'East', '2023-01-01', 1000),
    (2, 'West', '2023-02-15', 1500),
    (3, 'East', '2023-03-20', 800),
    (4, 'West', '2023-04-10', 2000),
    (5, 'South', '2023-05-25', 1200),
    (1, 'East', '2023-06-15', 900),
    (2, 'West', '2023-07-05', 1800),
    (3, 'East', '2023-08-20', 1100),
    (4, 'North', '2023-09-10', 2200),
    (1, 'South', '2023-10-25', 1300);



--a) Drill Down-Analyze sales data at a more detailed level. Write a query to perform drill down 
--from region to product level to understand sales performance.


SELECT region, product_id, SUM(sales_amount) AS total_sales
FROM sales_sample
GROUP BY region, product_id 
ORDER BY total_sales DESC;


--b) Rollup- To summarize sales data at different levels of granularity. Write a query to perform
--roll up from product to region level to view total sales by region.

WITH ProductLevelSales AS (
SELECT Region, Product_Id,SUM(Sales_Amount) AS Total_Sales_Per_Product
FROM sales_sample
GROUP BY Region, Product_Id
)
SELECT Region, SUM(Total_Sales_Per_Product) AS Total_Sales_By_Region
FROM ProductLevelSales
GROUP BY Region
ORDER BY Region DESC;
---------------------------------

--c) Cube - To analyze sales data from multiple dimensions simultaneously. Write a query to
--Explore sales data from different perspectives, such as product, region, and date.

--Detailed level: Groups by region, product_id, and Date
SELECT region, product_id, DATE AS Date, SUM(sales_amount) AS total_sales
FROM sales_sample
GROUP BY region, product_id, DATE 


UNION ALL
--Region and product level: Groups by region and product_id
SELECT region, product_id, NULL AS Date, SUM(sales_amount) AS total_sales
FROM sales_sample
GROUP BY region, product_id

UNION ALL
--Region and Date level: Groups by region and Date
SELECT region, NULL AS product_id, DATE AS Date, SUM(sales_amount) AS total_sales
FROM sales_sample
GROUP BY region, DATE

UNION ALL
--Product and date level: Groups by product_id and Date.
SELECT NULL AS region, product_id, DATE AS Date, SUM(sales_amount) AS total_sales
FROM sales_sample
GROUP BY product_id, DATE

UNION ALL
--Region level: Groups by region.
SELECT region, NULL AS product_id, NULL AS Date, SUM(sales_amount) AS total_sales
FROM sales_sample
GROUP BY region

UNION ALL
--Product level: Groups by product_id.
SELECT NULL AS region, product_id, NULL AS Date, SUM(sales_amount) AS total_sales
FROM sales_sample
GROUP BY product_id

UNION ALL
--Month level: Groups by month.
SELECT NULL AS region, NULL AS product_id, DATE AS Date, SUM(sales_amount) AS total_sales
FROM sales_sample
GROUP BY DATE

UNION ALL
--Overall total: Calculates the total sales without any grouping.
SELECT NULL AS region, NULL AS product_id, NULL AS Date, SUM(sales_amount) AS total_sales
FROM sales_sample;

--d) Slice- To extract a subset of data based on specific criteria. Write a query to slice the data to
--view sales for a particular region or date range.

--Sales for a specific region (e.g., 'East')
SELECT Region, product_id, SUM(sales_amount) AS total_sales
FROM sales_sample
WHERE region = 'East'
GROUP BY region, product_id;

-- Sales for a specific date range (e.g., January to October 2023)
SELECT region, product_id, Date, SUM(sales_amount) AS total_sales
FROM sales_sample
WHERE date BETWEEN '2023-01-01' AND '2023-08-31'
GROUP BY region, product_id, Date
ORDER By Date;

-- Sales for a specific region and date range (e.g., January to October 2023)
SELECT region, product_id, Date, SUM(sales_amount) AS total_sales
FROM sales_sample
WHERE date BETWEEN '2023-01-01' AND '2023-08-31' AND region='East'
GROUP BY region, product_id, Date
ORDER By Date;


--e) Dice - To extract data based on multiple criteria. Write a query to view sales for 
--specific combinations of product,region, and date

-- Sales for a specific region and product (e.g., 'East' & 'West' and product ID 1)

SELECT region, product_id, date, SUM(sales_amount) AS total_sales
FROM sales_sample
WHERE region in ('East','West') AND product_id between 1 and 3
GROUP BY region, product_id, date;