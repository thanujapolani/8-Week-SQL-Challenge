
# Case Study #2 - Pizza Runner
<img src="https://user-images.githubusercontent.com/11831222/225146006-167e34a4-0389-4410-bcc4-1951cd68099e.png" alt="drawing" style="width:300px;"/>

______________________________________________________________________________________________________________________________________________________


## 📚 Table of Contents
- [Problem Statement](https://github.com/thanujapolani/8-Week-SQL-Challenge/blob/main/Week2%20-%20Pizza%20Runner/README.md#problem-statement)
- [Entity Relationship Diagram](https://github.com/thanujapolani/8-Week-SQL-Challenge/edit/main/Week2%20-%20Pizza%20Runner/README.md#entity-relationship-diagram)
- [Case Study Questions](https://github.com/thanujapolani/8-Week-SQL-Challenge/edit/main/Week2%20-%20Pizza%20Runner/README.md#case-study-questions)
- [Learnings](https://github.com/thanujapolani/8-Week-SQL-Challenge/edit/main/Week2%20-%20Pizza%20Runner/README.md#learnings)
- [Solution]()
- [Insights]()

_______________________________________________________________________________________________________________________________________________________

### Problem Statement
Danny wants to use the data to answer a few simple questions about his customers, especially about their Pizza Orders, Runners and customer Experience, Pizza metrics, Ingredients Optimization, process and ratings. These insights would help him to optimize the process to improve performance.

He plans on using these insights to uncover new markets to add new sources of revenue

_______________________________________________________________________________________________________________________________________

### Entity Relationship Diagram
![Entity Relationship Diagram](https://user-images.githubusercontent.com/11831222/225155191-6d77a01b-64e6-42c6-b928-7709997578a2.png)
__________________________________________________________________________________________________________________
 
### Case Study Questions
**A. Pizza Metrics**

A1.How many pizzas were ordered?  

A2.How many unique customer orders were made?  

A3. How many successful orders were delivered by each runner?  

A4.How many of each type of pizza was delivered?  

A5.How many Vegetarian and Meatlovers were ordered by each customer?  

A6.What was the maximum number of pizzas delivered in a single order?  

A7.For each customer, how many delivered pizzas had at least 1 change and how many had no changes?  

A8.How many pizzas were delivered that had both exclusions and extras?  

A9.What was the total volume of pizzas ordered for each hour of the day?  

A10.What was the volume of orders for each day of the week?

**B. Runner and Customer Experience**  

B1.How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)  

B2.What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?  

B3.Is there any relationship between the number of pizzas and how long the order takes to prepare?  

B4.What was the average distance travelled for each customer?  

B5.What was the difference between the longest and shortest delivery times for all orders?  

B6.What was the average speed for each runner for each delivery and do you notice any trend for these values?  

B7.What is the successful delivery percentage for each runner?

**C. Ingredient Optimisation**  

C1.What are the standard ingredients for each pizza?  

C2.What was the most commonly added extra?  

C3.What was the most common exclusion?  

C4.Generate an order item for each record in the customers_orders table in the format of one of the following:
  Meat Lovers
  Meat Lovers - Exclude Beef
  Meat Lovers - Extra Bacon
  Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers  
  
C5.Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
  For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"  
  
C6.What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

**D. Pricing and Ratings**  

D1.If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?  

D2.What if there was an additional $1 charge for any pizza extras?
  Add cheese is $1 extra  
  
D3.The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.  

D4.Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
  customer_id
  order_id
  runner_id
  rating
  order_time
  pickup_time
  Time between order and pickup
  Delivery duration
  Average speed
  Total number of pizzas  
  
D5.If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?  


**E. Bonus Questions**
If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?

### **Learnings**
- Common Table Expressions
- Group By Aggregates
- String Transformations
- Dealing with Null values
- Regular Expressions
- Table Joins
