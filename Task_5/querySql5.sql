
/*
16.Create a PIVOT comparing sales across years:

Rows: Brand names
Columns: Years (2016, 2017, 2018)
Values: Total revenue
Include percentage growth calculations
*/

with yearly_sales as (
    select 
        b.brand_name,
        year(o.order_date) as year,
        sum(oi.quantity * oi.list_price) as revenue
    from [production].[brands] b
    join [production].[products] p on b.brand_id = p.brand_id
    join [sales].[order_items] oi on p.product_id = oi.product_id
    join [sales].[orders] o on oi.order_id = o.order_id
    where year(o.order_date) in (2016, 2017, 2018)
    group by b.brand_name, year(o.order_date)
)
select 
    brand_name,
    [2016],
    [2017],
    [2018],
    case 
        when [2016] = 0 then null 
        else round(([2017] - [2016]) * 100.0 / [2016], 2) 
    end as growth_2016_2017,
    case 
        when [2017] = 0 then null 
        else round(([2018] - [2017]) * 100.0 / [2017], 2) 
    end as growth_2017_2018
from yearly_sales
pivot (
    sum(revenue)
    for year in ([2016], [2017], [2018])
) as pivottable
order by brand_name;




/*
17.Use UNION to combine different product availability statuses:

Query 1: In-stock products (quantity > 0)
Query 2: Out-of-stock products (quantity = 0 or NULL)
Query 3: Discontinued products (not in stocks table)
*/

-- in-stock products
select 
    p.product_id,
    p.product_name,
    'in stock' as availability_status,
    sum(s.quantity) as total_quantity
from [production].[products] p
join [production].[stocks] s on p.product_id = s.product_id
group by p.product_id, p.product_name
having sum(s.quantity) > 0

union

-- out-of-stock products
select 
    p.product_id,
    p.product_name,
    'out of stock' as availability_status,
    0 as total_quantity
from [production].[products] p
join [production].[stocks] s on p.product_id = s.product_id
group by p.product_id, p.product_name
having sum(s.quantity) = 0 or sum(s.quantity) is null

union

-- discontinued products
select 
    p.product_id,
    p.product_name,
    'discontinued' as availability_status,
    null as total_quantity
from [production].[products] p
left join [production].[stocks] s on p.product_id = s.product_id
where s.product_id is null;

/*
18.Use INTERSECT to find loyal customers:

Find customers who bought in both 2017 AND 2018
Show their purchase patterns
*/

select c.customer_id, c.first_name, c.last_name, c.email
from [sales].[customers]  c
join [sales].[orders] o on c.customer_id = o.customer_id
where year(o.order_date) = 2017

intersect

select c.customer_id, c.first_name, c.last_name, c.email
from [sales].[customers] c
join [sales].[orders] o on c.customer_id = o.customer_id
where year(o.order_date) = 2018;

/*
19.Use multiple set operators to analyze product distribution:

INTERSECT: Products available in all 3 stores
EXCEPT: Products available in store 1 but not in store 2
UNION: Combine above results with different labels
*/

-- products available in all 3 stores
select p.product_id, p.product_name, 'available in all stores' as distribution_status
from [production].[products] p
where exists (select 1 from [production].[stocks]  s where s.product_id = p.product_id and s.store_id = 1)
and exists (select 1 from [production].[stocks]  s where s.product_id = p.product_id and s.store_id = 2)
and exists (select 1 from [production].[stocks]  s where s.product_id = p.product_id and s.store_id = 3)

union

-- products available in store 1 but not in store 2
select p.product_id, p.product_name, 'only in store 1' as distribution_status
from [production].[products] p
where exists (select 1 from [production].[stocks]  s where s.product_id = p.product_id and s.store_id = 1)
and not exists (select 1 from [production].[stocks]  s where s.product_id = p.product_id and s.store_id = 2)

union

-- products available in store 2 but not in store 1
select p.product_id, p.product_name, 'only in store 2' as distribution_status
from [production].[products] p
where exists (select 1 from [production].[stocks]  s where s.product_id = p.product_id and s.store_id = 2)
and not exists (select 1 from [production].[stocks]  s where s.product_id = p.product_id and s.store_id = 1);

/*
20.Complex set operations for customer retention:

Find customers who bought in 2016 but not in 2017 (lost customers)
Find customers who bought in 2017 but not in 2016 (new customers)
Find customers who bought in both years (retained customers)
Use UNION ALL to combine all three groups
*/

-- customers who bought in 2016 but not in 2017 (lost customers)
select 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    'lost customer' as customer_status,
    count(distinct o2016.order_id) as orders_2016,
    0 as orders_2017
from [sales].[customers] c
join [sales].[orders] o2016 on c.customer_id = o2016.customer_id and year(o2016.order_date) = 2016
left join [sales].[orders] o2017 on c.customer_id = o2017.customer_id and year(o2017.order_date) = 2017
where o2017.order_id is null
group by c.customer_id, c.first_name, c.last_name

union all

-- customers who bought in 2017 but not in 2016 (new customers)
select 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    'new customer' as customer_status,
    0 as orders_2016,
    count(distinct o2017.order_id) as orders_2017
from [sales].[customers] c
join [sales].[orders] o2017 on c.customer_id = o2017.customer_id and year(o2017.order_date) = 2017
left join [sales].[orders] o2016 on c.customer_id = o2016.customer_id and year(o2016.order_date) = 2016
where o2016.order_id is null
group by c.customer_id, c.first_name, c.last_name

union all

-- customers who bought in both years (retained customers)
select 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    'retained customer' as customer_status,
    count(distinct o2016.order_id) as orders_2016,
    count(distinct o2017.order_id) as orders_2017
from [sales].[customers] c
join [sales].[orders] o2016 on c.customer_id = o2016.customer_id and year(o2016.order_date) = 2016
join [sales].[orders] o2017 on c.customer_id = o2017.customer_id and year(o2017.order_date) = 2017
group by c.customer_id, c.first_name, c.last_name
order by customer_status, last_name, first_name;
