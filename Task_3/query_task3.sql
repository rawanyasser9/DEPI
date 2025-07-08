--List all products with list price greater than 1000
select *
from production.products
where list_price > 1000
order by list_price ;


--Get customers from "CA" or "NY" states
select *
from [sales].[customers]
where state in('CA','NY');

--Retrieve all orders placed in 2023
select *
from [sales].[orders]
where order_date BETWEEN '2023-01-01' AND '2024-01-01';

--Show customers whose emails end with @gmail.com
select *
from [sales].[customers]
where email LIKE '%@gmail.com';

--Show all inactive staff
select *
from [sales].[staffs]
where active=0;

--List top 5 most expensive products
select top 5 product_name, list_price
from production.products
order by list_price DESC;

--Show latest 10 orders sorted by date
select top 10 *
from [sales].[orders]
order by order_date DESC;

--Retrieve the first 3 customers alphabetically by last name
select top 3 *
from [sales].[customers]
order by last_name ;

--Find customers who did not provide a phone number
select  *
from [sales].[customers]
where phone is null ;

--Show all staff who have a manager assigned
select  *
from [sales].[staffs]
where manager_id is not null ;

--Count number of products in each category
select category_id ,count(*) as numofProducts
from production.products 
group by category_id  ;

--Count number of customers in each state
select state,count(*) as numofCustomers
from [sales].[customers]
group by state;

--Get average list price of products per brand
select brand_id ,avg(list_price) as Avg_Price
from production.products
group by brand_id ;

--Show number of orders per staff
select staff_id,count(order_id) as numofOrders
from [sales].[orders] 
group  by staff_id ;

--Find customers who made more than 2 orders
select customer_id ,count(order_id)as numofOrders
from [sales].[orders]
group by customer_id
having count(order_id) >2;

--Products priced between 500 and 1500
select *
from production.products
where list_price between  500 and 1500 ;

--Customers in cities starting with "S"
select *
from [sales].[customers]
where city LIKE 'S%';

--Orders with order_status either 2 or 4
select *
from [sales].[orders]
where order_status  IN (2, 4);

--Products from category_id IN (1, 2, 3)
SELECT *
FROM production.products
WHERE category_id IN (1, 2, 3);

--Staff working in store_id = 1 OR without phone number
select *
from  [sales].[staffs]
where store_id = 1 OR phone is null;
