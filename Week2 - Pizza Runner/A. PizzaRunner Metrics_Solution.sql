CREATE SCHEMA dannysql;
SET search_path = dannysql;

DROP TABLE IF EXISTS `dannysql`.`runners`;
CREATE TABLE `dannysql`.`runners` (
  `runner_id` INT NULL,
  `registration_date` VARCHAR(45) NULL);

INSERT INTO `dannysql`.`runners` 
  (`runner_id`, `registration_date`)
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


DROP TABLE IF EXISTS `dannysql`.`customer_orders`;
CREATE TABLE `dannysql`.`customer_orders` (
  `order_id` INTEGER,
  `customer_id` INTEGER,
  `pizza_id` INTEGER,
  `exclusions` VARCHAR(4),
  `extras` VARCHAR(4),
  `order_time` TIMESTAMP
);

INSERT INTO `dannysql`.`customer_orders`
  (`order_id`, `customer_id`, `pizza_id`, `exclusions`, `extras`, `order_time`)
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


DROP TABLE IF EXISTS `dannysql`.`runner_orders`;
CREATE TABLE `dannysql`.`runner_orders` (
  `order_id` INTEGER,
  `runner_id` INTEGER,
  `pickup_time` VARCHAR(19),
  `distance` VARCHAR(7),
  `duration` VARCHAR(10),
  `cancellation` VARCHAR(23)
);

INSERT INTO `dannysql`.`runner_orders` 
  (`order_id`, `runner_id`, `pickup_time`, `distance`, `duration`, `cancellation`)
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');


DROP TABLE IF EXISTS `dannysql`.`pizza_names`;
CREATE TABLE `dannysql`.`pizza_names` (
  `pizza_id` INTEGER,
  `pizza_name` TEXT
);
INSERT INTO `dannysql`.`pizza_names`
  (`pizza_id`, `pizza_name`)
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');


DROP TABLE IF EXISTS `dannysql`.`pizza_recipes`;
CREATE TABLE `dannysql`.`pizza_recipes` (
  `pizza_id` INTEGER,
  `toppings` TEXT
);
INSERT INTO `dannysql`.`pizza_recipes`
  (`pizza_id`, `toppings`)
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


DROP TABLE IF EXISTS `dannysql`.`pizza_toppings`;
CREATE TABLE `dannysql`.`pizza_toppings` (
  `topping_id` INTEGER,
  `topping_name` TEXT
);
INSERT INTO `dannysql`.`pizza_toppings`
  (`topping_id`, `topping_name`)
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  
  
  --Clean up - tables: dannysql.customer_orders , dannysql.runner_orders
--dannysql.customer_orders:
--exclusions - remove nulls and replace with ' '
--extras- remove nulls and replace with ' '

--dannysql.runner_orders:
--pickup_time - remove nulls and replace with ' '
--distance - remove km and nulls
--duration - remove minutes and nulls
--cancellation - remove NULL and null and replace with ' ' 

UPDATE dannysql.customer_orders
SET exclusions = CASE
    WHEN exclusions IS null OR exclusions LIKE 'null' or exclusions LIKE 'NULL' or exclusions LIKE 'Null' THEN ' '
    ELSE exclusions
END;

update dannysql.customer_orders
set extras = CASE
	WHEN EXTRAS IS NULL OR EXTRAS LIKE 'NULL' OR extras LIKE 'Null' or extras like 'null' THEN ' '
    else extras
END;

update dannysql.runner_orders
set pickup_time  = case
	when pickup_time is null or pickup_time like 'Null' or pickup_time like 'NULL' or pickup_time like 'null' then ' ' 
    else pickup_time
end;

update dannysql.runner_orders
set distance = case
	when distance is null or distance like 'Null' or distance like 'NULL' or distance like 'null' then ' ' 
    else distance
end;

update dannysql.runner_orders
set distance = case
	WHEN distance LIKE '%km' THEN TRIM('km' from distance)
    else distance
end;

update dannysql.runner_orders
set duration  = case
	when duration is null or duration like ' Null' or duration like 'NULL' or duration like 'null'  then ' '
    else duration
end;

update dannysql.runner_orders
set duration  = case
	when duration like '%minutes' then trim('minutes'from duration)
    when duration like '%min' then trim('min'from duration)
    when duration like '%mins' then trim('mins'from duration)
    when duration like '%minute' then trim('minute'from duration)
    else duration
end;

update dannysql.runner_orders
set cancellation = case
	when cancellation is null or cancellation like '%null' or cancellation like '' then ' ' 
    else cancellation
end;
    

--A. Pizza Metrics
--How many pizzas were ordered?
select count(pizza_id) from dannysql.customer_orders;

--How many unique customer orders were made?
select count(distinct (order_id)) from dannysql.customer_orders;

--How many successful orders were delivered by each runner?
select count(distinct(order_id)) from dannysql.runner_orders where cancellation = ' ' ; 


--How many of each type of pizza was delivered?
select b.pizza_name, count(a.pizza_id) as totalpizzas from dannysql.customer_orders a join dannysql.pizza_names b on a.pizza_id = b.pizza_id
group by b.pizza_name;

--How many Vegetarian and Meatlovers were ordered by each customer?
select a.customer_id, b.pizza_name , count(b.pizza_name) as pizza_orders from dannysql.customer_orders a join dannysql.pizza_names b on a.pizza_id = b.pizza_id
group by a.customer_id , b.Pizza_name;


--What was the maximum number of pizzas delivered in a single order?
select a.order_id, count(a.pizza_id) as pizza_cnt from customer_orders a 
join runner_orders b on a.order_id = b.order_id
where b.cancellation = ' '
group by order_id order by pizza_cnt desc limit 1;

--For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
select a.customer_id, sum(
case when a.exclusions <> ' ' or extras <> ' '  then 1
	 else 0
	end) as Wexclusionsextras, 
    sum(case 
	when a.exclusions = ' ' or extras = ' '  then 1 
	else 0
    end ) as withoutexclusionsextras
from runner_orders b 
join customer_orders a on a.order_id = b.order_id
where b.distance != 0
group by a.customer_id;


--How many pizzas were delivered that had both exclusions and extras?
select a.order_id, sum(case when a.exclusions!=' ' and a.extras != ' ' then 1
else 0
end) as pizza_ordered_wth_extrs_exclusns
from customer_orders a
join runner_orders b on a.order_id = b.order_id
where b.cancellation = ' ' 
group by a.order_id, a.pizza_id;

--What was the total volume of pizzas ordered for each hour of the day?
SELECT
  HOUR(order_time) AS 'Hour',
  COUNT(order_id) AS total_volume_of_pizza
FROM customer_orders
GROUP BY HOUR(order_time)
ORDER BY HOUR(order_time);


--What was the volume of orders for each day of the week?
SELECT
  dayname(order_time) AS 'Dayname',
  COUNT(order_id) AS total_volume_of_pizza
FROM customer_orders
GROUP BY Dayname(order_time)
ORDER BY dayname(order_time);
