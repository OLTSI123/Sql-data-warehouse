    --final results

select
    customer_key,
    customer_number,
    customer_name,
    customer_age,
    case when customer_age < 20 then 'under 20'
        when customer_age between 20 and 29 then '20-29'
        when customer_age between 30 and 39 then '20-29'
        when customer_age between 40 and 49 then '20-29'
        else '50 and above'
    end as 'age_group',
    case when lifespan >= 12 and total_sales > 5000 then 'VIP'
         when lifespan >= 12 and total_sales <= 5000 then 'regular'
         else 'new' 
         end as 'customer_segment',
         last_order_date,
         datediff(month, last_order_date, getdate()) as 'recency',
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan,
    --average order value AVO
    --order value could be 0 so do case
    case when total_orders = 0 then 0
         else total_sales / total_sales 
         end as 'avg_order_value',
    --average monthly spent
    case when lifespan = 0 then total_sales 
    else total_sales / lifespan 
    end as 'avg_monthly_spend'
    from customer_aggregation 

    USE DataWarehouseAnalytics;
GO

    select
    customer_segment,
    count(customer_number) as 'total_customers',
    sum(total_sales) total_sales
    from gold.report_customers
    group by customer_segment
