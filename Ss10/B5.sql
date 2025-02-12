DELIMITER &&
create procedure GetLargeCitiesByCountry(country_code char(3))
begin
	select ID as CityID, Name as CityName, Population from city 
    where CountryCode = country_code and Population > 1000000 order by Population desc;
end &&
DELIMITER ;
call GetLargeCitiesByCountry('USA');
drop procedure GetLargeCitiesByCountry;