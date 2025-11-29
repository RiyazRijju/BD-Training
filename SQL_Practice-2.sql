create database challenge1;
use challenge1;


CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
  
  show tables;
  
  
  
  -- 1. What is the total amount each customer spent at the restaurant?
  
  Select s.customer_id,sum(price) as amount_spent
  from sales s
  join menu m
  on s.product_id=m.product_id
  group by customer_id;
  
  -- 2. How many days has each customer visited the restaurant?
  select customer_id,count(distinct date(order_date)) as no_of_days_visited
  from sales
  group by customer_id;
  
  
  -- 3. What was the first item from the menu purchased by each customer?
select customer_id,product_name
from( select s.customer_id,m.product_name,
row_number() over (partition by s.customer_id order by s.order_date) as pt
  from menu m
  join sales s
  on s.product_id=m.product_id
) as t 

where pt=1;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT 
    m.product_name,
    COUNT(*) AS total_purchases
FROM sales s
JOIN menu m 
  ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY total_purchases DESC
LIMIT 1;

-- 5. Which item was the most popular for each customer?
select customer_id,product_name,times_purchased
from(
select s.customer_id,m.product_name ,count(*) as times_purchased,
row_number() over (partition by customer_id order by count(*) desc) as pt
from sales s 
join menu m on m.product_id=s.product_id
group by s.customer_id,product_name
) temp
where pt=1;

-- 6. Which item was purchased first by the customer after they became a member?
use challenge1;

select customer_id,product_name,order_date 
from (
select mm.customer_id,s.product_id,s.order_date,
row_number() over(partition by mm.customer_id order by s.order_date) as rn
from sales s
join members mm on s.customer_id=mm.customer_id
where s.order_date>=mm.join_date
) t
join menu m
on m.product_id=t.product_id
where rn=1
order by t.order_date;


-- 7. Which item was purchased just before the customer became a member?
select customer_id,product_name,order_date
from
(
select mm.customer_id,s.product_id,s.order_date,
dense_rank() over(partition by mm.customer_id order by s.order_date desc) as rn
from sales s
join members mm on mm.customer_id=s.customer_id and s.order_date<mm.join_date
) t
join menu m
on m.product_id=t.product_id
where rn=1
order by order_date;

-- 8. What is the total items and amount spent for each member before they became a member?

select mm.customer_id,count(s.product_id) as total_items_bought,sum(m.price) as amount_spent
from members mm
left join sales s on mm.customer_id=s.customer_id and s.order_date<mm.join_date
left join menu m on m.product_id=s.product_id
group by mm.customer_id
order by mm.customer_id;

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

select s.customer_id,sum(m.price) as amount_spent,(sum(case when s.product_id=1 then m.price*20 else m.price* 10 end)) as points_earned
from sales s 
join menu m on m.product_id=s.product_id
group by s.customer_id;


-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
select s.customer_id,sum(m.price) as amount_spent,
sum( case 
	when s.order_date>=mm.join_date and s.order_date<mm.join_date+ interval 7 day  then m.price*20 
    
    else m.price*10 end) as points
from sales s
join members mm
on mm.customer_id=s.customer_id
join menu m
on m.product_id=s.product_id
where s.order_date<='2021-01-31'  and s.customer_id in('A','B')
group by s.customer_id
order by customer_id;

use classicmodels;

#Q1 : Write a query using a CTE to find the top 5 customers who have made the highest total payment amount.

with cte as (

select customerNumber,sum(amount) as Total_amount_spent
from payments 
group by customerNumber

)
select cte.customerNumber,c.customerName,cte.Total_amount_spent
from cte
join customers c on c.customerNumber=cte.customerNumber
order by Total_amount_spent desc
limit 5;

#Q2 : Write a query using a CTE to calculate how many customers each employee (sales rep) manages.

with cte as (
select e.employeeNumber,e.firstName,count(*) as customer_count
from employees e
join customers c on c.salesRepEmployeeNumber=e.employeeNumber
group by e.employeeNumber,e.firstName
)
select cte.firstName,cte.customer_count
from  cte
order by cte.firstName;













  
  

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  