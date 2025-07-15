/*1.Write a query that classifies all products into price categories:

Products under $300: "Economy"
Products $300-$999: "Standard"
Products $1000-$2499: "Premium"
Products $2500 and above: "Luxury"
*/
select product_name,list_price,
case when list_price <300 then 'Economy'
     when list_price between 300 and 999 then 'Standard'
     when list_price between 1000 and 2499 then 'Premium'
     when list_price > 2500 then 'Luxury'
end as price_category
from production.products

/*
2.Create a query that shows order processing information with user-friendly status descriptions:

Status 1: "Order Received"
Status 2: "In Preparation"
Status 3: "Order Cancelled"
Status 4: "Order Delivered"
Also add a priority level:
Orders with status 1 older than 5 days: "URGENT"
Orders with status 2 older than 3 days: "HIGH"
All other orders: "NORMAL"
*/

select order_id,
case when order_status = 1 then 'Order Received'
     when order_status = 2 then 'In Preparation'
     when order_status = 3 then 'Order Cancelled'
     when order_status = 4 then 'Order Delivered'
end as status_description,
case when order_status =1 and datediff(day,order_date,GETDATE()) >5 then 'URGENT'
     when order_status =2 and datediff(day,order_date,GETDATE()) >3 then 'HIGH'
     else 'NORMAL'
     end as priority_level
from [sales].[orders]

/*
3.Write a query that categorizes staff based on the number of orders they've handled:

0 orders: "New Staff"
1-10 orders: "Junior Staff"
11-25 orders: "Senior Staff"
26+ orders: "Expert Staff"
*/
select 

    s.first_name,
    s.last_name,
    count(o.order_id) as orders_handled,
    case 
        when count(o.order_id) = 0 then 'new staff'
        when count(o.order_id) between 1 and 10 then 'junior staff'
        when count(o.order_id) between 11 and 25 then 'senior staff'
        when count(o.order_id) >= 26 then 'expert staff'
    end as staff_level
from [sales].[staffs] s
left join [sales].[orders]  o on s.staff_id = o.staff_id
group by s.first_name, s.last_name;


/*
4.Create a query that handles missing customer contact information:

Use ISNULL to replace missing phone numbers with "Phone Not Available"
Use COALESCE to create a preferred_contact field (phone first, then email, then "No Contact Method")
Show complete customer information
*/

select 
    customer_id,
    first_name,
    last_name,
    isnull(phone, 'phone not available') as phone,
    email,
    coalesce(phone, email, 'no contact method') as preferred_contact
from [sales].[customers] ;

/*
5.Write a query that safely calculates price per unit in stock:

Use NULLIF to prevent division by zero when quantity is 0
Use ISNULL to show 0 when no stock exists
Include stock status using CASE WHEN
Only show products from store_id = 1
*/

 select 
    p.product_id,
    p.product_name,
    p.list_price,
    isnull(s.quantity, 0) as stock_quantity,
    isnull(p.list_price / nullif(s.quantity, 0), 0) as price_per_unit,
    case 
        when isnull(s.quantity, 0) = 0 then 'out of stock'
        else 'in stock'
    end as stock_status
from [production].[products]  p
 join [production].[stocks] s on p.product_id = s.product_id
where s.store_id = 1 ;

/*
6.Create a query that formats complete addresses safely:

Use COALESCE for each address component
Create a formatted_address field that combines all components
Handle missing ZIP codes gracefully
*/

select 
    customer_id,
    first_name,
    last_name,
    coalesce(street + '/ ', '') + 
    coalesce(city + '/ ', '') + 
    coalesce(state + ' ', '') + 
    coalesce(zip_code, '') as formatted_address
from [sales].[customers];

/*
7.Use a CTE to find customers who have spent more than $1,500 total:

Create a CTE that calculates total spending per customer
Join with customer information
Show customer details and spending
Order by total_spent descending
*/

with customer_spending as (
    select 
        customer_id,
        sum(quantity * list_price) as total_spent
    from [sales].[order_items] oi
    join [sales].[orders] o on oi.order_id = o.order_id
    group by o.customer_id
    having sum(quantity * list_price) > 1500
)
select 
    c.customer_id,
    c.first_name,
    c.last_name,
    cs.total_spent
from [sales].[customers] c
join customer_spending cs on c.customer_id = cs.customer_id
order by cs.total_spent desc;

/*
8.Create a multi-CTE query for category analysis:

CTE 1: Calculate total revenue per category
CTE 2: Calculate average order value per category
Main query: Combine both CTEs
Use CASE to rate performance: >$50000 = "Excellent", >$20000 = "Good", else = "Needs Improvement"
*/

with category_revenue as (
    select 
        c.category_id,
        c.category_name,
        sum(oi.quantity * oi.list_price) as total_revenue
    from [production].[categories] c
    join [production].[products] p on c.category_id = p.category_id
    join [sales].[order_items] oi on p.product_id = oi.product_id
    group by c.category_id, c.category_name
),
category_avg_order as (
    select 
        c.category_id,
        avg(oi.quantity * oi.list_price) as avg_order
    from [production].[categories] c
    join [production].[products] p on c.category_id = p.category_id
    join [sales].[order_items] oi on p.product_id = oi.product_id
    group by c.category_id
)
select 
    cr.category_id,
    cr.category_name,
    cr.total_revenue,
    cao.avg_order,
    case 
        when cr.total_revenue > 50000 then 'excellent'
        when cr.total_revenue > 20000 then 'good'
        else 'needs improvement'
    end as performance_rating
from category_revenue cr
join category_avg_order cao on cr.category_id = cao.category_id;

/*
10.Create a query that ranks products within each category:

Use ROW_NUMBER() to rank by price (highest first)
Use RANK() to handle ties
Use DENSE_RANK() for continuous ranking
Only show top 3 products per category
*/

with ranked_products as (
    select 
        p.product_id,
        p.product_name,
        c.category_name,
        p.list_price,
        row_number() over (order by p.list_price desc) as price_rank_row,
        rank() over (order by p.list_price desc) as price_rank,
        dense_rank() over (order by p.list_price desc) as price_dense_rank
    from [production].[products] p
    join [production].[categories] c on p.category_id = c.category_id
)
select 
    product_id,
    product_name,
    category_name,
    list_price,
    price_rank_row,
    price_rank,
    price_dense_rank
from ranked_products
where price_rank_row <= 3;

/*
11.Rank customers by their total spending:

Calculate total spending per customer
Use RANK() for customer ranking
Use NTILE(5) to divide into 5 spending groups
Use CASE for tiers: 1="VIP", 2="Gold", 3="Silver", 4="Bronze", 5="Standard"
*/

with customer_spending as (
    select 
        c.customer_id,
        c.first_name,
        c.last_name,
        sum(oi.quantity * oi.list_price) as total_spent
    from [sales].[customers] c
    join [sales].[orders] o on c.customer_id = o.customer_id
    join [sales].[order_items] oi on o.order_id = oi.order_id
    group by c.customer_id, c.first_name, c.last_name
)
select 
    customer_id,
    first_name,
    last_name,
    total_spent,
    rank() over (order by total_spent desc) as spending_rank,
    ntile(5) over (order by total_spent desc) as spending_group,
    case ntile(5) over (order by total_spent desc)
        when 1 then 'vip'
        when 2 then 'gold'
        when 3 then 'silver'
        when 4 then 'bronze'
        when 5 then 'standard'
    end as customer_tier
from customer_spending
order by spending_rank;

/*
12.Create a comprehensive store performance ranking:

Rank stores by total revenue
Rank stores by number of orders
Use PERCENT_RANK() to show percentile performance
*/

with store_revenue as (
    select 
        s.store_id,
        s.store_name,
        sum(oi.quantity * oi.list_price) as total_revenue
    from [sales].[stores] s
    join [sales].[orders]  o on s.store_id = o.store_id
    join [sales].[order_items] oi on o.order_id = oi.order_id
    group by s.store_id, s.store_name
),
store_orders as (
    select 
        s.store_id,
        count(o.order_id) as order_count
    from [sales].[stores] s
    join [sales].[orders] o on s.store_id = o.store_id
    group by s.store_id
)
select 
    sr.store_id,
    sr.store_name,
    sr.total_revenue,
    rank() over (order by sr.total_revenue desc) as revenue_rank,
    rank() over (order by so.order_count desc) as order_rank,
    percent_rank() over (order by sr.total_revenue desc) as revenue_percentile
from store_revenue sr
join store_orders so on sr.store_id = so.store_id

/*
13.Create a PIVOT table showing product counts by category and brand:

Rows: Categories
Columns: Top 4 brands (Electra, Haro, Trek, Surly)
Values: Count of products
*/

select *
from (
    select 
        c.category_name,
        b.brand_name,
        p.product_id
    from [production].[products] p
    join [production].[categories] c on p.category_id = c.category_id
    join [production].[brands] b on p.brand_id = b.brand_id
) as count_cat
pivot (
    count(product_id)
    for brand_name in ([electra], [haro], [trek], [surly])
) as pivottable

/*
14.Create a PIVOT showing monthly sales revenue by store:

Rows: Store names
Columns: Months (Jan through Dec)
Values: Total revenue
Add a total column
*/

select *
from (
    select 
        s.store_name,
        format(o.order_date, 'MMM') as month,
        oi.quantity * oi.list_price *(1-oi.discount) as revenue
    from [sales].[stores] s
    join [sales].[orders] o on s.store_id = o.store_id
    join [sales].[order_items] oi on o.order_id = oi.order_id
) as sourcetable
pivot (
    sum(revenue)
    for month in ([jan], [feb], [mar], [apr], [may], [jun], 
                 [jul], [aug], [sep], [oct], [nov], [dec])
) as pivottable
order by store_name;


/*
15.PIVOT order statuses across stores:

Rows: Store names
Columns: Order statuses (Pending, Processing, Completed, Rejected)
Values: Count of orders
*/

select *
from (
    select 
        s.store_name,
        case o.order_status
            when 1 then 'pending'
            when 2 then 'processing'
            when 3 then 'rejected'
            when 4 then 'completed'
        end as order_status,
        o.order_id
    from [sales].[stores] s
    join [sales].[orders] o on s.store_id = o.store_id
) as sourcetable
pivot (
    count(order_id)
    for order_status in ([pending], [processing], [completed], [rejected])
) as pivottable
order by store_name;



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

select c.customer_id, c.first_name, c.last_name
from [sales].[customers]  c
join [sales].[orders] o on c.customer_id = o.customer_id
where year(o.order_date) = 2017

intersect

select c.customer_id, c.first_name, c.last_name
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
where exists(select 1 from [production].[stocks]  s where s.product_id = p.product_id and s.store_id = 1)
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

-- customers who bought in 2017 but not in 2016 
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
