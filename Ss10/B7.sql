DELIMITER &&
create procedure GetEnglishSpeakingCountriesWithCities(language varchar(20))
begin
	select c.Name as CountryName, sum(ci.Population) as TotalCityPopulation from country c
    join city ci on ci.CountryCode = c.Code
    join countrylanguage cl on cl.CountryCode = c.Code
    where cl.IsOfficial = 'T' and cl.Language = language
    group by c.Code
    having TotalCityPopulation > 5000000
    order by TotalCityPopulation desc limit 10;
end &&
DELIMITER ;
call GetEnglishSpeakingCountriesWithCities('English');
drop procedure GetEnglishSpeakingCountriesWithCities;