-- Calculate the total revenue generated from pizza sales.
select * from pizzahut.pizzas;

SELECT 
    SUM(price) AS Total_Revenue_Of_Pizza_Sales
FROM
    pizzahut.pizzas;

SELECT 
    SUM(order_details.quantity * pizzas.price) AS total_Revenue
FROM
    order_details
    
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;
