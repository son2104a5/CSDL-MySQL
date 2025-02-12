DELIMITER &&
create procedure get_total_population_in_country(country_code char(3), out total_population int)
begin
	select coalesce(sum(ci.Population), 0) as 'TotalPopulation', c.Name from city ci join country c on c.Code = ci.CountryCode
    where country_code = CountryCode group by ci.CountryCode;
end &&
DELIMITER ;
call get_total_population_in_country('USA',@total_population);
drop procedure get_total_population_in_country;