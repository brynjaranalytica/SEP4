/* This script joins the igc log data together with the transformed weather
 * data. This is done by first figuring out which weather data is the best match
 * for the given row in the log data. The best match is determined by the
 * closest weather station of the grid cell the log data points to, and also
 * the closest time.
 *
 * There is much room for improvement.
 *
 * Past transformation: Transform_IGC_6_Fetch_Grid_Cell_Id,
 *                      8_Transformed_Weather_data
 * Next transformation: ...
 */
drop table date_differences
;

create table date_differences as
select a.surrogate_key as igc_key
     , b.surrogate_key as weather_key
     , (abs(a.start_date_time_of_log - b.log_date)) * 24 * 60 as date_difference_in_minutes
from transform_igc_6_fetch_grid_cell_id a, transformed_weather_data b
where b.log_date > to_date('2016-01-01', 'YYYY-MM-DD')
  and a.nearest_weather_station = b.station
;

drop table least_difference
;

create table least_difference as
select *
from date_differences a
where date_difference_in_minutes <=
(select min(date_difference_in_minutes)
from date_differences b
where b.igc_key = a.igc_key)
;

drop table transform_igc_7_join_weather_data
;

create table transform_igc_7_join_weather_data as
select *
from transform_igc_6_fetch_grid_cell_id a
join least_difference b on (a.surrogate_key = b.igc_key)
join transformed_weather_data c on (b.weather_key = c.surrogate_key)
;