DELIMITER &&
create procedure update_city_population(inout city_id int, in new_population int)
begin
	update city
    set Population = new_population
    where ID = city_id;
    
    select ID, Name, Population from city where id = city_id;
end &&
DELIMITER ;
set @city_id = 1;
call update_city_population(@city_id, 6000000);
drop procedure update_city_population;