
# Case Study #1 - Danny's Diner
<img src="https://user-images.githubusercontent.com/11831222/133180078-9e953a32-ebd1-4e7b-9cf5-3f899b63216e.png" alt="drawing" style="width:300px;"/>

View SQL Syntax [here](https://github.com/thanujapolani/8-Week-SQL-Challenge/blob/main/Week1-Danny's%20Diner/Danny'sDiner_Solution.sql).

__________________________________________________________________________________________________________________________________________________________________

**1. What is the total amount each customer spent at the restaurant?**

``` SQL 
select s.customer_id, s.product_id, sum(price) as total_amount
from sales s
join menu m on s.product_id = m.product_id
group by s.customer_id, s.product_id
order by s.customer_id, s.product_id;

```
**Steps:**
- Use SUM and GROUP BY to find out `total_amount` contributed by each customer.
- Use JOIN to merge `sales` and `menu` tables as `customer_id` and `price` are from both tables.

**Answer:**
|customer_id |total_amount |
|---|---|
|A |76 |
|B |74 |
|C |36 |

- Customer **A** spent **$76**.

- Customer **B** spent **$74**.

- Customer **C** spent **$36**.
__________________________________________________________________________________________________________________________________________________________________

**2. How many days has each customer visited the restaurant?**
```SQL

select customer_id, count(distinct order_date) as visit_ct from sales 
group by customer_id
Order by customer_id;

```

**Steps:**
- Use DISTINCT and wrap with COUNT to find out the `visit_ct` for each customer.
- If we do not use DISTINCT on `order_date`, the number of days may be repeated. For example, if Customer A visited the restaurant twice on '2021–01–07', then number of days is counted as 2 days instead of 1 day.

**Answer:**
|customer_id	|visit_ct |
|---|---|
|A |4 |
|B |6 |
|C |2 |

- Customer **A** visited **4** times.

- Customer **B** visited **6** times.

- Customer **C** visited **2** times.

__________________________________________________________________________________________________________________________________________________

**3. What was the first item from the menu purchased by each customer?**
```SQL

With orderedsales_CTE as(
select s.customer_id, m.product_name, s.order_date,
	dense_rank () over(partition by s.customer_id order by order_date ) as rank
from sales s
join menu m on s.product_id = m.product_id 
)

select distinct customer_id,order_date, product_name from orderedsales_CTE 
where rank=1
GROUP BY customer_id, product_name;

```

**Steps:**
- Create a temp table `order_sales_cte` and use **DENSE_RANK()** function to create a new column `rank` based on `order_date`.
- Instead of `ROW_NUMBER` or `RANK`, use `DENSE_RANK` as `order_date` is not time-stamped hence, there is no sequence as to which item is ordered first if 2 or more items are ordered on the same day.
- Subsequently, **GROUP BY** all columns to show `rank` = 1 only.

**Answer:**
|customer_id |product_name|
|---|---|
|A |curry |
|A |sushi |
|B |curry |
|C |ramen |

- Customer **A**'s first orders are **curry and sushi**.
- Customer **B**'s first order is **curry**.
- Customer **C**'s first order is **ramen**.
_____________________________________________________________________________________________________________________________________________________________________

**4. What is the most purchased item on the menu and how many times was it purchased by all customers?**
```SQL
select count (s.product_id) as times_pdt_purchased, m.product_name from sales s
join menu m on s.product_id = m.product_id
group by s.product_id,m.product_name
order by times_pdt_purchased desc
FETCH FIRST 1 ROWS ONLY;

```
**Steps:**
- **COUNT** number of `product_id`'s and **ORDER BY** most_purchased by descending order.
- Then, use **Fetch First 1 rows only** to filter highest number of purchased item.

**Answer:**
|times_pdt_purchased	|product_name |
|---|---|
|8	|ramen|

- Most purchased item on the menu is **ramen** which is **8** times.
______________________________________________________________________________________________________________________________________

**5. Which item was the most popular for each customer?**
```SQL 
WITH fav_item_cte AS
(
   SELECT s.customer_id, m.product_name, COUNT(m.product_id) AS order_count,
      DENSE_RANK() OVER(PARTITION BY s.customer_id
      ORDER BY COUNT(s.customer_id) DESC) AS rank
   FROM dbo.menu AS m
   JOIN dbo.sales AS s
      ON m.product_id = s.product_id
   GROUP BY s.customer_id, m.product_name
)

SELECT customer_id, product_name, order_count
FROM fav_item_cte 
WHERE rank = 1;
```

**Steps:**
- Create a `fav_item_cte` and use **DENSE_RANK** to rank the `order_count` for each product by descending order for each customer.
- Generate results where **product rank = 1** only as the most popular product for each customer.

**Answer:**
|customer_id	|product_name	|order_count|
|---|---|---|
|A	|ramen	|3|
|B	|sushi	|2|
|B	|curry	|2|
|B	|ramen	|2|
|C	|ramen	|3|

- Customer **A and C's** favourite item is **ramen.**
- Customer **B** enjoys all items on the menu. 

______________________________________________________________________________________________________________________________________________________


**6. Which item was purchased first by the customer after they became a member?**
``` SQL
Wwith customer_after_member as (
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
```

**Steps:**
- Create `customer_after_member` CTE and partition the `customer_id` by ascending order_date. Then, apply a filter condition for `order_date` to be on or after `join_date`.
- Next, filter table by `rank` = 1 to show 1st item purchased by each customer.

**Answer:**
|customer_id	|ranks |product_id |order_date	|join_date |product_name|
|---|---|---|---|---|---|
|A	|1 |2 |2021-01-07	|2021-01-07 |curry
|B	|1 |2 |2021-01-11	|2021-01-09 |sushi

- Customer **A**'s first order as member is **curry**.
- Customer **B**'s first order as member is **sushi**.

______________________________________________________________________________________________________________________________________________________________


**7. Which item was purchased just before the customer became a member?**
``` SQL

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
```

**Steps:**
- Create a **customer_b4_member** and create new column `ranked`and partition `customer_id` by descending `order_date` to find out the last `order_date` before customer becomes a member.
- Filter `order_date` to preceed `join_date`.

**Answer:**
|customer_id	|ranked |Product_id |order_date	|join_date |product_name|
|---|---|---|---|---|---|
|A |1 |1 |2021-01-01 |2021-01-07 |sushi |
|A |1 |2 |2021-01-01 |2021-01-07 |curry |
|B |1 |1 |2021-01-04 |2021-01-09 |sushi |

- Customer **A**’s last order before becoming a member is **sushi and curry**.
- Whereas for Customer **B**, it's **sushi**.

________________________________________________________________________________________________________________________________________________

**8. What is the total items and amount spent for each member before they became a member?**
``` SQL

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
```

**Steps:**
- Filter `order_date` before `join_date` and perform a **COUNT DISTINCT** on `product_id` and **SUM** the `Price` spent before becoming member.

**Answer:**
|customer_id	|tot_items_b4_joindt	|amount
|---|---|---|
|A	|2	|25
|B	|3	|40

Before becoming members,

  - Customer **A** spent **$25 on 2 items**.
  - Customer **B** spent **$40 on 2 items**.

____________________________________________________________________________________________________________________________________________________________

**9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier — how many points would each customer have?**
``` SQL
WITH price_points AS
(
   SELECT *, 
      CASE
         WHEN product_id = 1 THEN price * 20
         ELSE price * 10
      END AS points
   FROM menu
)

SELECT s.customer_id, SUM(p.points) AS total_points
FROM price_points_cte AS p
JOIN sales AS s
   ON p.product_id = s.product_id
GROUP BY s.customer_id

```

**Steps:**
- Each $1 spent = 10 points.
- But, sushi (`product_id` = 1) gets 2x points, meaning each $1 spent = 20 points So, we use **CASE WHEN** to create conditional statements
- If `product_id` = 1, then every $1 `price` multiply by 20 points
- All other `product_id` that is not 1, multiply $1 by 10 points 
- Using` price_points`, **SUM** the points.

**Answer:**
|customer_id	|totpoints |
|---|---|
|A	|860 |
|B	|940 |
|C	|360 |

- Total points for Customer **A** is **860.**
- Total points for Customer **B** is **940.**
- Total points for Customer **C** is **360.**

_______________________________________________________________________________________________________________________________________________________________

**10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi — how many points do customer A and B have at the end of January?**
``` SQL

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

```

**Steps:**
- In **dates_cte**, find out customer’s `valid_date` (which is 6 days after `join_date` and inclusive of ``join_date) and last_day of Jan 2021 (which is ‘2021–01–31’).
- Assumptions are:
  - On Day -X to Day 1 (customer becomes member on Day 1 join_date), each $1 spent is 10 points and for sushi, each $1 spent is 20 points.
  - On Day 1 `join_date` to Day 7 `valid_date`, each $1 spent for all items is 20 points.
  - On Day 8 to last_day of Jan 2021, each $1 spent is 10 points and sushi is 2x points.

**Answer:**
|customer_id	|total_points |
|---|---|
|A	|1370 |
|B	|820 |

- Total points for Customer **A** is **1,370**.
- Total points for Customer **B** is **820**.

**#BONUS QUESTIONS**

**B1.Join All The Things - Recreate the table with: customer_id, order_date, product_name, price, member (Y/N)**
```
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
  
```
   
**Answer:**
|customer_id	|order_date	|product_name	|price	|member |
|---|---|---|---|---|
|A	|2021-01-01	|sushi	|10	|N|
|A	|2021-01-01	|curry	|15	|N|
|A	|2021-01-07	|curry	|15	|Y|
|A	|2021-01-10	|ramen	|12	|Y|
|A	|2021-01-11	|ramen	|12	|Y|
|A	|2021-01-11	|ramen	|12	|Y|
|B	|2021-01-01	|curry	|15	|N|
|B	|2021-01-02	|curry	|15	|N|
|B	|2021-01-04	|sushi	|10	|N|
|B	|2021-01-11	|sushi	|10	|Y|
|B	|2021-01-16	|ramen	|12	|Y|
|B	|2021-02-01	|ramen	|12	|Y|
|C	|2021-01-01	|ramen	|12	|N|
|C	|2021-01-01	|ramen	|12	|N|
|C	|2021-01-07	|ramen	|12	|N|

**B2.Rank All The Things - Danny also requires further information about the ranking of customer products,
but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.**
```
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
```

**Answer:**

|customer_id	|order_date	|product_name	|price	|member	|ranking |
|---|---|---|---|---|---|
|A	|2021-01-01	|sushi	|10	|N	|NULL|
|A	|2021-01-01	|curry	|15	|N	|NULL|
|A	|2021-01-07	|curry	|15	|Y	|1|
|A	|2021-01-10	|ramen	|12	|Y	|2|
|A	|2021-01-11	|ramen	|12	|Y	|3|
|A	|2021-01-11	|ramen	|12	|Y	|3|
|B	|2021-01-01	|curry	|15	|N	|NULL|
|B	|2021-01-02	|curry	|15	|N	|NULL|
|B	|2021-01-04	|sushi	|10	|N	|NULL|
|B	|2021-01-11	|sushi	|10	|Y	|1|
|B	|2021-01-16	|ramen	|12	|Y	|2|
|B	|2021-02-01	|ramen	|12	|Y	|3|
|C	|2021-01-01	|ramen	|12	|N	|NULL|
|C	|2021-01-01	|ramen	|12	|N	|NULL|
|C	|2021-01-07	|ramen	|12	|N	|NULL|

