/*
Question-1

Write a query that returns orders of the products branded "Seagate". 
It should be listed Product names and order IDs of all the products ordered or not ordered. (order_id in ascending order)
*/

SELECT product_name, order_id
FROM product.product
LEFT JOIN sale.order_item
ON product.product_id = order_item.product_id
WHERE brand_id = (	SELECT brand_id 
					FROM product.brand
					WHERE brand_name = 'Seagate')
ORDER BY order_id ASC;



/*
Question-2

Write a query that returns the order date of the product named "Sony - 5.1-Ch. 3D / Smart Blu-ray Home Theater System - Black".
*/

SELECT order_date
FROM sale.orders
INNER JOIN sale.order_item
ON sale.orders.order_id = sale.order_item.order_id
WHERE sale.order_item.product_id = (SELECT product_id
									FROM product.product
									WHERE product_name = 'Sony - 5.1-Ch. 3D / Smart Blu-ray Home Theater System - Black');
