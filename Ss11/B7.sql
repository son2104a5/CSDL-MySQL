create view view_track_details as
select 
    t.trackid, 
    t.name as track_name, 
    a.title as album_title, 
    ar.name as artist_name, 
    t.unitprice
from track t
join album a on t.albumid = a.albumid
join artist ar on a.artistid = ar.artistid
where t.unitprice > 0.99;
select * from view_track_details;

create view view_customer_invoice as
select 
    c.customerid, 
    concat(c.lastname, ' ', c.firstname) as fullname, 
    c.email, 
    sum(i.total) as total_spending, 
    e.firstname as support_rep
from customer c
join invoice i on c.customerid = i.customerid
join employee e on c.supportrepid = e.employeeid
group by c.customerid, c.lastname, c.firstname, c.email, e.firstname
having sum(i.total) > 5;
select * from view_customer_invoice;

create view view_top_selling_tracks as
select 
    t.trackid, 
    t.name as track_name, 
    g.name as genre_name, 
    sum(il.quantity) as total_sales
from track t
join invoiceline il on t.trackid = il.trackid
join genre g on t.genreid = g.genreid
group by t.trackid, t.name, g.name
having sum(il.quantity) > 10;
select * from view_top_selling_tracks;

create index idx_track_name 
on track (name) using btree;

select * from track 
where name like '%love%';

explain select * from track 
where name like '%love%';

create index idx_invoice_total 
on invoice (total);

select * from invoice 
where total between 20 and 100;

explain select * from invoice 
where total between 20 and 100;

DELIMITER &&
create procedure GetCustomerSpending(customer_id int)
begin
	select coalesce(sum(total_spending), 0)
    from view_customer_invoice
    where customerid = customer_id
    group by customerid;
end &&
DELIMITER ;
call GetCustomerSpending(3);

DELIMITER &&
create procedure SearchTrackByKeyword(p_keyword varchar(10))
begin
	select Name as TrackName from track
    where Name like concat('%',p_keyword, '%');
end &&
DELIMITER ;
call SearchTrackByKeyword('lo%');

DELIMITER &&
create procedure GetTopSellingTracks(p_MinSales int, p_MaxSales int)
begin
	select track_name, total_sales
    from view_top_selling_tracks
    where total_sales between p_MinSales and p_MaxSales;
end &&
DELIMITER ;
call GetTopSellingTracks(5, 10);

drop view view_track_details;
drop view view_top_selling_tracks;
drop view view_customer_invoice;
drop index idx_track_name on track;
drop index idx_invoice_total on invoice;
drop procedure GetCustomerSpending;
drop procedure SearchTrackByKeyword;
drop procedure GetTopSellingTracks;