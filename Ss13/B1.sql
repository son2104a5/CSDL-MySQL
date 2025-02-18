create table accounts(
	acc_id int primary key auto_increment,
    acc_name varchar(50),
    balance decimal(10, 2)
);

INSERT INTO accounts (acc_name, balance) VALUES 
('Nguyễn Văn An', 1000.00),
('Trần Thị Bảy', 500.00);

DELIMITER &&
drop procedure if exists transferMoney;
set autocommit = 0;
create procedure transferMoney(
	from_acc int, 
    to_acc int, 
    amount decimal(10, 2)
)
begin
	start transaction;
    if(select count(acc_id) from accounts where Acc_ID = from_acc) = 0
		or (select count(acc_id) from accounts where Acc_ID = to_acc) = 0 then
            rollback;
	else
        update accounts
			set balance = balance - amount
            where acc_id = from_acc;
        if(select balance from accounts where Acc_ID = from_acc) < amount then
            rollback;
		else
            update accounts
				set balance = balance + amount
                where acc_id = to_acc;
		end if;
    end if;
    commit;
end &&
DELIMITER ;

call transferMoney(1, 2, 300);

select * from accounts;