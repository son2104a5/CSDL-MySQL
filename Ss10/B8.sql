DELIMITER &&
create procedure GetCountriesByCityNames()
begin
	select c.Name as CountryName, GROUP_CONCAT(DISTINCT cl.Language ORDER BY cl.Language SEPARATOR ', ') AS OfficialLanguages, sum(ci.Population) as TotalPopulation
    from country c
    join city ci on ci.CountryCode = c.Code
    join countrylanguage cl on cl.CountryCode = c.Code
    where ci.Name like 'A%' and cl.IsOfficial = 'T'
    group by c.Code, c.Name
    having TotalPopulation > 2000000
    order by c.Name;
end &&
DELIMITER ;
call GetCountriesByCityNames;
drop procedure GetCountriesByCityNames;