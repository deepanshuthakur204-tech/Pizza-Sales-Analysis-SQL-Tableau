create database DATA_ANALYTICS_SALES_PROJECT;
use DATA_ANALYTICS_SALES_PROJECT;
create table Pizza_Sales(
pizza_id int primary key,
order_id int,
pizza_name_id varchar(50),
quantity int,
order_date varchar(10),
order_time time,
unit_price float,
total_price float,
pizza_size VARCHAR(50),
pizza_category varchar(50),
pizza_ingredients varchar(200),
pizza_name VARCHAR(50)
);

alter table Pizza_Sales add column order_date_fixed date;
update Pizza_Sales
set order_date_fixed = str_to_date(order_date,'%d-%m-%Y');
alter table Pizza_Sales drop column order_date;
alter table Pizza_Sales change order_date_fixed order_date date;


SHOW COLUMNS FROM Pizza_Sales;

ALTER TABLE Pizza_Sales ADD COLUMN order_date_fixed DATE;

SET SQL_SAFE_UPDATES = 0;

UPDATE Pizza_Sales
SET order_date_fixed = STR_TO_DATE(order_date, '%d-%m-%Y');

SELECT order_date, order_date_fixed FROM Pizza_Sales LIMIT 5;

ALTER TABLE Pizza_Sales DROP COLUMN order_date;

ALTER TABLE Pizza_Sales CHANGE order_date_fixed order_date DATE;

SHOW COLUMNS FROM Pizza_Sales;

ALTER TABLE Pizza_Sales 
MODIFY order_date DATE AFTER quantity;

show columns from Pizza_Sales;

select * from Pizza_Sales;
-- KPI CREATIONS

-- 1. Total Revenue: The sum of the total price of all pizza orders.
select sum(total_price) as Total_revenue
from Pizza_Sales;
-- rounding up the values
select round(sum(total_price)) as Total_revenue
from Pizza_Sales;
-- 2.Average Order Value: The average amount spent per order,
-- calculated by dividing the total revenue by the total number of orders.
select count(quantity) 
from Pizza_Sales;

select round(sum(total_price)) /  round(count(distinct order_id))as Average_Order_Value
from Pizza_Sales;

select round((sum(total_price)) /  (count(distinct order_id)))as Average_Order_Value
from Pizza_Sales;
-- 3.Total Pizzas Sold: The sum of the quantities of all pizzas sold.
select sum(quantity) as Total_Pizzas_Sold
from Pizza_Sales ;

-- 4.Total Orders: The total number of orders placed.
select count(distinct order_id) as Total_Orders
 from Pizza_Sales;
 
 -- 5.Average Pizzas Per Order: The average number of pizzas sold per order, 
 -- calculated by dividing the total number of pizzas sold by the total number of orders.
 select sum(quantity)/ count(distinct order_id) as Average_Pizzas_Per_Order
from Pizza_Sales;-- this is for number in fractional 

select round(sum(quantity)/ count(distinct order_id)) as Average_Pizzas_Per_Order
from Pizza_Sales;-- for no decimal 

select round(sum(quantity)/ count(distinct order_id),2) as Average_Pizzas_Per_Order
from Pizza_Sales;-- for only 2 decimal


-- 1.Hourly Trend for Total Pizzas Sold:
select extract(hour from order_time)as order_hour,sum(quantity)as Total_pizzas_sold
from Pizza_Sales
group by extract(hour from order_time)
order by extract(hour from order_time) asc;

-- 2.Weekly Trend for Total Orders:
select extract(week from order_date) as week_number,year(order_date)as order_year,
count(distinct order_id)as total_orders
from Pizza_Sales
group by extract(week from order_date),year(order_date)
order by extract(week from order_date),year(order_date)asc;-- not working query


-- MySQL EXTRACT(WEEK FROM date) uses mode 0 by default → weeks start Sunday, 
-- week 1 = the week containing Jan 1.
-- SQL Server DATEPART(ISO_WEEK, date) uses the ISO-8601 rule → weeks start Monday, 
-- week 1 = first week with ≥4 days in the new year.
-- Fix: WEEK(order_date, 3) tells MySQL to use mode 3, 
-- which is the ISO-8601 rule — same logic as ISO_WEEK in SQL Server.
-- Once both queries used the same week-definition, the numbers matched.

-- 2. Weekly Trend for Total Orders

select week(order_date,3) as week_number,
year(order_date)as order_year,
count(distinct order_id) as total_orders
from Pizza_Sales
group by week(order_date,3),year(order_date)
order by  week(order_date,3),year(order_date)asc;

-- 3.Percentage of Sales by Pizza Category:
-- Create a pie chart that shows the distribution of sales across different pizza categories.
-- This chart will provide insights into the popularity of various pizza categories and their contribution to overall sales.
select pizza_category ,sum(total_price) as total_sales ,sum(total_price)*100
/ (select sum(total_price) from Pizza_Sales) as persentage_of_total_sales
from Pizza_Sales 
group by pizza_category;

-- first calculated:- total sales for each category and then multiply it with *100
-- second calculated:- sum of total price
-- final answer is:- Percentage of Sales by Pizza Category


-- if you wan t to see the particular month data
select pizza_category ,sum(total_price) as total_sales ,sum(total_price)*100
/ (select sum(total_price) from Pizza_Sales where month(order_date)=1) as persentage_of_total_sales
from Pizza_Sales 
where month(order_date)=1
group by pizza_category;


-- 4.Percentage of Sales by Pizza Size:
-- Generate a pie chart that represents the percentage of sales attributed to different pizza sizes. 
-- This chart will help us understand customer preferences for pizza sizes and their impact on sales.
select pizza_size ,sum(total_price) as total_sales ,sum(total_price) * 100
/(select sum(total_price) from Pizza_Sales) as persentage_of_total_sales
from Pizza_Sales
group by pizza_size
order by persentage_of_total_sales asc;


-- 5.Total Pizzas Sold by Pizza Category:
-- Create a funnel chart that presents the total number of pizzas sold for each pizza category.
-- This chart will allow us to compare the sales performance of different pizza categories.


-- 6.Top 5 Best Sellers by Revenue, Total Quantity and Total Orders
-- Create a bar chart highlighting the top 5 best-selling pizzas based on the Revenue, 
-- Total Quantity, Total Orders. This chart will help us identify the most popular pizza options.
select pizza_name,sum(total_price) as total_revenue,
count(quantity) as total_quantity,
count(distinct order_id) as total_orders
from Pizza_Sales
group by pizza_name;

select pizza_name,sum(total_price) as total_revenue
from Pizza_Sales
group by pizza_name
order by total_revenue
limit 5;

select pizza_name,sum(quantity) as total_quantity
from Pizza_Sales
group by pizza_name
order by total_quantity desc
limit 5;

select pizza_name,count(distinct order_id) as total_order
from Pizza_Sales
group by pizza_name
order by total_order desc
limit 5;


-- 7. Bottom 5 Best Sellers by Revenue, Total Quantity and Total Orders:-same as privious just use asc instead of desc;
-- Create a bar chart showcasing the bottom 5 worst-selling pizzas based on the Revenue, 
-- Total Quantity, Total Orders. This chart will enable us to identify underperforming or less popular pizza options.