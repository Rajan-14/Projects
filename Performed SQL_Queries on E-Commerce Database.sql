-- SuperStores data set --

CREATE DATABASE Superstores;

-- DROP DATABASE Superstores;
use superstores;

-- 1.	Write a query to display the Customer_Name and Customer Segment using alias name “Customer Name", "Customer Segment" from table Cust_dimen.
select Customer_Name "Customer Name" , Customer_Segment "Customer Segment" from customers;

-- 2.	Write a query to find all the details of the customer from the table cust_dimen order by desc.
select * from customers order by customer_name desc;

-- 3.	Write a query to get the Order ID, Order date from table orders_dimen where ‘Order Priority’ is high
select Order_Id, Order_Date from orders where Order_priority = "High";

-- 4.	Find the total and the average sales (display total_sales and avg_sales)
select sum(Sales) total_sales, avg(sales) avg_sales from market_fact;

-- 5.	Write a query to get the maximum and minimum sales from maket_fact table.
select max(Sales) maximum_sales, min(sales) minimum_sales from market_fact;

-- 6.	Display the number of customers in each region in decreasing order of no_of_customers. The result should contain columns Region, no_of_customers.
select Region, count(Cust_id)  No_of_Customers
from customers
group by Region
order by count(Cust_id) desc;

-- 7.	Find the region having maximum customers (display the region name and max(no_of_customers)
select Region, count(Cust_id)  No_of_Customers
from customers
group by Region
order by count(Cust_id) DESC
LIMIT 1;

/*-- 8.	Find all the customers from Atlantic region who have ever purchased ‘TABLES’ and the number 
of tables purchased (display the customer name, no_of_tables purchased) */
select c.Customer_name, count(m.Prod_id)
from customers c join
     market_fact m
     on m.Cust_id = c.Cust_id join
     products p 
     on p.Prod_id = m.Prod_id 
where c.Region = 'ATLANTIC' and p.Product_Sub_Category = 'TABlES'
group by c.Customer_name;

-- 9. Find all the customers from Ontario province who own Small Business. (display the customer name, no of small business owners)
 select Customer_Name,(COUNT(Customer_Segment)) FROM CUSTOMERS 
where Region = "ONTARIO";

-- 10.	Find the number and id of products sold in decreasing order of products sold (display product id, no_of_products sold)
select Prod_id, sum(Order_Quantity)  no_of_products_sold
from market_fact
group by Prod_id
order by sum(Order_Quantity) DESC;

/*-- 11.	Display product Id and product sub category whose produt category belongs to Furniture and Technlogy. 
The result should contain columns product id, product sub category. */
select Prod_id, Product_Sub_Category from products where Product_Category ="Furniture" and Product_Category="Technology";

-- 12.	Display the product categories in descending order of profits (display the product category wise profits i.e. product_category, profits)?
select p.Product_Category as Product_Category, round(sum(m.Profit), 2) Profits
from market_fact m 
        join products p on m.Prod_id = p.Prod_id
group by p.Product_Category
Order by sum(m.Profit) DESC;

-- 13.	Display the product category, product sub-category and the profit within each subcategory in three columns.
select p.Product_Category Product_Category, p.Product_Sub_Category Product_Sub_Category,
		round(sum(m.Profit), 2) Total_Profits
from market_fact m 
        join products p on m.Prod_id = p.Prod_id
group by p.Product_Sub_Category
Order by p.Product_Category;

-- 14.	Display the order date, order quantity and the sales for the order.
select o.Order_Date, m.Order_Quantity, m.Sales 
from orders o 
join market_fact m on o.Ord_id = m.Ord_id;

/*-- 15.	Display the names of the customers whose name contains the
i)	Second letter as ‘R’
ii)	Fourth letter as ‘D’ */

select Customer_Name from Customers where customer_name like "_R_D%";

-- 16.	Write a SQL query to to make a list with Cust_Id, Sales, Customer Name and their region where sales are between 1000 and 5000.
select c.Customer_Name, c.Cust_id,c. Region, m.Sales 
from customers c
join market_fact m on
c.cust_id = m.cust_id
where m.sales>1000 and m.sales<5000;

-- 17.	Write a SQL query to find the 3rd highest sales.
select Sales, dense_rank() over(order by sales desc) rnk from  market_fact;


/*-- 18.	Where is the least profitable product subcategory shipped the most? For the least profitable product sub-category, 
display the region-wise no_of_shipments and the
 
profit made in each region in decreasing order of profits (i.e. region, no_of_shipments, profit_in_each_region)*/

select c.Region Region,count(m.Ship_id) as No_of_Shipments, 
		round(sum(m.Profit),2) Profit_in_each_region
from market_fact m 
		join customers c on m.Cust_id = c.Cust_id
        join products p on m.Prod_id = p.Prod_id
Where Product_Sub_Category = (
				Select p.Product_Sub_Category 
				from market_fact m 
					join products p on m.Prod_id = p.Prod_id
					group by Product_Sub_Category
					order by sum(m.Profit)
					LIMIT 1) 
group by c.Region
order by sum(m.Profit);

