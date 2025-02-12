explain analyze select * from customers where country = 'Germany';

create index idx_country on customers(country);

drop index idx_country on customers;

-- trước khi đánh chỉ mục: 0.0492, sau khi đánh chỉ mục: 0.09 --> Mat nhieu thoi gian hon