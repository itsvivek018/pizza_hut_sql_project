-- Query 1: Retrieve the total number of orders placed

SELECT COUNT(order_id) AS total_orders 
FROM orders;

-- Answer:
-- 21350


-- Query 2: Calculate the total revenue generated

SELECT ROUND(SUM(order_details.quantity * pizzas.price), 2) AS total_revenue
FROM order_details
JOIN pizzas USING(pizza_id);

-- Answer:
-- 817860.05


-- Query 3: Identify the highest-priced pizza

SELECT pizza_types.name, pizzas.price
FROM pizza_types
JOIN pizzas USING(pizza_type_id)
ORDER BY pizzas.price DESC
LIMIT 1;

-- Answer:
-- The Greek Pizza | 35.95


-- Query 4: Identify the most common pizza size ordered.

select pizzas.size, count(order_details.order_id)
from pizzas
join order_details
using(pizza_id)
group by pizzas.size order by count(order_details.order_id) desc

-- Answer:

    L      18526
    M      15385
    S      14137
    XL     544
    XXL    28
    
   
-- Query 5: List the top 5 most ordered pizza types along with their quantities.

-- Answer:

select pizza_types.name, 
sum(order_details.quantity) sales
from pizza_types
join pizzas
using(pizza_type_id)
join order_details
using(pizza_id)
group by pizza_types.name order by sales desc limit 5



 --   The Classic Deluxe Pizza      2453
       The Barbecue Chicken Pizza    2432
       The Hawaiian Pizza            2422
       The Pepperoni Pizza           2418
       The Thai Chicken Pizza        2371
       

-- Query 6: Join the necessary tables to find the total quantity of each pizza category ordered.
 
-- Answer:

  select pizza_types.category,
sum(order_details.quantity) as quantity
from pizza_types
join pizzas
using(pizza_type_id)
join order_details
using(pizza_id)
group by pizza_types.category order by quantity desc


-- 

   Category    Quantity

   Classic     14888
   Supreme     11987
   Veggie      11649
   Chicken     11050

-- Query 7: Determine the distribution of orders by hour of the day.

-- Answer:

select hour(order_time) as hour, count(order_id) order_count from orders
group by hour(order_time)

-- hours    order_count

    11         1231
    12         2520
    13         2455
    14         1472
    15         1468
    16         1920
    17         2336
    18         2399
    19         2009
    20         1642
    21         1198
    22          663
    23           28
    10            8
     9            1
    
 
-- Query 8: Join relevant tables to find the category-wise distribution of pizzas.   


-- Answer:
 
select category,count(name) from pizza_types
group by category

-- 

   category      count(name)

   Chicken         6
   Classic         8
   Supreme         9
   Veggie          9


-- Query 9: Group the orders by date and calculate the average number of pizzas ordered per day

-- Answer:

with a as(select orders.order_date,
sum(order_details.quantity) as quantity
from orders
join order_details
using(order_id)
group by orders.order_date)

select avg(quantity) from a

-- avg(quantity)
   138.4749


-- Query 10: Determine the top 3 most ordered pizza types based on revenue.

-- Answer:
 
select pizza_types.name,
round(sum(order_details.quantity*pizzas.price),0) as sales
from pizza_types
join pizzas
using(pizza_type_id)
join order_details
using(pizza_id)
group by pizza_types.name order by sales desc limit 3


--  name                            sales
   
The Thai Chicken Pizza              43434
The Barbecue Chicken Pizza          42768
The California Chicken Pizza        41410


-- Query 11: Calculate the percentage contribution of each pizza type to total revenue.

-- Answer:


select pizza_types.category,
(round(sum(order_details.quantity*pizzas.price ) / (select
round(sum(order_details.quantity * pizzas.price),2) as sales
from order_details
join pizzas
using(pizza_id)*100,2) as sales
from pizza_types
join pizzas
using(pizza_type_id)
join order_details
using(pizza_id)
group by pizza_types.category order by sales desc 

-- category       sales

   Classic        26.905948028638882
   Supreme        25.45631126009884
   Chicken        23.955198692001154
   Veggie         23.68253590574573



-- Query 12: Determine the top 3 most ordered pizza types based on revenue for each pizza category.

-- Answer:

select name,revenue from
(select category,name,revenue,
rank() over(partition by category order by revenue desc) as rn from
(select pizza_types.category,
pizza_types.name,
sum(order_details.quantity*pizzas.price) as revenue
from pizza_types
join pizzas
using(pizza_type_id)
join order_details
using(pizza_id)
group by pizza_types.category,
pizza_types.name) as a) as b
where rn <= 3

--
   name                                     revenue
  
  The Thai Chicken Pizza                    43434.25
  The Barbecue Chicken Pizza                42768
  The California Chicken Pizza              41409.5
  The Classic Deluxe Pizza                  38180.5
  The Hawaiian Pizza                        32273.25
  The Pepperoni Pizza                       30161.75
  The Spicy Italian Pizza                   34831.25
  The Italian Supreme Pizza                 33476.75
  The Sicilian Pizza                        30940.5
  The Four Cheese Pizza                     32265.70000000065
  The Mexicana Pizza                        26780.75
  The Five Cheese Pizza                     26066.5
