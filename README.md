# SQL Data Warehouse Project

## Project Overview
This project demonstrates the design and implementation of a SQL-based data warehouse
using a layered architecture (Bronze, Silver, Gold) to support analytics and reporting.

The project is based on the tutorial by [https://www.youtube.com/watch?v=2jGhQpbzHes], but fully implemented and adapted
locally using SQL Server.

## Data Model
- Fact table: `fact_sales`
- Dimension tables:
  - `dim_customer`
  - `dim_product`
  - `dim_date`

  ## Example Analytics Queries
- Total sales by customer
- Monthly revenue trends
- Product performance analysis
