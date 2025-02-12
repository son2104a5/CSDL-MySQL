create index idx_productline 
on products (productline);

create view view_total_sales as
select 
    p.productline, 
    sum(o.quantityordered * o.priceeach) as total_sales, 
    sum(o.quantityordered) as total_quantity
from orderdetails o
join products p on o.productcode = p.productcode
group by p.productline;

select * from view_total_sales;

select 
    v.productline, 
    pl.textdescription, 
    v.total_sales, 
    v.total_quantity,
    case 
        when length(pl.textdescription) > 30 then concat(left(pl.textdescription, 30), '...')
        else pl.textdescription
    end as description_snippet,
    case 
        when v.total_quantity > 1000 then (v.total_sales / v.total_quantity) * 1.1
        when v.total_quantity between 500 and 1000 then v.total_sales / v.total_quantity
        else (v.total_sales / v.total_quantity) * 0.9
    end as sales_per_product
from view_total_sales v
join productlines pl on v.productline = pl.productline
where v.total_sales > 2000000
order by v.total_sales desc;