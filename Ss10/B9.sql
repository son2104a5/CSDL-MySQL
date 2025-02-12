drop view if exists countrylanguageview;
create view CountryLanguageView
as
select distinct c.Code, c.Name, cl.Language, max(cl.IsOfficial)	 as IsOfficial from country c
join countrylanguage cl on cl.CountryCode = c.Code where cl.IsOfficial = 'T' group by c.Code, c.Name, cl.Language;

select * from countrylanguageview;

DELIMITER &&
create procedure GetLargeCitiesWithEnglish()
begin
	select ci.Name as CityName, c.name as CountryName, ci.population from country c
    join city ci on ci.CountryCode = c.Code
    join countrylanguage cl on cl.CountryCode = c.Code
    where ci.Population > 1000000 and cl.Language = 'English' and cl.IsOfficial = 'T'
    order by ci.Population desc limit 20;
end &&
DELIMITER ;
call GetLargeCitiesWithEnglish;
drop procedure GetLargeCitiesWithEnglish;