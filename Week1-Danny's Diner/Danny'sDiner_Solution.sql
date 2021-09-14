CREATE SCHEMA dannysdinner;
SET search_path = dannydiner;

CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

INSERT INTO sales
  ("customer_id", "order_date", "product_id")
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
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
  
--Tables created for Danny's diner usecase. Below are the questions to find answers for:
/*What is the total amount each customer spent at the restaurant?
How many days has each customer visited the restaurant?
What was the first item from the menu purchased by each customer?
What is the most purchased item on the menu and how many times was it purchased by all customers?
Which item was the most popular for each customer?
Which item was purchased first by the customer after they became a member?
Which item was purchased just before the customer became a member?
What is the total items and amount spent for each member before they became a member?
If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
*/

--What is the total amount each customer spent at the restaurant?
select s.customer_id, s.product_id, sum(price) as total_amount
from sales s
join menu m on s.product_id = m.product_id
group by s.customer_id, s.product_id
order by s.customer_id, s.product_id;

--How many days has each customer visited the restaurant?
select customer_id, count(distinct order_date) from sales 
group by customer_id
Order by customer_id;

--What was the first item from the menu purchased by each customer?
With orderedsales_CTE as(
select s.customer_id, m.product_name, s.order_date,
	dense_rank () over(partition by s.customer_id order by s.order_date ) as rank
from sales s
join menu m on s.product_id = m.product_id 
)

select distinct customer_id, product_name from orderedsales_CTE 
where rank=1
GROUP BY customer_id, product_name;

--What is the most purchased item on the menu and how many times was it purchased by all customers
select count (s.product_id) as times_pdt_purchased, m.product_name from sales s
join menu m on s.product_id = m.product_id
group by s.product_id,m.product_name
order by times_pdt_purchased desc
FETCH FIRST 1 ROWS ONLY;

--Which item was the most popular for each customer?
	
WITH fav_item_cte AS
(
 SELECT s.customer_id, m.product_name, 
  COUNT(m.product_id) AS order_count,
  DENSE_RANK() OVER(PARTITION BY s.customer_id
  ORDER BY COUNT(m.product_id) DESC) AS rank
FROM menu AS m
JOIN sales AS s
 ON m.product_id = s.product_id
GROUP BY s.customer_id, m.product_name
)

SELECT customer_id, product_name, order_count
FROM fav_item_cte 
WHERE rank = 1;


----Which item was purchased first by the customer after they became a member?
with customer_after_member as (
select s.customer_id, s.order_date, s.product_id,mem.join_date,
	dense_rank() over(partition by s.customer_id
					 order by s.order_date) as ranks
	from sales as s
	join members as mem on s.customer_id = mem.customer_id
	where s.order_date >= mem.join_date)
	
select c.customer_id, c.ranks,c.product_id,c.order_date, c.join_date,m.product_name 
from customer_after_member as c
join menu m on m.product_id = c.product_id
where ranks =1
order by c. customer_id;


--Which item was purchased just before the customer became a member?
with customer_b4_member as (
select s.customer_id, s.order_date,s.product_id,mem.join_date,
	dense_rank() over(partition by s.customer_id order by s.order_date desc) as ranked
	from sales as s
	join members as mem
	on s.customer_id = mem.customer_id
	where s.order_date < mem.join_date
)
select c.customer_id, c.ranked,c.product_id,c.order_date, c.join_date,m.product_name 
from customer_b4_member as c
join menu m on m.product_id = c.product_id
where ranked =1
order by c. customer_id;

--What is the total items and amount spent for each member before they became a member?

with totitems_amt as(
select s.customer_id, s.order_date, s.product_id, m.price, mem.join_date,count(order_date) as totitems , 
	dense_rank() over(partition by s.customer_id order by s.order_date desc) as rankorder
	from sales s
	join menu m on s.product_id = m.product_id
	join members mem on s.customer_id = mem.customer_id
	where order_date < join_date
	group by 1,2,3,4,5
)
select t.customer_id, sum(totitems) as tot_items_b4_joindt , sum(price) as amount
from totitems_amt t
group by t.customer_id;

--If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
with pricepoints as(
select *, case when product_id=1 then price*20
	else price*10 end as points
	from menu
	)
	select s.customer_id,sum(pp.points)as totpoints from sales s
	join pricepoints pp on pp.product_id = s.product_id
	group by customer_id;

--In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
WITH dates_cte AS 
(
 SELECT *, 
  DATEADD(DAY, 6, join_date) AS valid_date, 
  EOMONTH('2021-01-31') AS last_date
 FROM members AS m
)

SELECT d.customer_id, s.order_date, d.join_date, d.valid_date, d.last_date, m.product_name, m.price,
   SUM(CASE
      WHEN m.product_name = 'sushi' THEN 2 * 10 * m.price
      WHEN s.order_date BETWEEN d.join_date AND d.valid_date THEN 2 * 10 * m.price
      ELSE 10 * m.price
      END) AS points
FROM dates_cte AS d
JOIN sales AS s
   ON d.customer_id = s.customer_id
JOIN menu AS m
   ON s.product_id = m.product_id
WHERE s.order_date < d.last_date
GROUP BY d.customer_id, s.order_date, d.join_date, d.valid_date, d.last_date, m.product_name, m.price

--B1.Join All The Things - Recreate the table with: customer_id, order_date, product_name, price, member (Y/N)**

SELECT s.customer_id, s.order_date, m.product_name, m.price,
   CASE
      WHEN mm.join_date > s.order_date THEN 'N'
      WHEN mm.join_date <= s.order_date THEN 'Y'
      ELSE 'N'
      END AS member
FROM sales AS s
LEFT JOIN menu AS m
   ON s.product_id = m.product_id
LEFT JOIN members AS mm
   ON s.customer_id = mm.customer_id;

--B2.Rank All The Things - Danny also requires further information about the ranking of customer products,
--but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.**

WITH summary_cte AS 
(
   SELECT s.customer_id, s.order_date, m.product_name, m.price,
      CASE
      WHEN mm.join_date > s.order_date THEN 'N'
      WHEN mm.join_date <= s.order_date THEN 'Y'
      ELSE 'N' END AS member
   FROM sales AS s
   LEFT JOIN menu AS m
      ON s.product_id = m.product_id
   LEFT JOIN members AS mm
      ON s.customer_id = mm.customer_id
)

SELECT *, CASE
   WHEN member = 'N' then NULL
   ELSE
      RANK () OVER(PARTITION BY customer_id, member
      ORDER BY order_date) END AS ranking
FROM summary_cte;
