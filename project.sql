use BikeSale
-- Total sales of each item at each store
;with total_sales as(
select s.store_id,p.product_id,sum(quantity)SumQty
from sales.orders o
inner join sales.order_items oi on o.order_id=oi.order_id
inner join sales.stores s on o.store_id=s.store_id
inner join production.products p on p.product_id=oi.product_id
group by s.store_id,p.product_id
), sales_period as(
--Sales timeframe for each product
select s.store_id,p.product_id,DATEDIFF(DAY,Min(order_date),MAX(order_date)) days from sales.orders o
inner join sales.order_items oi on o.order_id=oi.order_id
inner join production.products p on p.product_id=oi.product_id
inner join sales.stores s on o.store_id=s.store_id
group by s.store_id,p.product_id
),sales_velocity as(
-- Speed calculation
select ts.store_id,ts.product_id,(cast(SumQty as float)/cast(days+1 as float))daily_velocity 
from total_sales ts
inner join sales_period sp
on ts.product_id=sp.product_id and ts.store_id=sp.store_id
), product_inventory as (-- Product inventory
select s.store_id,p.product_id,sum(quantity) stock_quantity from production.products p
inner join production.stocks s on p.product_id=s.product_id
group by s.store_id,p.product_id
) 
select pr.store_id,pr.product_id,sv.daily_velocity,floor(pr.stock_quantity/sv.daily_velocity)shelf_life_days from product_inventory pr
left join sales_velocity sv on pr.product_id=sv.product_id and pr.store_id=sv.store_id
order by pr.store_id, pr.product_id
