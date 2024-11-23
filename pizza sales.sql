select * from orders;
select * from order_details;

select count(order_id) as total_orders from orders;
select count(order_id) as total_orders from order_details;

-- Calculate the total revenue generated from pizza sales.
select sum(order_details.quantity*pizzas.price) as revenue from pizzas join order_details on
pizzas.pizza_id = order_details.pizza_id;

-- Identify the highest-priced pizza.
select pizza_types.name, pizzas.price as exp from pizza_types join pizzas on
pizzas.pizza_type_id = pizzas.pizza_type_id order by exp desc limit 1;

-- Identify the most common pizza size ordered.
select pizzas.size,count(order_details.order_details_id) as common from order_details join pizzas on
pizzas.pizza_id = order_details.pizza_id group by size order by common desc ;

-- List the top 5 most ordered pizza types along with their quantities.
select pizza_types.name,sum(order_details.quantity) total from pizza_types join pizzas on
pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details on
order_details.pizza_id = pizzas.pizza_id group by pizza_types.name order by total desc limit 5;

-- Determine the distribution of orders by hour of the day.
select hour(time) , count(order_id) from orders group by hour(time) order by count(order_id) desc;

-- Join relevant tables to find the category-wise distribution of pizzas.
select category,count(name) from pizza_types group by category order by count(name) desc;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
select avg(total) from
(select orders.date,sum(order_details.quantity) as total from orders join order_details on
orders.order_id = order_details.order_id group by orders.date order by total desc) as avg_order;

-- Determine the top 3 most ordered pizza types based on revenue.
select pizza_types.name,sum(order_details.quantity*pizzas.price) as revenue from pizza_types join pizzas on 
pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details on pizzas.pizza_id = order_details.pizza_id group by pizza_types.name order by revenue 
desc limit 3;

-- Calculate the percentage contribution of each pizza type to total revenue.SELECT 
select pizza_types.category,round(sum(order_details.quantity*pizzas.price)/(select sum(order_details.quantity*pizzas.price) as revenue from order_details join pizzas
on pizzas.pizza_id = order_details.pizza_id)*100,0) as cost from pizza_types join pizzas on
pizza_types.pizza_type_id = pizzas.pizza_type_id 
join order_details on
order_details.pizza_id = pizzas.pizza_id group by category;

-- calculate cummulative revenue on the daily basis
select date,sum(revenue) over(order by date) as cumrev from
(select orders.date,sum(order_details.quantity*pizzas.price) as revenue from order_details join pizzas
on pizzas.pizza_id = order_details.pizza_id join
orders on order_details.order_id = orders.order_id group by orders.date) as revenue_table;
-- List of the top 3 pizza from each category
select * from pizza_types;
select category,name,revenue from
(select category,name,revenue, rank() over(partition by category order by revenue desc) as rn from
(select pizza_types.category,pizza_types.name,sum((order_details.quantity)*pizzas.price) as revenue from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id join order_details on order_details.pizza_id = pizzas.pizza_id
group by category,name) as a)as b where rn<=3 ;
