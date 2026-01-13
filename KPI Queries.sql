SELECT * FROM pizza_sales;
DESCRIBE pizza_sales;
SELECT order_date FROM pizza_sales LIMIT 5;


-- Total Revenue
SELECT SUM(total_price) AS Total_Revenue from pizza_sales;

-- Average order value
SELECT SUM(total_price) / COUNT(DISTINCT order_id) AS Avg_Order_Value from pizza_sales;

-- Total Pizzas Sold
SELECT SUM(quantity) AS Total_pizza_sold FROM pizza_sales

-- Total Orders
SELECT COUNT(DISTINCT order_id) AS Total_orders FROM pizza_sales; 

-- Average Pizzas Per Order
SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) / 
CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2))
AS Avg_Pizzas_per_order
FROM pizza_sales



-- Daily Trend for Total Order
SELECT 
    DAYNAME(STR_TO_DATE(order_date, '%d-%m-%Y')) AS order_day,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY order_day;

-- Hourly Trend for Orders
SELECT 
    HOUR(STR_TO_DATE(order_time, '%H:%i:%s')) AS order_hours,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY order_hours
ORDER BY order_hours;

-- % of Sales by Pizza Category
SELECT pizza_category, SUM(total_price) as Total_Sales, SUM(total_price) * 100 / 
(SELECT SUM(total_price) from pizza_sales WHERE MONTH(STR_TO_DATE(order_date, "%d-%m-%Y"))=1) AS PCT
FROM pizza_sales
WHERE MONTH(STR_TO_DATE(order_date, "%d-%m-%Y"))=1
GROUP BY pizza_category


-- % of Sales by Pizza Size
SELECT 
    pizza_size,
    CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(
        SUM(total_price) * 100 /
        (
            SELECT SUM(total_price)
            FROM pizza_sales
            WHERE QUARTER(STR_TO_DATE(order_date, '%d-%m-%Y')) = 1
        ) 
    AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
WHERE QUARTER(STR_TO_DATE(order_date, '%d-%m-%Y')) = 1
GROUP BY pizza_size
ORDER BY PCT DESC;

-- Total Pizzas Sold by Pizza Category
SELECT pizza_category, SUM(quantity) as Total_Pizzas_Sold
FROM pizza_sales
GROUP BY pizza_category

-- Top 5 Best Sellers by Total Pizzas Sold
SELECT pizza_name, SUM(quantity) AS Total_Pizzas_Sold
FROM pizza_sales
WHERE MONTH(STR_TO_DATE(order_date, "%d-%m-%Y"))=1
GROUP BY pizza_name
ORDER BY sum(quantity) ASC
LIMIT 5;

