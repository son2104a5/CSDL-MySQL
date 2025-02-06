select
	CustomerName, ProductName, sum(quantity) as TotalQuantity
from orders
group by OrderID
having sum(quantity) > 1;

select
	o.CustomerName, o.OrderDate, o.Quantity
from orders o
group by o.OrderID
having o.Quantity > 2;

select
	o.CustomerName, o.OrderDate, sum(o.price * o.Quantity) as TotalSpent
from orders o
group by o.OrderId
having sum(o.price * o.Quantity) > 20000000;