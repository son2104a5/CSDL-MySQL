create database ticketfilm;
use ticketfilm;

create table tbl_phim (
    phimid int primary key auto_increment,
    ten_phim varchar(30) not null,
    loai_phim varchar(25) not null,
    thoi_gian int not null
);

create table tbl_phong (
    phongid int primary key auto_increment,
    trang_thai tinyint not null,
    ten_phong varchar(20) not null
);

create table tbl_ghe (
    gheid int primary key auto_increment,
    phongid int not null,
    so_ghe varchar(10) not null,
    foreign key (phongid) references tbl_phong(phongid)
);

create table tbl_ve (
    gheid int,
    phimid int,
    ngay_chieu datetime not null,
    trang_thai varchar(20) not null,
    primary key (gheid, phimid),
    foreign key (gheid) references tbl_ghe(gheid),
    foreign key (phimid) references tbl_phim(phimid)
);

insert into tbl_phim (phimid, ten_phim, loai_phim, thoi_gian) values
(1, 'em bé hà nội', 'tâm lý', 90),
(2, 'nhiệm vụ bất khả thi', 'hành động', 100),
(3, 'dị nhân', 'viễn tưởng', 80),
(4, 'cuốn theo chiều gió', 'tình cảm', 120);

insert into tbl_ghe (gheid, phongid, so_ghe) values
(1, 1, 'a3'),
(2, 1, 'b5'),
(3, 1, 'a7'),
(4, 2, 'd1'),
(5, 2, 't2');

insert into tbl_ve (phimid, gheid, ngay_chieu, trang_thai) values
(1, 1, '2008-10-20', 'đã bán'),
(1, 2, '2008-11-20', 'đã bán'),
(1, 3, '2008-12-23', 'đã bán'),
(2, 4, '2009-02-14', 'đã bán'),
(3, 5, '2009-03-08', 'chưa bán');

select * from tbl_phim order by thoi_gian;

select ten_phim from tbl_phim order by thoi_gian desc limit 1;

select ten_phim from tbl_phim order by thoi_gian asc limit 1;

select so_ghe from tbl_ghe where so_ghe like 'a%';

alter table tbl_phong modify column trang_thai varchar(25);

update tbl_phong 
set trang_thai = case 
    when trang_thai = '0' then 'đang sửa'
    when trang_thai = '1' then 'đang sử dụng'
    when trang_thai is null then 'unknow'
end;

delimiter //
create procedure show_tbl_phong()
begin
    select * from tbl_phong;
end //
delimiter ;

call show_tbl_phong();

select ten_phim from tbl_phim where length(ten_phim) > 15 and length(ten_phim) < 25;

select concat(ten_phong, ' - ', trang_thai) as 'trạng thái phòng chiếu' from tbl_phong;

create view tbl_rank as 
select row_number() over (order by ten_phim) as stt, ten_phim, thoi_gian 
from tbl_phim;

alter table tbl_phim add column mo_ta nvarchar(255);

update tbl_phim 
set mo_ta = concat('đây là film thể loại ', loai_phim);

select * from tbl_phim;

update tbl_phim 
set mo_ta = replace(mo_ta, 'bộ phim', 'film');

select * from tbl_phim;

alter table tbl_ghe drop foreign key tbl_ghe_ibfk_1;
alter table tbl_ve drop foreign key tbl_ve_ibfk_1;
alter table tbl_ve drop foreign key tbl_ve_ibfk_2;

delete from tbl_ghe;

select ngay_chieu, date_add(ngay_chieu, interval 5000 minute) as ngay_chieu_moi from tbl_ve;
