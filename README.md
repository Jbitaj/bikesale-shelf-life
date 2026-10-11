# BikeSale SQL Project

This project calculates how many days the current stock of each product will last in each store.

## Tables

* `sales.orders`
* `sales.order_items`
* `production.stocks`

## Tools 

* SQL Server
* SSMS

For each product in each store, the query computes the daily sales velocity (total quantity sold divided by the number of days between the first and last sale, inclusive) and divides the current stock by it, rounding down. Products with stock but no sales return `NULL`. The query is split into CTEs: `total_sales`, `sales_period`, `sales_velocity` and `current_stock`.
