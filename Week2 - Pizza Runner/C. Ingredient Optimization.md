 #🍕 Case Study #2 Pizza Runner

## Solution - C. Ingredient Optimisation

### 1. What are the standard ingredients for each pizza?

### 2. What was the most commonly added extra?

```sql
WITH toppings_cte AS (
SELECT
  pizza_id,
  REGEXP_SPLIT_TO_TABLE(toppings, '[,\s]+')::INTEGER AS topping_id
FROM pizza_runner.pizza_recipes)

SELECT 
  t.topping_id, pt.topping_name, 
  COUNT(t.topping_id) AS topping_count
FROM toppings_cte t
INNER JOIN pizza_runner.pizza_toppings pt
  ON t.topping_id = pt.topping_id
GROUP BY t.topping_id, pt.topping_name
ORDER BY topping_count DESC;
```
