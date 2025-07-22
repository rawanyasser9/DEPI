--1.Create a non-clustered index on the email column in the sales.
--customers table to improve search performance when looking up customers by email.

create nonclustered index IX_customers_byemail
on [sales].[customers] (email);

--2.Create a composite index on the production.
--products table that includes category_id and brand_id columns to optimize searches that filter by both category and brand.

create index IX_products_catid_brdid
on [production].[products] ([category_id],[brand_id])

--3.Create an index on sales.orders table for the 
--order_date column and include customer_id, store_id, and order_status as included columns to improve reporting queries.

create index IX_orders
on [sales].[orders] ([order_date],[customer_id],store_id,order_status)
/*4.Create a trigger that automatically inserts a welcome record into a customer_log table whenever a new customer is added to sales.customers. 
(First create the log table, then the trigger)*/

create table sales.customer_log (
    log_id int identity(1,1) primary key,
    customer_id int,
    log_message nvarchar(255),
    log_date datetime default getdate()
);

create trigger trg_add_customer_log
on sales.customers
after insert
as
begin
    insert into sales.customer_log (customer_id, log_message)
    select 
        i.customer_id,
        ' new customer added!'
    from inserted i;
end;


insert into sales.customers (first_name, last_name, phone, email, street, city, state, zip_code)
values ('ali', 'yasser', '01012345678', 'ali@gmail.com', '123 street', 'cairo', 'ca', '11311');

select * from sales.customer_log;


--5.Create a trigger on production.products that logs any changes to the list_price column into a price_history table, storing the old price, new price, and change date.

create table production.price_history (
    history_id int identity(1,1) primary key,
    product_id int,
    old_price decimal(10,2),
    new_price decimal(10,2),
    change_date datetime default getdate()
);

create trigger trg_price_change_log
on production.products
after update
as
begin
    insert into production.price_history (product_id, old_price, new_price)
    select 
        d.product_id,
        d.list_price,
        i.list_price
    from deleted d
    join inserted i on d.product_id = i.product_id
    where d.list_price <> i.list_price;
end;

update production.products
set list_price = list_price + 5
where product_id = 1;

select * from production.price_history;


--6.Create an INSTEAD OF DELETE trigger on production.
--categories that prevents deletion of categories that have associated products. Display an appropriate error message.

create trigger trg_prevent_category_delete
on production.categories
instead of delete
as
begin
    if exists (
        select 1
        from production.products p
        join deleted d on p.category_id = d.category_id
    )
    begin
        print('cannot delete category: it has associated products.');
        rollback;
        return;
    end

    delete from production.categories
    where category_id in (select category_id from deleted);
end;

delete from production.categories where category_id = 3;


--7.Create a trigger on sales.order_items that automatically reduces the quantity in production.stocks when a new order item is inserted.

create trigger trg_reduce_stock_after_order
on sales.order_items
after insert
as
begin
    update s
    set s.quantity = s.quantity - i.quantity
    from production.stocks s
    join inserted i on s.product_id = i.product_id
    where s.store_id = (
        select o.store_id
        from sales.orders o
        where o.order_id = i.order_id
    );
end;


/*8.Create a trigger that logs all new orders into an order_audit table, capturing order details and the date/time when the record was created.


Required Tables for Trigger Questions#
Before starting the trigger questions, create these additional tables:
*/


-- Customer activity log
CREATE TABLE sales.customer__log (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT,
    action VARCHAR(50),
    log_date DATETIME DEFAULT GETDATE()
);

-- Price history tracking
CREATE TABLE production.price__history (
    history_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT,
    old_price DECIMAL(10,2),
    new_price DECIMAL(10,2),
    change_date DATETIME DEFAULT GETDATE(),
    changed_by VARCHAR(100)
);

-- Order audit trail
CREATE TABLE sales.order_audit (
    audit_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT,
    customer_id INT,
    store_id INT,
    staff_id INT,
    order_date DATE,
    audit_timestamp DATETIME DEFAULT GETDATE()
);



create trigger trg_log_new_orders
on sales.orders
after insert
as
begin
    insert into sales.order_audit (order_id, customer_id, store_id, staff_id, order_date)
    select 
        i.order_id,
        i.customer_id,
        i.store_id,
        i.staff_id,
        i.order_date
    from inserted i;
end;


insert into sales.orders (customer_id, order_status, order_date,required_date, store_id, staff_id)
values (3, 1, getdate(),dateadd(day, 5, getdate()), 2, 1);

select * from sales.order_audit;
