# Retail Sales Analysis with MySQL

## Project Overview
This project focuses on analyzing retail sales data using MySQL. The goal is to clean the dataset, ensure its quality, and extract valuable insights that can inform business decisions. The project demonstrates proficiency in SQL operations such as data cleaning, aggregation, and querying to solve real-world retail business problems.

## Objectives
- Set up a MySQL database and import sales data from a CSV file.
- Clean and preprocess the dataset to address data quality issues.
- Perform detailed analysis to uncover key insights about sales trends and customer behavior.

## Key Steps

### 1. Database and Table Setup
- Created a MySQL database named `Retail_sales`.
- Designed the `sales` table structure.
- Loaded data into the `sales` table from a CSV file using the `LOAD DATA LOCAL INFILE` command.

### 2. Data Cleaning and Quality Checks
- Checked distinct values in numeric columns to identify anomalies.
- Replaced zero values in columns like `age`, `quantity`, `price_per_unit`, `cogs`, and `total_sales` with `NULL`.
- Identified rows with `NULL` values and removed them from the dataset to ensure data consistency.

### 3. Analytical Queries
- Analyzed data to extract meaningful insights. Examples include:
  1. Sales trends on specific dates or within specific periods.
  2. Top-performing product categories and customer segments.
  3. Average customer age for particular categories.
  4. Total sales distribution by gender and category.
  5. Identifying the best-selling months for each year.
  6. Shifts (morning, afternoon, evening) and their order distribution.

## Database Schema Creation and Data Loading

### 1. Creating Database & Tables
```sql
CREATE DATABASE Retail_sales;

USE Retail_sales;

-- Drop and create the sales table structure
DROP TABLE IF EXISTS sales;

CREATE TABLE sales(
    Transaction_id INT NOT NULL,
    sale_date DATE NOT NULL,
    sale_time TIME NOT NULL,
    customer_id INT NOT NULL,
    gender VARCHAR(200) NOT NULL,
    age INT NULL,
    category VARCHAR(200) NULL,
    quantity INT NULL,
    price_per_unit FLOAT NULL,
    cogs FLOAT NULL,
    total_sales FLOAT NULL
);
```

### 2. Loading Data into Created Tables
```sql
-- Load data into sales table
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'D:/Projects/MySQL/5- Retail Sales Analysis/SQL - Retail Sales Analysis_utf .csv'
INTO TABLE sales
FIELDS TERMINATED BY ","
ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 ROWS;
```

## Feature Engineering Queries

```sql
-- Update zero values to NULL in selected columns
UPDATE sales
SET
    age = NULLIF(age, 0),
    quantity = NULLIF(quantity, 0),
    price_per_unit = NULLIF(price_per_unit, 0),
    total_sales = NULLIF(total_sales, 0),
    cogs = NULLIF(cogs, 0);

-- Identifying and Removing Null Values
-- These queries identify rows with null values and remove them from the dataset to clean up the data.

-- Find out the null values and delete them
SELECT * 
FROM sales 
WHERE 
    Transaction_id IS NULL 
    OR customer_id IS NULL 
    OR sale_date IS NULL 
    OR sale_time IS NULL 
    OR gender IS NULL 
    OR age IS NULL 
    OR category IS NULL 
    OR quantity IS NULL 
    OR cogs IS NULL 
    OR total_sales IS NULL;

-- Delete rows with null values
DELETE FROM sales
WHERE 
    Transaction_id IS NULL 
    OR customer_id IS NULL 
    OR sale_date IS NULL 
    OR sale_time IS NULL 
    OR gender IS NULL 
    OR age IS NULL 
    OR category IS NULL 
    OR quantity IS NULL 
    OR cogs IS NULL 
    OR total_sales IS NULL;
```

## Some Example Queries

### 1. Create shifts (Morning <12, Afternoon between 12 & 17, Evening >17) and count the number of orders for each shift
```sql
WITH shift_day AS (
    SELECT 
        *,
        CASE
            WHEN sale_time < '12:00' THEN 'morning'
            WHEN sale_time BETWEEN '12:01' AND '17:00' THEN 'Afternoon'
            ELSE 'evening'
        END AS shift
    FROM sales
)
SELECT 
    shift,
    COUNT(*)
FROM shift_day
GROUP BY shift;
```

### 2. Calculate the average sale for each month and find the best-selling month in each year
```sql
SELECT 
    year,
    month,
    avg_sale
FROM (
    SELECT 
        YEAR(sale_date) AS year,
        DATE_FORMAT(sale_date, '%M') AS month,
        ROUND(AVG(total_sales), 2) AS avg_sale,
        RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY ROUND(AVG(total_sales), 2) DESC) AS rnk
    FROM sales
    GROUP BY 1, 2
    ORDER BY 1, 3 DESC
) AS rank_table
WHERE rnk = 1;
```

### 3. Find the total number of transactions made by each gender in each category
```sql
SELECT 
    category,
    gender,
    COUNT(transaction_id) AS count_trans
FROM sales
GROUP BY category, gender
ORDER BY 1, 2 ASC;
```

### 4. Retrieve transactions where category is 'Clothing' and quantity sold is more than 4 in November 2022
```sql
SELECT * 
FROM sales
WHERE category = 'Clothing'
    AND quantity > 4
    AND DATE_FORMAT(sale_date, '%M-%Y') = 'November-2022';
```

--- 

## Insights
- Identified the most and least popular product categories.
- Determined customer demographics contributing the most to sales.
- Highlighted peak sales periods and high-performing sales shifts.

## Tools Used
- MySQL
- CSV for data storage and import.

## Setup Instructions
1. Clone the repository:
   ```bash
   git clone https://github.com/BahaaMedhat1/Retail-Sales-Analysis-with-MySQL.git
   ```
2. Import the provided SQL file (`Retail Sales Analysis.sql`) into your MySQL environment.
3. Ensure the dataset (`SQL - Retail Sales Analysis_utf.csv`) is located in the specified directory for loading.
4. Execute the SQL queries to explore the data and insights.

## Contact
For any inquiries, feel free to reach out:
- **Name**: Bahaa Medhat Wanas
- **Email**: bahaawanas427@gmail.com
- **LinkedIn**: [Bahaa Wanas](https://www.linkedin.com/in/bahaa-wanas-9797b923a)

---
