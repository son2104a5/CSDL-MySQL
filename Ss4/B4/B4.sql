create database film_management;

use film_management;

create table category (
    category_id int primary key auto_increment,
    category_name varchar(50) not null,
    description text,
    status bit not null default 1
);

create table film (
    film_id int primary key auto_increment,
    film_name varchar(50) not null,
    content text not null,
    duration time not null,
    director varchar(50),
    release_date date not null
);

create table category_film (
    category_id int not null,
    film_id int not null,
    primary key (category_id, film_id),
    foreign key (category_id) references category(category_id),
    foreign key (film_id) references film(film_id)
);

alter table category_film add constraint fk_category foreign key (category_id) references category(category_id);
alter table category_film add constraint fk_film foreign key (film_id) references film(film_id);

alter table film add column status tinyint default 1;

alter table category drop column status;

alter table category_film drop foreign key fk_category;
alter table category_film drop foreign key fk_film;