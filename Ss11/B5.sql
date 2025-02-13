create view view_album_artist as
select 
    a.albumid, 
    a.title as album_title, 
    ar.name as artist_name
from album a
join artist ar on a.artistid = ar.artistid;

create view view_customer_spending as
select 
    c.customerid, 
    c.firstname, 
    c.lastname, 
    c.email, 
    sum(i.total) as total_spending
from customer c
join invoice i on c.customerid = i.customerid
group by c.customerid, c.firstname, c.lastname, c.email;

create index idx_employee_lastname 
on employee (lastname);

select * from employee 
where lastname = 'king';

explain select * from employee 
where lastname = 'king';

DELIMITER &&
create procedure GetTracksByGenre(genre_id int)
begin
	select t.TrackId, t.Name as TrackName, a.Title as AlbumTitle, ar.Name as ArtistName from track t 
    join album a on t.AlbumId = a.AlbumId
    join artist ar on ar.ArtistId = a.ArtistId
    where t.GenreId = genre_id;
end &&
DELIMITER ;
call GetTracksByGenre(4);

DELIMITER &&
create procedure GetTrackCountByAlbum(p_albumId int)
begin
	select count(TrackId) as TotalTrack
    from track t join album a on a.AlbumId = t.AlbumId
    where p_albumId = a.AlbumId
    group by a.AlbumId;
end &&
DELIMITER ;
call GetTrackCountByAlbum(6);

drop procedure if exists GetTrackCountByAlbum;
drop procedure if exists GetTracksByGenre;