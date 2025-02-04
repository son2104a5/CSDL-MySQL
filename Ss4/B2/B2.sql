create table company(
	company_id int auto_increment primary key,
    company_name varchar(255) not null,
    company_address text not null
);

create table provider(
	provider_id int auto_increment primary key,
    provider_name varchar(255) not null,
    provider_address text not null
);

create table supplies(
	sup_id int auto_increment primary key,
    sup_quantity int not null,
    sup_type varchar(255) not null,
    price int not null
);

create table bill(
	provider_id int,
    company_id int,
    sup_id int,
    creation_date text not null,
    primary key (provider_id, company_id, sup_id),
    foreign key (provider_id) references provider(provider_id),
    foreign key (company_id) references company(company_id),
    foreign key (sup_id) references supplies(sup_id)
);

