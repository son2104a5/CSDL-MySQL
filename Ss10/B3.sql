DELIMITER &&
create procedure get_country_with_language(ct_language varchar(20))
begin
	select CountryCode, Language, Percentage from countrylanguage where Language = ct_language;
end &&
DELIMITER ;
call get_country_with_language('English');
drop procedure get_country_with_language;