drop database if exists flightmanager;
create database flightManager;
use flightManager;

create table Flight(
	flight_id char(10) primary key not null,
    airline_name varchar(100),
    departure_airport varchar(100),
    arrival_airport varchar(100),
    departure_time datetime,
    arrival_time datetime,
    ticket_price decimal(10, 2)
);

create table Passenger(
	passenger_id char(10) primary key,
    passenger_full_name varchar(150) not null,
    passenger_email varchar(255) not null unique,
    passenger_phone varchar(15) not null,
    passenger_dob date
);

create table Booking(
	booking_id int primary key auto_increment,
    passenger_id char(10),
    foreign key (passenger_id) references Passenger(passenger_id),
    flight_id char(10),
    foreign key (flight_id) references Flight(flight_id),
    booking_date date,
    booking_status enum('Confirmed','Cancelled','Pending')
);

create table Payment(
	payment_id int primary key auto_increment,
    booking_id int,
    foreign key (booking_id) references Booking(booking_id),
    payment_method enum('Credit Card','Bank Transfer','Cash'),
    payment_amount decimal(10, 2),
    payment_date date,
    payment_status enum('Success','Failed','Pending')
);

-- 2.2
alter table Passenger add column passenger_gender enum('Nam','Nu','Khac');

-- 2.3
alter table Booking add column ticket_quantity int not null default(1);

-- 2.4
alter table Payment modify column payment_amount decimal(10, 2) check(payment_amount > 0);

-- 3
-- 3.1
insert into Passenger(passenger_id, passenger_full_name, passenger_email, passenger_phone, passenger_dob, passenger_gender)
values
	('P0001', 'Nguyen Anh Tuan', 'tuan.nguyen@example.com', '0901234567', '1995-05-15', 'Nam'),
    ('P0002', 'Tran Thi Mai', 'mai.tran@example.com', '0912345678', '1996-06-16' ,'Nu'),
    ('P0003', 'Le Minh Tuan', 'tuan.le@example.com', '0923456789', '1997-07-17' ,'Nam'),
    ('P0004', 'Pham Hong Son', 'son.pham@example.com', '0934567890', '1998-08-18' ,'Nam'),
    ('P0005', 'Nguyen Thi Lan', 'lan.nguyen@example.com', '0945678901', '1999-09-19' ,'Nu'),
    ('P0006', 'Vu Thi Bao', 'bao.vu@example.com', '0956789012', '2000-10-20' ,'Nu'),
    ('P0007', 'Doan Minh Hoang', 'hoang.doan@example.com', '0967890123', '2001-11-21' ,'Nam'),
    ('P0008', 'Nguyen Thi Thanh', 'thanh.nguyen@example.com', '0978901234', '2002-12-22' ,'Nu'),
    ('P0009', 'Trinh Bao Vy', 'vy.trinh@example.com', '0989012345', '2003-01-23' ,'Nu'),
    ('P0010', 'Bui Hoang Nam', 'nam.bui@example.com', '0990123456', '2004-02-24' ,'Nam');
    
insert into Flight(flight_id, airline_name, departure_airport, arrival_airport, departure_time, arrival_time, ticket_price)
values
	('F001', 'VietJet Air', 'Tan Son Nhat', 'Nha Trang', '2025/03/01 08:00:00', '2025/03/01 10:00:00', '150.5'),
    ('F002', 'Vietnam Airlines', 'Noi Bai', 'Ha Noi', '2025/03/01 09:00:00', '2025/03/01 11:30:00', '200.0'),
    ('F003', 'Bamboo Airways', 'Da Nang', 'Phu Quoc', '2025/03/01 10:00:00', '2025/03/01 12:00:00', '120.8'),
    ('F004', 'Vietravel Airlines', 'Can Tho', 'Ho Chi Minh', '2025/03/01 11:00:00', '2025/03/01 12:30:00', '180.0');
    
insert into Booking(flight_id, passenger_id, booking_date, booking_status, ticket_quantity)
values
	('F001', 'P0001', '2025-02-20', 'Confirmed', 1),
	('F002', 'P0002', '2025-02-21', 'Cancelled', 2),
	('F003', 'P0003', '2025-02-22', 'Pending', 1),
	('F004', 'P0004', '2025-02-23', 'Confirmed', 3),
	('F001', 'P0005', '2025-02-24', 'Pending', 1),
	('F002', 'P0006', '2025-02-25', 'Confirmed', 2),
	('F003', 'P0007', '2025-02-26', 'Cancelled', 1),
	('F004', 'P0008', '2025-02-27', 'Pending', 4),
	('F001', 'P0009', '2025-02-28', 'Confirmed', 1),
	('F002', 'P0010', '2025-02-28', 'Pending', 1),
    ('F003', 'P0001', '2025-03-01', 'Confirmed', 3),
	('F004', 'P0002', '2025-03-02', 'Cancelled', 1),
	('F001', 'P0003', '2025-03-03', 'Pending', 2),
	('F002', 'P0004', '2025-03-04', 'Confirmed', 1),
	('F003', 'P0005', '2025-03-05', 'Cancelled', 2),
	('F004', 'P0006', '2025-03-06', 'Pending', 1),
	('F001', 'P0007', '2025-03-07', 'Confirmed', 3),
	('F002', 'P0008', '2025-02-08', 'Cancelled', 2),
	('F003', 'P0009', '2025-03-09', 'Pending', 1),
	('F004', 'P0010', '2025-03-10', 'Confirmed', 1);
    
insert into Payment(booking_id, payment_method, payment_amount, payment_date, payment_status)
values
	(1, 'Credit Card', 150.5, '2025-02-20', 'Success'),
    (2, 'Bank Transfer', 200.0, '2025-02-21', 'Failed'),
    (3, 'Cash', 120.8, '2025-02-22', 'Pending'),
    (4, 'Credit Card', 180.0, '2025-02-23', 'Success'),
    (5, 'Bank Transfer', 150.5, '2025-02-24', 'Pending'),
    (6, 'Cash', 200, '2025-02-25', 'Success'),
    (7, 'Credit Card', 120.8, '2025-02-26', 'Failed'),
    (8, 'Bank Transfer', 180.0, '2025-02-27', 'Pending'),
    (9, 'Cash', 150.5, '2025-02-28', 'Success'),
    (10, 'Credit Card', 200.0, '2025-03-01', 'Pending');
    
-- 3.2
update payment
set payment_status = case
						when payment_amount > 0 and payment_method = 'Credit Card' then 'Success'
						when payment_amount < 100 and payment_method = 'Bank Transfer' then 'Pending'
					 end
where payment_date < curdate();

delete from payment
where payment_status = 'Pending' and payment_method = 'Cash';

-- 4
-- 4.1
select passenger_id, passenger_full_name, passenger_email, passenger_dob, passenger_gender
from passenger
order by passenger_full_name limit 5;

-- 4.2
select flight_id, airline_name, departure_airport, arrival_airport
from flight 
order by ticket_price desc;

-- 4.3
select p.passenger_id, p.passenger_full_name, b.booking_date
from booking b
left join passenger p on p.passenger_id = b.passenger_id
where b.booking_status = 'Cancelled';

-- 4.4
select b.booking_id, p.passenger_id, b.booking_date, b.ticket_quantity
from booking b
left join passenger p on p.passenger_id = b.passenger_id
where b.booking_status = 'Confirmed';

-- 4.5
select b.booking_id, p.passenger_full_name, b.booking_date, b.ticket_quantity
from booking b
left join passenger p on p.passenger_id = b.passenger_id
where b.ticket_quantity between 2 and 3
order by p.passenger_full_name;

-- 4.6
select p.passenger_id, p.passenger_full_name, b.ticket_quantity
from booking b
left join passenger p on p.passenger_id = b.passenger_id
where b.ticket_quantity >= 2;

-- 4.7
select p.passenger_id, p.passenger_full_name, pa.payment_amount
from payment pa
left join booking b on b.booking_id = pa.booking_id
left join passenger p on p.passenger_id = b.passenger_id
where pa.payment_status = 'Success';

-- 4.8
select p.passenger_id, p.passenger_full_name, b.ticket_quantity, b.booking_status
from booking b
left join passenger p on p.passenger_id = b.passenger_id
where b.ticket_quantity > 1
limit 5;

-- 4.9
select f.flight_id, f.airline_name, b.ticket_quantity
from booking b
left join flight f on f.flight_id = b.flight_id
where b.ticket_quantity = (select ticket_quantity from booking order by ticket_quantity desc limit 1);

-- 4.10
select p.passenger_full_name, pa.payment_amount, pa.payment_status
from payment pa
left join booking b on b.booking_id = pa.booking_id
left join passenger p on p.passenger_id = b.passenger_id
where year(p.passenger_dob) < 2000 order by p.passenger_full_name;

-- 5
-- 5.1
drop view if exists view_all_passenger_booking;
create view view_all_passenger_booking 
	as
	select p.passenger_id, p.passenger_full_name, b.booking_id, f.flight_id, b.ticket_quantity
	from booking b
	left join flight f on f.flight_id = b.flight_id
	left join passenger p on p.passenger_id = b.passenger_id;

-- 5.2
drop view if exists view_successful_payment;
create view view_successful_payment 
	as
    select p.passenger_id, p.passenger_full_name, pa.payment_amount
	from payment pa
	left join booking b on b.booking_id = pa.booking_id
	left join passenger p on p.passenger_id = b.passenger_id
	where pa.payment_status = 'Success';
    
-- 6
-- 6.1
DELIMITER &&
drop trigger if exists checkTicketQuantity;
create trigger checkTicketQuantity after update on booking for each row
begin
	if new.ticket_quantity < 1 then
		signal sqlstate '45000'
        set message_text = 'Lỗi! Không thể cập nhật số vé.';
    end if;
end &&
DELIMITER ;

-- 6.2
DELIMITER &&
drop trigger if exists checkPaymentStatusAndUpdateStatusBooking;
create trigger checkPaymentStatusAndUpdateStatusBooking after insert on payment for each row
begin
	if new.payment_status = 'Success' then
		update booking b
			set b.booking_status = 'Confirmed' where b.booking_id = new.booking_id;
    end if;
end &&
DELIMITER ;

-- 7
-- 7.1
DELIMITER &&
drop procedure if exists GetAllPassengerBookings;
create procedure GetAllPassengerBookings()
begin
	select p.passenger_id, p.passenger_full_name, b.booking_id, f.flight_id, b.ticket_quantity
	from booking b
	left join flight f on f.flight_id = b.flight_id
	left join passenger p on p.passenger_id = b.passenger_id;
end &&
DELIMITER ;
call GetAllPassengerBookings;

-- 7.2
DELIMITER &&
drop procedure if exists AddBooking;
create procedure AddBooking(
	p_booking_id int,
    p_passenger_id char(10),
    p_flight_id char(10),
    p_ticket_quantity int
)
begin
	update booking
    set
		passenger_id = p_passenger_id,
        flight_id = p_flight_id,
        ticket_quantity = p_ticket_quantity
	where booking_id = p_booking_id;
end &&
DELIMITER ;

call AddBooking(8, 'P0008', 'F002', 1);