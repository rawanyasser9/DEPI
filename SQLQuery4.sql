--1. Count the total number of products in the database.
select count (product_id) as total_products
from [production].[products]

--2. Find the average, minimum, and maximum price of all products.
select avg (list_price) as Average_price,
       min(list_price) as minimum_price 
      ,max(list_price) as maximum_price 
from [production].[products]

--3. Count how many products are in each category.

select category_name,
       count(product_id) as numOfProducts
from [production].[products] p
join [production].[categories] c on p.category_id=c.category_id
group by category_name

--4. Find the total number of orders for each store.

select s.store_name ,count(order_id) as numOfOrders
from [sales].[orders] o
join [sales].[stores] s on o.store_id=s.store_id
group by s.store_name


--5. Show customer first names in UPPERCASE and last names in lowercase for the first 10 customers.

select top 10 UPPER(first_name), lower(last_name)
from [sales].[customers]

--6. Get the length of each product name. Show product name and its length for the first 10 products.

select top 10 product_name , LEN(product_name) as Name_Lenght
from [production].[products]

--7. Format customer phone numbers to show only the area code (first 3 digits) for customers 1-15.

select top 15 left(phone,3) as AreaCode
from [sales].[customers]

--8. Show the current date and extract the year and month from order dates for orders 1-10.

select top 10  order_id,order_date,
               GETDATE() as today,
               year([order_date]) as yearofOrder ,
               month([order_date]) as monthofOrder
from [sales].[orders]

--9. Join products with their categories. Show product name and category name for first 10 products.

select top 10 p.product_name ,c.category_name
from [production].[products] p
join [production].[categories] c on c.category_id=p.category_id


--10. Join customers with their orders. Show customer name and order date for first 10 orders.

select top 10 c.first_name + ' '+c.last_name as full_name ,o.order_date             
from [sales].[customers] c
join [sales].[orders] o on c.customer_id=o.customer_id

--11. Show all products with their brand names, even if some products don't have brands. 
--Include product name, brand name (show 'No Brand' if null).

select p.product_name, COALESCE(b.brand_name, 'No Brand') AS brandName
from [production].[products] p
left join [production].[brands] b on p.brand_id=b.brand_id

--12. Find products that cost more than the average product price. Show product name and price.

select product_name,list_price
from [production].[products] 
where  list_price > (select avg(list_price) from [production].[products] )

--13. Find customers who have placed at least one order.
--Use a subquery with IN. Show customer_id and customer_name.

select *
from [sales].[customers]
where customer_id in(select customer_id from [sales].[orders] )

--14. For each customer, show their name and total number of orders using a subquery in the SELECT clause.

select c.first_name+' '+c.last_name as full_name ,
       (select count(*) 
       from [sales].[orders] o
       where c.customer_id=o.customer_id
       ) as totalOrders    
from [sales].[customers] c


--15. Create a simple view called easy_product_list that shows product name, category name, and price. 
--Then write a query to select all products from this view where price > 100.

create view 
easy_product_list as 
select  p.product_name, c.category_name, p.list_price
from [production].[products] p
join [production].[categories] c on c.category_id=p.category_id


select * 
from easy_product_list
WHERE list_price > 100;

--16. Create a view called customer_info that shows customer ID, full name (first + last), email, and city and state combined.
--Then use this view to find all customers from California (CA).

create view customer_info as 
select customer_id , first_name+' '+last_name as full_name , email, city ,state
from [sales].[customers]

select *
from customer_info
where state='CA'

--17. Find all products that cost between $50 and $200. 
--Show product name and price, ordered by price from lowest to highest.

select product_name , list_price
from [production].[products]
where list_price between 50 and 200
order by list_price

--18. Count how many customers live in each state. Show state and customer count, ordered by count from highest to lowest.

select state , count(customer_id) as total
from [sales].[customers]
group by state
order  by total DESC

--19. Find the most expensive product in each category. Show category name, product name, and price.
select c.category_name,p.product_name,p.list_price
from [production].[products] p
join [production].[categories] c on p.category_id=c.category_id
where p.list_price=(select max(list_price)
                    from [production].[products] p2
                    where p2.category_id=c.category_id
                   )

--20. Show all stores and their cities, including the total number of orders from each store. 
--Show store name, city, and order count.


select store_name,city ,(select count(*)
                         from [sales].[orders] o
                         where s.store_id = o.store_id
                         ) as numOfOrders
from [sales].[stores] s
ORDER BY 
    s.Store_Name;

