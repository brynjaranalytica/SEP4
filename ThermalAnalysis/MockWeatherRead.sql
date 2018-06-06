/* This script fetches a weather data row from the transformed weather data for
 * each weather station to create a mock of an actual read.
 *
 * The mock is made to pick the weather closest to the date and time of which
 * the largest concentration of logs have, in hopes of creating a most optimal
 * visualization.
 */
drop table todays_weather_read_mock purge
;

create table todays_weather_read_mock as
select *
from transformed_weather_data
where trunc(log_date) = to_date('180511', 'YYMMDD')
and to_char(log_date, 'HH24') >= '11'
and to_char(log_date, 'MI') < 50
order by log_date
fetch first 7 rows only
;