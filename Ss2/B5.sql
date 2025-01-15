create table customer(
	cus_id int primary key,
    cus_name varchar(100),
	cus_phone varchar(100) not null
);

create table bill(
	bill_id int primary key,
    bill_created date,
    cus_id int,
    constraint cus_id foreign key (cus_id) references customer(cus_id)
);
