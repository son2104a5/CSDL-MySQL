DELIMITER &&
create procedure get_city(country_code int)
begin
	select ID, Name, Population from city where ID = country_code;
end &&
DELIMITER ;
call get_city(10);
drop procedure get_city;