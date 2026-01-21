--Cumulative analysis by date dimensions
--Window funcitons
--Calculating total sales per month and running total of sales over time

select 
order_date, 
total_sales, 
SUM(total_sales) over (order by order_date) as 'running_total_sales',
--if needed to reset the running_total_sales each year add partition by order_date before order by
avg(avg_price) over (order by order_date) as 'moving_average_price' 
from (
select
datetrunc(month, order_date) as 'order_date',
SUM(sales_amount) as 'total_sales',
avg(price) as 'avg_price'
from gold.fact_sales
where order_date IS NOT NULL 
group by datetrunc(month, order_date)
) t;

--performance analysis, current value relative to the target value, or substracted
--with window functions
--analyzing product performance by comparing sales with previous performance

with yearly_product_sales AS (
select 
year(f.order_date) as 'order_year',
p.product_name,
sum(f.sales_amount) as 'current_sales'	
from gold.fact_sales f
JOIN gold.dim_products p ON f.product_key = p.product_key
where f.order_date IS NOT NULL
group by 
year(f.order_date),
p.product_name
)

select order_year,
product_name,
current_sales,
avg(current_sales) over (partition by product_name) avg_sales,
current_sales - avg(current_sales) over (partition by product_name) AS 'diff_avg',
case when current_sales - avg(current_sales) over (partition by product_name) > 0 then 'above avg'
     when current_sales - avg(current_sales) over (partition by product_name) < 0 then 'below avg'
     else 'avg'
end 'avg_change',
lag(current_sales) over (partition by product_name order by order_year) 'py_sales',
current_sales - lag(current_sales) over (partition by product_name order by order_year) as 'diff_py',
case when current_sales - lag(current_sales) over (partition by product_name order by order_year) > 0 then 'increasing'
     when current_sales - lag(current_sales) over (partition by product_name order by order_year) < 0 then 'decreasing'
     else 'no_change'
end 'py_change'
from yearly_product_sales
order by product_name,
order_year;

--proportional analysis, categorical analysis to overal performance

with category_sales AS (
select 
category,
SUM(sales_amount) total_sales
from gold.fact_sales f 
Join gold.dim_products p ON p.product_key = f.product_key
group by category)

select 
category,
total_sales,
SUM(total_sales) over () 'overall_sales',
concat(round((cast(total_sales as float)/ SUM(total_sales) over ())*100, 2), '%') as'%of_total'
--concatting makes the upper part to a string
from category_sales
order by total_sales desc

--segmentation, correlation

with product_segments AS (
select
product_key,
product_name,
cost,
case when cost < 100 then 'below 100'
     when cost between 100 and 500 then '100-500' 
     when cost between 500 and 1000 then '500-1000'
     else 'above 1000'
     end 'cost_range'
from gold.dim_products)

select cost_range,
count(product_key) as 'total_products'
from product_segments
group by cost_range
order by total_products desc;

--grouping cusotmers based on behaviour 

USE DataWarehouseAnalytics;
GO

with customer_spending as (
select 
c.customer_key,
sum(f.sales_amount) as 'total_spending',
min(order_date) as 'first order',
max(order_date) as 'last order',
datediff(month, min(order_date), max(order_date)) as 'lifespan'
from gold.fact_sales f
left join gold.dim_customers c on f.customer_key = c.customer_key
group by c.customer_key
)

select customer_segment,
count(customer_key) AS 'total_customers'
from(
select 
customer_key,
case when lifespan >= 12 and total_spending > 5000 then 'VIP'
     when lifespan >= 12 and total_spending <= 5000 then 'regular'
     else 'new' 
end 'customer_segment' 
from customer_spending) t
group by customer_segment
order by total_customers

--report with customer details, segments, spendings and aggregations

--basic query

USE DataWarehouseAnalytics
GO
create view gold.report_customers as 
WITH base_query AS(
select
    f.order_number,
    f.product_key,
    f.order_date,
    f.sales_amount,
    f.quantity,
    c.customer_key,
    c.customer_number,
concat(c.first_name, ' ', c.last_name) as 'customer_name',
c.birthdate,
DATEDIFF(year, c.birthdate, GETDATE()) as 'customer_age'
from gold.fact_sales f 
join gold.dim_customers c on c.customer_key = f.customer_key
where order_date is not null
)
--aggregation
, customer_aggregation as(
select 
    customer_key,
    customer_number,
    customer_name,
   customer_age,
    count(distinct order_number) as 'total_orders',
    sum(sales_amount) as 'total_sales',
    SUM(quantity) as 'total_quantity',
    count(distinct product_key) as 'total_products',
    max(order_date) as 'last_order_date',
    datediff(month, min(order_date), max(order_date)) as 'lifespan'
from base_query
group by 
    customer_key,
    customer_number,
    customer_name,
    customer_age
)
