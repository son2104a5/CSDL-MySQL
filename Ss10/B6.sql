DELIMITER &&
create procedure GetCountriesWithLargeCities()
begin
	select c.Name as CountryName, sum(ci.Population) as TotalPopulation from city ci
    join country c on c.Code = ci.CountryCode
    where c.Continent = 'Asia'
    group by c.Code
    having TotalPopulation > 10000000
    order by TotalPopulation desc;
end &&
DELIMITER ;
call GetCountriesWithLargeCities;
drop procedure GetCountriesWithLargeCities;