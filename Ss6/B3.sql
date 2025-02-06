select
	min(o.Price) as MinPrice, max(o.Price) as MaxPrice
from orders o;

select
	o.CustomerName, count(o.CustomerName) as OrderCount
from orders o
group by o.CustomerName;

select
	min(o.OrderDate) as EarliestDate, max(o.OrderDate) as LatestDate
from orders o;