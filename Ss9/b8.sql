create index idx_productline 
on products (productline);

create view view_highest_priced_products as
select p.productline, p.productname, p.msrp
from products p
where p.msrp = (
    select max(msrp) 
    from products 
    where productline = p.productline
);

select * from view_highest_priced_products;

select v.productline, v.productname, v.msrp, pl.textdescription
from view_highest_priced_products v
join productlines pl on v.productline = pl.productline
order by v.msrp desc
limit 10;