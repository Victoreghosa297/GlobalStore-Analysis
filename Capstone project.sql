select * from [dbo].[Dataset of GlobalSuperstore]

--Capstone Project on GlobalSuperstores

/*What are the three countries that generated the highest total profit for Global Superstore in 2014?
 For each of these three countries, find the three products with the highest total profit.
 Specifically, what are the products’ names and the total profit for each product?
*/

select top(3) Country, sum(profit) as Total_Profit, Product_Name,  DATEPART(YEAR, Order_Date) AS OrderYear
from [dbo].[Dataset of GlobalSuperstore]
where  DATEPART(YEAR, Order_Date) = '2014'
group by Country,  DATEPART(YEAR, Order_Date), Product_Name
order by sum(profit) desc

;WITH CountryProfit AS (
    SELECT Country, SUM(Profit) AS TotalProfit
    FROM [dbo].[Dataset of GlobalSuperstore]
    WHERE Order_Date BETWEEN '2014-01-01' AND '2014-12-31'
    GROUP BY Country
),
TopCountries AS (
    SELECT TOP 3 Country, TotalProfit
    FROM CountryProfit
    ORDER BY TotalProfit DESC
),
ProductProfit AS (
    SELECT 
        Country,
        Product_Name,
        SUM(Profit) AS ProductProfit,
        ROW_NUMBER() OVER (PARTITION BY Country ORDER BY SUM(Profit) DESC) AS rn
    FROM [dbo].[Dataset of GlobalSuperstore]
    WHERE Order_Date BETWEEN '2014-01-01' AND '2014-12-31'
    GROUP BY Country, Product_Name
)
SELECT p.Country, p.Product_Name, p.ProductProfit
FROM ProductProfit p
JOIN TopCountries t ON p.Country = t.Country
WHERE p.rn <= 3
ORDER BY t.TotalProfit DESC, p.Country, p.ProductProfit DESC;

-- Identify the 3 subcategories with the highest average shipping cost in the United States

select * from [dbo].[Dataset of GlobalSuperstore]

select top(3) Sub_Category, avg(Shipping_Cost) as Avg_Shipping_Cost
from [dbo].[Dataset of GlobalSuperstore]
group by sub_category
order by avg(Shipping_Cost) desc

/*  Assess Nigeria’s profitability (i.e., total profit) for 2014. How does it compare to other
 African countries? */

 select country, sum(profit) as total_profit, DATEPART(Year,Order_date) as OrderYear
 from [dbo].[Dataset of GlobalSuperstore]
 where DATEPART(Year,Order_date) = '2014' and country = 'Nigeria'
 group by country, DATEPART(Year,Order_date)

 --
--SELECT country, SUM(profit) AS total_profit
--FROM [dbo].[Dataset of GlobalSuperstore]
--WHERE order_date BETWEEN '2014-01-01' AND '2014-12-31'
--  AND country = 'Nigeria'
--GROUP BY country;

-- What factors might be responsible for Nigeria’s poor performance? You might want to
-- investigate shipping costs and the average discount as potential root causes.

select * from [dbo].[Dataset of GlobalSuperstore]

select country, avg(shipping_cost) as Average_ship_cost, sum(discount) as total_discount, DATEPART(year, order_date) as OrderDAte
from [dbo].[Dataset of GlobalSuperstore]
where country ='Nigeria'
group by country, DATEPART(year, order_date)
order by DATEPART(year, order_date)

/* Identify the product subcategory that is the least profitable in Southeast Asia.
 Note: For this question, assume that Southeast Asia comprises Cambodia,
 Indonesia, Malaysia, Myanmar (Burma), the Philippines, Singapore, Thailand, and
 Vietnam. */

select * from [dbo].[Dataset of GlobalSuperstore]

select country, sub_category, sum(profit) as total_profit, datepart(year, order_date) as orderDate
from [dbo].[Dataset of GlobalSuperstore]
where region in ('Southeast Asia')
group by country, sub_category, DATEPART(year, order_date)
order by DATEPART(year,order_date) desc

/*  Is there a specific country i n Southeast Asia where Global Superstore should stop
 offering the subcategory identified in 4a? */

 select country, sub_category, sum(profit) as total_profit, datepart(year, order_date) as orderDate
from [dbo].[Dataset of GlobalSuperstore]
group by country, sub_category, DATEPART(year, order_date), region
having region = 'Southeast Asia' and sum(profit) < 1 
order by DATEPART(year,order_date) desc, sum(profit) asc

/*  a) Which city is the least profitable (in terms of average profit) in the United States? For
 this analysis, discard the cities with less than 10 Orders */

select * from [dbo].[Dataset of GlobalSuperstore]

select city, avg(profit) as Average_Profit
from [dbo].[Dataset of GlobalSuperstore]
group by city, country, quantity
having country = 'United States' and quantity >=10
order by avg(profit) asc

/*  Which product subcategory has the highest average profit in Australia? */
select * from [dbo].[Dataset of GlobalSuperstore]
where country ='Australia'

select sub_category, avg(profit) as Average_Profit
from [dbo].[Dataset of GlobalSuperstore]
where country = 'Australia'
group by sub_category
order by avg(profit) desc

