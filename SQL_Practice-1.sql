
# 1.Who are the top 5 sales representatives based on revenue generated?


use classicmodels;

select e.employeeNumber,sum(amount) as Total_Revenue_Generated
from 
payments p
left join customers c on p.customerNumber=c.customerNumber
join employees e on c.salesRepEmployeeNumber=e.employeeNumber
group by e.employeeNumber
order by sum(amount) desc
limit 5;

# 2.Which product line generates the most revenue?

Select pl.productLine,sum(od.priceEach*od.quantityOrdered) as RevenueGenerated
from orderdetails od
left join products p on od.productCode=p.productCode
left join productlines pl on p.productLine=pl.productLine
group by pl.productLine
order by RevenueGenerated Desc
Limit 1;

# 3.Are there products that have never been sold?
use classicmodels;
select *
from products p
left join orderdetails o on p.productCode=o.productCode
where o.productCode is Null; 

# 4.How many orders were placed per month in the last year?
select Month(orderDate),count(orderNumber)
from orders
where Year(orderDate)=2005
group by month(orderDate);

# 5.What are the most frequently ordered products?
Select productCode,count(productCode)
from orderdetails
group by productCode
order by count(productCode)desc
limit 10;