/*1. Customer Spending Analysis#
Write a query that uses variables to find the total amount spent by customer ID 1. 
Display a message showing whether they are a VIP customer (spent > $5000) or regular customer.*/

declare @total int
select @total=(oi.list_price*oi.quantity)
from [sales].[orders] o
join [sales].[order_items] oi on o.order_id=oi.order_id
where customer_id=1

if @total>5000
   print 'VIP customer'
else 
   print 'regular customer'

/*
2. Product Price Threshold Report
Create a query using variables to count how many products cost more than $1500. 
Store the threshold price in a variable and display both the threshold and count in a formatted message.
*/

declare @c int
declare @price int =1500

select @c=count(product_id)
from [production].[products]
where list_price>@price

print 'the num of products cost more than ' + cast(@price as varchar(255)) +' = '+ cast(@c as varchar(255))

/*
3. Staff Performance Calculator
Write a query that calculates the total sales for staff member ID 2 in the year 2017.
Use variables to store the staff ID, year, and calculated total. 
Display the results with appropriate labels.
*/

declare @total_sales decimal(10,2)
declare @year int =2017
declare @id int =2

select @total_sales= SUM(oi.quantity * oi.list_price* (1 - oi.discount))
from [sales].[order_items]oi
join [sales].[orders]o on oi.order_id=o.order_id
where o.staff_id=@id and year(order_date)=@year


print 'staff_id :  ' +cast(@id as varchar(255))+',year : '+ cast(@year as varchar(255)) +', total sales : ' + cast(@total_sales as varchar(255))

/*
4. Global Variables Information#
Create a query that displays the current server name, SQL Server version, 
and the number of rows affected by the last statement.
Use appropriate global variables.
*/

select @@SERVICENAME ,@@VERSION,@@ROWCOUNT

/*5.Write a query that checks the inventory level for product ID 1 in store ID 1. 
Use IF statements to display different messages based on stock levels:#
If quantity > 20: Well stocked
If quantity 10-20: Moderate stock
If quantity < 10: Low stock - reorder needed*/
declare @q int 

select @q=oi.quantity
from [sales].[order_items] oi
join [sales].[orders]o on oi.order_id=o.order_id
where product_id=1 and store_id=1

if @q >20
print 'Well stocked'
else if @q <=20 and @q >=10
print 'Moderate stock'
else if @q < 10
print 'Low stock - reorder needed'



/*6.
Create a WHILE loop that updates low-stock items (quantity < 5) in batches of 3 products at a time. 
Add 10 units to each product and display progress messages after each batch.*/

declare @rows_affected int;

set @rows_affected = 1;

while @rows_affected > 0
begin
    update top (3) production.stocks
    set quantity = quantity + 10
    where quantity < 5;

    set @rows_affected = @@rowcount;

    print concat('batch updated: ', @rows_affected, ' products.');
end

/*
7. Product Price Categorization#
Write a query that categorizes all products using CASE WHEN based on their list price:
Under $300: Budget
$300-$800: Mid-Range
$801-$2000: Premium
Over $2000: Luxury
*/

select product_id,
       case when list_price<300 then 'Budget'
            when list_price between 300 and 801 then 'Mid-Range'
            when list_price between 800 and 2000 then 'Premium'
            when list_price>2000 then 'Luxury'
            end as categories
from [sales].[order_items]

/*
8. Customer Order Validation
Create a query that checks if customer ID 5 exists in the database.
If they exist, show their order count. If not, display an appropriate message.
*/

if exists(
select * from [sales].[customers] c where c.customer_id =5)
begin

select count(o.order_id) as order_count
from [sales].[customers] c
join [sales].[orders] o on o.customer_id=c.customer_id 
where o.customer_id=5
end 
else 
print 'the customer not found'


/*
9. Shipping Cost Calculator Function
Create a scalar function named CalculateShipping that takes an order total as input and returns shipping cost:
Orders over $100: Free shipping ($0)
Orders $50-$99: Reduced shipping ($5.99)
Orders under $50: Standard shipping ($12.99)
*/
create function dbo.CalculateShipping(@order_total int)
returns decimal(10,2)
as
begin
declare @cost decimal(10,2)
if @order_total >=100 
      set @cost =0
else if @order_total between 50 and 100
         set @cost =5.99
else if @order_total <50 
        set @cost =12.99
 return @cost;
end;

select dbo.CalculateShipping (99) as shipping_cost

/*
10. Product Category Function#
Create an inline table-valued function named GetProductsByPriceRange that accepts
minimum and maximum price parameters and returns all products within that price range
with their brand and category information.
*/


CREATE FUNCTION GetProductsByPriceRange (@min int , @max int )

RETURNS TABLE

AS

RETURN

(

    SELECT *
    FROM [production].[products]
    WHERE list_price between @min and @max

);


select * from dbo.GetProductsByPriceRange(10,300)


/*
11. Customer Sales Summary Function
Create a multi-statement function named GetCustomerYearlySummary that takes a customer ID
and returns a table with yearly sales data including total orders, total spent,
and average order value for each year.
*/


create function GetCustomerYearlySummary (@id int)

returns  @summary table (
    year int,
    total_orders int,
    total_spent decimal(18,2),
    avg_order_value decimal(18,2))

as 
begin

 insert into @summary
 select year(order_date) as years,
        count(o.order_id) as total_orders,
        sum(quantity*list_price*(1-discount)) as total_spent,
        AVG(quantity*list_price*(1-discount))as avg_value
    from [sales].[orders] o
    join [sales].[order_items] oi on o.order_id=oi.order_id
    where customer_id=@id
    group by year(order_date)

return 
end

select * from dbo.GetCustomerYearlySummary(10)

/*
12. Discount Calculation Function#
Write a scalar function named CalculateBulkDiscount that determines discount percentage based on quantity:
1-2 items: 0% discount
3-5 items: 5% discount
6-9 items: 10% discount
10+ items: 15% discount*/

create function CalculateBulkDiscount(@quntity int)
returns decimal(5,2)
as
begin 
declare @discount decimal(5,2)

if @quntity in(1,2)
   set @discount=0
else if @quntity between 2 and 6
   set @discount=5
else if @quntity between 5 and 10
   set @discount=10
else if @quntity >=10
   set @discount=15

return @discount
end

select dbo.CalculateBulkDiscount(9) as discount_percentage


/*
13. Customer Order History Procedure
Create a stored procedure named sp_GetCustomerOrderHistory that accepts a customer ID and optional start/end dates. 
Return the customer's order history with order totals calculated.*/
create procedure sp_GetCustomerOrderHistory
      @customer_id int,
      @start_date date,
      @end_date date
as 
begin
select o.order_id , order_date,order_status, sum(quantity*list_price*(1-discount)) as order_totals
from [sales].[orders]o
join [sales].[order_items] oi on o.order_id=oi.order_id
where customer_id=@customer_id and
     order_date>=@start_date and
     order_date <= @end_date
group by o.order_id , order_date,order_status
end

exec sp_GetCustomerOrderHistory  @customer_id=10 ,@start_date ='2022-01-22' , @end_date ='2022-09-19'


/*14. Inventory Restock Procedure
Write a stored procedure named sp_RestockProduct with input parameters for store ID, product ID, and restock quantity. 
Include output parameters for old quantity, new quantity, and success status.*/

create procedure sp_restockproduct
    @store_id int,
    @product_id int,
    @restock_quantity int,
    @old_quantity int output,
    @new_quantity int output,
    @success bit output
as
begin
    -- get the old quantity
    select @old_quantity = quantity
    from production.stocks
    where store_id = @store_id and product_id = @product_id

    -- update the quantity
    update production.stocks 
    set quantity = quantity + @restock_quantity
    where store_id = @store_id and product_id = @product_id

    -- get the new quantity
    select @new_quantity = quantity
    from production.stocks
    where store_id = @store_id and product_id = @product_id

    -- indicate success
    set @success = 1
end


declare @old_qty int, @new_qty int, @status bit;

exec sp_restockproduct 
    @store_id = 1,
    @product_id = 12,
    @restock_quantity = 20,
    @old_quantity = @old_qty output,
    @new_quantity = @new_qty output,
    @success = @status output;

select @old_qty as oldquantity, @new_qty as newquantity, @status as success;


/*15. Order Processing Procedure
Create a stored procedure named sp_ProcessNewOrder that handles complete order creation with proper transaction control and error handling. 
Include parameters for customer ID, product ID, quantity, and store ID.*/
create procedure sp_ProcessNewOrder
@customer_id int, @product_id int ,@quantity int , @store_id int 
as
begin
    declare @order_id int;
    declare @qty int;

        begin transaction;

        select @qty = quantity
        from production.stocks
        where store_id = @store_id and product_id = @product_id;

        if @qty is null
        begin
            print('product not found in stock for this store.');
            rollback;
            return;
        end

        if @qty < @quantity
        begin
            print('not enough stock to fulfill the order.');
            rollback;
            return;
        end

        insert into sales.orders (customer_id, order_date, store_id)
        values (@customer_id, getdate(), @store_id);

        set @order_id = SCOPE_IDENTITY()
        insert into sales.order_items (
            order_id, item_id, product_id, quantity, list_price, discount
        )
        values (
            @order_id,
            1,
            @product_id,
            @quantity,
            (select list_price from production.products where product_id = @product_id),
            0
        );

        update production.stocks
        set quantity = quantity - @quantity
        where store_id = @store_id and product_id = @product_id;

        commit;

end


exec sp_processneworder 
    @customer_id = 1,
    @product_id = 10,
    @quantity = 2,
    @store_id = 1;


/*
16. Dynamic Product Search Procedure
Write a stored procedure named sp_SearchProducts that builds dynamic SQL based on optional parameters: 
product name search term, category ID, minimum price, maximum price, and sort column.
*/
create procedure sp_SearchProducts
       @name varchar(255),
       @cat_id int,
       @min_price int,
       @max_price int 
    as 
    begin 
    select c.category_name,c.category_id,min(p.list_price) as minimum_price,max(p.list_price) as maximam_price
    from [production].[categories] c
    join [production].[products] p on c.category_id=p.category_id
    group by c.category_name,c.category_id
    order by min(p.list_price)
    end 


exec sp_SearchProducts @name= 'Belts' , @cat_id=37,@min_price=100,@max_price=500
/*
17. Staff Bonus Calculation System
Create a complete solution that calculates quarterly bonuses for all staff members. 
Use variables to store date ranges and bonus rates.
Apply different bonus percentages based on sales performance tiers.*/

create procedure sp_calculatequarterlybonuses
    @quarter int,
    @year int
as
begin

    declare 
        @start_date date,
        @end_date date,
        @bonus_low decimal(5,2) = 0.05,
        @bonus_mid decimal(5,2) = 0.07,
        @bonus_high decimal(5,2) = 0.10;
if @quarter = 1
begin
    set @start_date = datefromparts(@year, 1, 1);
    set @end_date = datefromparts(@year, 3, 31);
end
else if @quarter = 2
begin
    set @start_date = datefromparts(@year, 4, 1);
    set @end_date = datefromparts(@year, 6, 30);
end
else if @quarter = 3
begin
    set @start_date = datefromparts(@year, 7, 1);
    set @end_date = datefromparts(@year, 9, 30);
end
else if @quarter = 4
begin
    set @start_date = datefromparts(@year, 10, 1);
    set @end_date = datefromparts(@year, 12, 31);
end
else
begin
    print('invalid quarter. use 14.');
    return;
end

    -- calculate bonuses
       select 
        o.staff_id,
        sum(oi.quantity * oi.list_price * (1 - oi.discount)) as total_sales,
        case
            when sum(oi.quantity * oi.list_price * (1 - oi.discount)) < 10000 
                then sum(oi.quantity * oi.list_price * (1 - oi.discount)) * @bonus_low
            when sum(oi.quantity * oi.list_price * (1 - oi.discount)) between 10000 and 24999 
                then sum(oi.quantity * oi.list_price * (1 - oi.discount)) * @bonus_mid
            when sum(oi.quantity * oi.list_price * (1 - oi.discount)) >= 25000 
                then sum(oi.quantity * oi.list_price * (1 - oi.discount)) * @bonus_high
        end as bonus_amount
    from sales.orders o
    join sales.order_items oi on o.order_id = oi.order_id
    where o.order_date between @start_date and @end_date
    group by o.staff_id
    order by bonus_amount desc;
end;

exec sp_CalculateQuarterlyBonuses @quarter = 2, @year = 2022;


/*
18. Smart Inventory Management#
Write a complex query with nested IF statements that manages inventory restocking. 
Check current stock levels and apply different reorder quantities based on product categories and current stock levels.*/


select 
    p.product_id,
    p.product_name,
    c.category_name,
    s.quantity as current_quantity,

    case 
        when c.category_name = 'Swimwear' then 
            case 
                when s.quantity < 10 then 20
                when s.quantity between 10 and 20 then 10
                else 0
            end

        when c.category_name = 'Formal Wear' then 
            case 
                when s.quantity < 5 then 30
                when s.quantity between 5 and 10 then 15
                else 0
            end

        else 
            case 
                when s.quantity < 8 then 12
                else 0
            end
    end as reorder_quantity

from production.products p
join production.stocks s on p.product_id = s.product_id
join production.categories c on p.category_id = c.category_id
where s.store_id = 1  
order by reorder_quantity desc;


/*
19. Customer Loyalty Tier Assignment#
Create a comprehensive solution that assigns loyalty tiers to customers based on their total spending. 
Handle customers with no orders appropriately and use proper NULL checking.*/

select 
    c.customer_id,
    c.first_name,
    c.last_name,
    
    isnull(sum(oi.quantity * oi.list_price * (1 - oi.discount)), 0) as total_spent,

    case 
        when sum(oi.quantity * oi.list_price * (1 - oi.discount)) >= 10000 then 'platinum'
        when sum(oi.quantity * oi.list_price * (1 - oi.discount)) >= 5000 then 'gold'
        when sum(oi.quantity * oi.list_price * (1 - oi.discount)) >= 1000 then 'silver'
        else 'bronze'
    end as loyalty_tier

from sales.customers c
left join sales.orders o on c.customer_id = o.customer_id
left join sales.order_items oi on o.order_id = oi.order_id

group by c.customer_id, c.first_name, c.last_name
order by total_spent desc;


/*
20. Product Lifecycle Management
Write a stored procedure that handles product discontinuation including checking for pending orders,
optional product replacement in existing orders, clearing inventory, and providing detailed status messages.
*/

create procedure sp_manage_product_discontinuation
    @product_id int,
    @replacement_product_id int = null
as
begin
    -- check for pending orders
    if exists (
        select 1
        from sales.order_items oi
        join sales.orders o on oi.order_id = o.order_id
        where oi.product_id = @product_id and o.order_status = 1
    )
    begin
        if @replacement_product_id is not null
        begin
            update oi
            set product_id = @replacement_product_id
            from sales.order_items oi
            join sales.orders o on oi.order_id = o.order_id
            where oi.product_id = @product_id and o.order_status = 1;

            select 'pending orders found and replaced with new product.' as status;
        end
        else
        begin
            select 'pending orders exist but no replacement was provided.' as status;
        end
    end
    else
    begin
        select 'no pending orders found.' as status;
    end

    update production.stocks
    set quantity = 0
    where product_id = @product_id;

 end;


 exec sp_manage_product_discontinuation @product_id = 100, @replacement_product_id = 200;
