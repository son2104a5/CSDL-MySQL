create view officalLanguageView
as
select c.Code as CountryCode, c.Name as CountryName, cl.Language
from country c
join countrylanguage cl on cl.CountryCode = c.Code where cl.IsOfficial = 'T';

select * from officallanguageview;

create index idx_cityName on city(Name);

DELIMITER &&
create procedure GetSpecialCountriesAndCities(language_name varchar(20))
begin
	select c.Name, ci.Name, ci.Population, sum(ci2.Population) as TotalPopulation
    from country c
    join city ci on ci.CountryCode = c.Code
    join countrylanguage cl on cl.CountryCode = c.Code
    join city ci2 on c.Code = ci2.CountryCode
    where ci.Name like 'New%' and cl.Language = language_name
    group by c.Code, c.Name, ci.Population, ci.Name
    having TotalPopulation > 5000000
    order by TotalPopulation desc limit 10;
end &&
DELIMITER ;
call GetSpecialCountriesAndCities('English');
drop procedure GetSpecialCountriesAndCities;