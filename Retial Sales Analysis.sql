Create Database Retail_sales;

USE Retail_sales;


drop table sales;
create TABLE sales(
	Transaction_id int not null,
	sale_date date not null,
    sale_time time not null,
	custoemr_id int not  null,
    gender varchar(200) not  null,
    age int null,
    category varchar(200) null,
    quantity int null,
    price_per_unit float null,
    cogs float null,
    total_sales float null) ;
    
 SET GLOBAL local_infile=1;

load data local infile "D:/Projects/MySQL/5- Retail Sales Analysis/SQL - Retail Sales Analysis_utf .csv"
into table sales
FIELDS terminated by ","
enclosed by '"'
lines terminated by "\n"
IGNORE 1 rows;

use retail_sales;

-- checking values of numeric columns
select distinct age from sales
order by 1 asc;

select distinct quantity from sales
order by 1 asc;

select distinct price_per_unit from sales
order by 1 asc;

select distinct cogs from sales
order by 1 asc;

select distinct total_sales from sales
order by 1 asc;


update sales
set
age = nullif(age, 0),
quantity = nullif(age, 0),
price_per_unit = nullif(age, 0),
total_sales = nullif(age, 0),
cogs = nullif(age, 0);

-- find out the null values and delete it 
select
	*
from
	sales
where
	Transaction_id is null
    or custoemr_id is null
    or sale_date is null
    or sale_time is null
    or gender is null
    or age is null
    or category is null
    or quantity is null
    or cogs is null
    or total_sales is null;
    

    
delete from sales
where
	Transaction_id is null
    or custoemr_id is null
    or sale_date is null
    or sale_time is null
    or gender is null
    or age is null
    or category is null
    or quantity is null
    or cogs is null
    or total_sales is null;



-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select
	*
from
	sales
where
	sale_date = "2022-11-05";
    


-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select 
	*
from
	sales
where
	category = "clothing"
    and quantity > 4
    and date_format(sale_date, "%M-%Y") = 'November-2022';


-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.:
select
	category,
    round(sum(total_sales),2) as total_sales
from	
	sales
group by 
	category;


-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
select
	avg(age)
from
	sales
where
	category = "Beauty";
    


-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:

select
	transaction_id,
    total_sales
from
	sales
where
	total_sales > 1000;
    
select * from sales;




-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

select
	category,
    gender,
    count(transaction_id) as count_trans
from
	sales
group by
	category, gender
order by
	1,2 asc;


-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
select
	year,
    month,
    avg_sale
from(
select
	year(sale_date) as year,
	date_format(sale_date, "%M") as month,
    round(avg(total_sales),2) as avg_sale,
    rank() over(PARTITION BY year(sale_date) order by round(avg(total_sales),2 ) desc) as rnk
from 
	sales
group by	
	1,2
order by 
	1,  3 desc) as rank_table
where
	rnk = 1;



-- 8. Write a SQL query to find the top 5 customers based on the highest total sales :

select
	custoemr_id,
    sum(total_sales) as total_sales
from
	sales
group by	
	1
order by 2 desc
limit 5;


-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.:

select
	category,
	count(distinct custoemr_id)
from 
	sales
group by
	category;



-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
with shift_day as(
select
	*,
    case
		when sale_time < "12:00" then "morning"
        when sale_time between "12:01" and "17:00" then "Afternoon"
        else "evening"
        
	end as shift
from
	sales
)
select 
	shift,
	count(*)
from
	shift_day
group by
	shift