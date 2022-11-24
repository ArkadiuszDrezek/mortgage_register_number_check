create trigger tr_atrybut_akcji_instead on atrybut_akcji instead of insert
as

if exists (select 1 from inserted where atak_atakt_id = 57)

begin

	declare @check_value bit = (select PATINDEX('[A-Z][A-Z][0-9][A-Z]/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]/[0-9]', atak_wartosc) from inserted)

	if @check_value = 0
		begin

			delete akcja where ak_id in (select ak_id from inserted)
			delete rezultat where re_ak_id in (select atak_ak_id from inserted)

			EXEC msdb.dbo.sp_send_dbmail
				@profile_name = 'SQLProfile',
				@recipients = 'arkadiusz.drezek@cfsa.pl',
				@body = 'Niepoprawny numer KW',
				@subject = 'Niepoprawny NR KW'

		end
	else
		begin

				insert into atrybut_akcji
				(atak_ak_id, atak_atakt_id, atak_wartosc)
				select atak_ak_id, atak_atakt_id, atak_wartosc from inserted

		end

end