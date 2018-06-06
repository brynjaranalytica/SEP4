/* This script mocks the weather at different times to illustrate how the 
 * visualization changes depending on the current weather conditions.
 */
 
-- Mocks a summer day, also the primary mock used for showcasing the project.
drop table weather_mock_1_day purge
;

create table weather_mock_1_day as
select *
from transformed_weather_data
where trunc(log_date) = to_date('180511', 'YYMMDD')
and to_char(log_date, 'HH24') >= '11'
and to_char(log_date, 'MI') < 50
order by log_date
fetch first 7 rows only
;

-- Mocks the same day at night
drop table weather_mock_2_night
;

create table weather_mock_2_night as
select *
from transformed_weather_data
where trunc(log_date) = to_date('180511', 'YYMMDD')
and to_char(log_date, 'HH24') >= '23'
and to_char(log_date, 'MI') < 50
and station != 'EKVD'
order by log_date
fetch first 7 rows only
;

-- Mocks the same time of day as 1 but during the winter.
drop table weather_mock_3_winter
;

create table weather_mock_3_winter as
select *
from transformed_weather_data
where trunc(log_date) = to_date('171205', 'YYMMDD')
and to_char(log_date, 'HH24') >= '23'
and to_char(log_date, 'MI') < 50
and station != 'EKVD'
order by log_date
fetch first 7 rows only
;

-- Analyses are run for each mock to show different results

-- Mock 1
drop table thermal_analysis_accepted_sample purge
;

create table thermal_analysis_accepted_sample as
select facts.*
from weather_mock_1_day current_weather
   , f_movement facts
   , d_gridcell
   , d_surfacetemperature
   , d_dewpointtemperature
   , d_winddirection
   , d_windspeed
   , d_visibility
   , d_cloudcoverage
   , d_cloudaltitude
where 
   -- pair with reading from nearest station
      facts.grid_id = d_gridcell.grid_cell_id
  and d_gridcell.nearest_weather_station = current_weather.station
   
   -- surface temperature
  and facts.surface_temperature_id = d_surfacetemperature.surface_temperature_id
  and d_surfacetemperature.surface_temperature_fahrenheit between
      current_weather.surface_temperature_fahrenheit - (select surface_temperature from weather_condition_margins) and
      current_weather.surface_temperature_fahrenheit + (select surface_temperature from weather_condition_margins)
      
   -- dew point temperature   
  and facts.dew_point_temperature_id = d_dewpointtemperature.dew_point_temperature_id
  and d_dewpointtemperature.dew_point_temperature_fahrenheit between
      current_weather.dew_point_temperature_fahrenheit - (select dew_point_temperature from weather_condition_margins) and
      current_weather.dew_point_temperature_fahrenheit + (select dew_point_temperature from weather_condition_margins)
      
   -- wind direction 
   and facts.wind_direction_id = d_winddirection.wind_direction_id
   --and d_winddirection.direction = current_weather.wind_direction
   
   -- wind speed
   and facts.wind_speed_id = d_windspeed.wind_speed_id
   and d_windspeed.speed_knots between
       current_weather.wind_speed_knots - (select wind_speed from weather_condition_margins) and
       current_weather.wind_speed_knots + (select wind_speed from weather_condition_margins)
       
   -- visibility
   and facts.visibility_id = d_visibility.visibility_id
   and d_visibility.visibility between
       current_weather.visibility_miles - (select visibility from weather_condition_margins) and
       current_weather.visibility_miles + (select visibility from weather_condition_margins)
       
   -- cloud coverage
   and facts.cloud_coverage_id = d_cloudcoverage.cloud_coverage_id
   --and d_cloudcoverage.cloud_coverage in (current_weather.sky_level_1_coverage, 'NULL')
    
   -- cloud altitude
   and facts.cloud_altitude_id = d_cloudaltitude.cloud_altitude_id
   and d_cloudaltitude.cloud_height between
       current_weather.sky_level_1_altitude_feet - (select cloud_altitude from weather_condition_margins) and
       current_weather.sky_level_1_altitude_feet + (select cloud_altitude from weather_condition_margins)
;

drop table thermal_analysis_probability purge
; 

create table thermal_analysis_probability as 
select all_delta_altitudes.grid_id as grid_cell_id
     , positive_delta_altitudes.row_count/all_delta_altitudes.row_count as thermal_probability
     , all_delta_altitudes.row_count as probability_sample_size_all
     , positive_delta_altitudes.row_count as probability_sample_size_positives
from (select grid_id
           , count(grid_id) as row_count
      from thermal_analysis_accepted_sample 
      group by grid_id) all_delta_altitudes
   , (select grid_id
           , count(grid_id) as row_count
      from thermal_analysis_accepted_sample 
      where delta_altitude > 0
      group by grid_id) positive_delta_altitudes
where all_delta_altitudes.grid_id = positive_delta_altitudes.grid_id
;

drop table thermal_analysis_strength purge
;
 
create table thermal_analysis_strength as 
select grid_id as grid_cell_id
     , avg(delta_altitude) as thermal_strength
     , count(grid_id) as strength_sample_size
from thermal_analysis_accepted_sample
where delta_altitude > 0
group by grid_id
;

drop table thermal_analysis_coordinates purge
;
 
create table thermal_analysis_coordinates as
select grid_cell_id
     , latitude_center as latitude
     , longitude_center as longitude
from d_gridcell
;

drop table thermal_analysis_full purge
;

create table thermal_analysis_full as
select d_gridcell.grid_cell_id
     , latitude
     , longitude
     , thermal_probability
     , probability_sample_size_all
     , probability_sample_size_positives
     , thermal_strength
     , strength_sample_size
from d_gridcell
   , thermal_analysis_coordinates
   , thermal_analysis_probability
   , thermal_analysis_strength
where d_gridcell.grid_cell_id = thermal_analysis_coordinates.grid_cell_id 
  and d_gridcell.grid_cell_id = thermal_analysis_probability.grid_cell_id
  and d_gridcell.grid_cell_id = thermal_analysis_strength.grid_cell_id
;

drop table weather_mock_1_day_result purge
;

create table weather_mock_1_day_result as
select latitude
     , longitude
     , thermal_probability
     , thermal_strength
from thermal_analysis_full
where strength_sample_size > 10 -- minimum sample size
;

-- Mock 2
drop table thermal_analysis_accepted_sample purge
;

create table thermal_analysis_accepted_sample as
select facts.*
from weather_mock_2_night current_weather
   , f_movement facts
   , d_gridcell
   , d_surfacetemperature
   , d_dewpointtemperature
   , d_winddirection
   , d_windspeed
   , d_visibility
   , d_cloudcoverage
   , d_cloudaltitude
where 
   -- pair with reading from nearest station
      facts.grid_id = d_gridcell.grid_cell_id
  and d_gridcell.nearest_weather_station = current_weather.station
   
   -- surface temperature
  and facts.surface_temperature_id = d_surfacetemperature.surface_temperature_id
  and d_surfacetemperature.surface_temperature_fahrenheit between
      current_weather.surface_temperature_fahrenheit - (select surface_temperature from weather_condition_margins) and
      current_weather.surface_temperature_fahrenheit + (select surface_temperature from weather_condition_margins)
      
   -- dew point temperature   
  and facts.dew_point_temperature_id = d_dewpointtemperature.dew_point_temperature_id
  and d_dewpointtemperature.dew_point_temperature_fahrenheit between
      current_weather.dew_point_temperature_fahrenheit - (select dew_point_temperature from weather_condition_margins) and
      current_weather.dew_point_temperature_fahrenheit + (select dew_point_temperature from weather_condition_margins)
      
   -- wind direction 
   and facts.wind_direction_id = d_winddirection.wind_direction_id
   --and d_winddirection.direction = current_weather.wind_direction
   
   -- wind speed
   and facts.wind_speed_id = d_windspeed.wind_speed_id
   and d_windspeed.speed_knots between
       current_weather.wind_speed_knots - (select wind_speed from weather_condition_margins) and
       current_weather.wind_speed_knots + (select wind_speed from weather_condition_margins)
       
   -- visibility
   and facts.visibility_id = d_visibility.visibility_id
   and d_visibility.visibility between
       current_weather.visibility_miles - (select visibility from weather_condition_margins) and
       current_weather.visibility_miles + (select visibility from weather_condition_margins)
       
   -- cloud coverage
   and facts.cloud_coverage_id = d_cloudcoverage.cloud_coverage_id
   --and d_cloudcoverage.cloud_coverage in (current_weather.sky_level_1_coverage, 'NULL')
    
   -- cloud altitude
   and facts.cloud_altitude_id = d_cloudaltitude.cloud_altitude_id
   and d_cloudaltitude.cloud_height between
       current_weather.sky_level_1_altitude_feet - (select cloud_altitude from weather_condition_margins) and
       current_weather.sky_level_1_altitude_feet + (select cloud_altitude from weather_condition_margins)
;

drop table thermal_analysis_probability purge
; 

create table thermal_analysis_probability as 
select all_delta_altitudes.grid_id as grid_cell_id
     , positive_delta_altitudes.row_count/all_delta_altitudes.row_count as thermal_probability
     , all_delta_altitudes.row_count as probability_sample_size_all
     , positive_delta_altitudes.row_count as probability_sample_size_positives
from (select grid_id
           , count(grid_id) as row_count
      from thermal_analysis_accepted_sample 
      group by grid_id) all_delta_altitudes
   , (select grid_id
           , count(grid_id) as row_count
      from thermal_analysis_accepted_sample 
      where delta_altitude > 0
      group by grid_id) positive_delta_altitudes
where all_delta_altitudes.grid_id = positive_delta_altitudes.grid_id
;

drop table thermal_analysis_strength purge
;
 
create table thermal_analysis_strength as 
select grid_id as grid_cell_id
     , avg(delta_altitude) as thermal_strength
     , count(grid_id) as strength_sample_size
from thermal_analysis_accepted_sample
where delta_altitude > 0
group by grid_id
;

drop table thermal_analysis_coordinates purge
;
 
create table thermal_analysis_coordinates as
select grid_cell_id
     , latitude_center as latitude
     , longitude_center as longitude
from d_gridcell
;

drop table thermal_analysis_full purge
;

create table thermal_analysis_full as
select d_gridcell.grid_cell_id
     , latitude
     , longitude
     , thermal_probability
     , probability_sample_size_all
     , probability_sample_size_positives
     , thermal_strength
     , strength_sample_size
from d_gridcell
   , thermal_analysis_coordinates
   , thermal_analysis_probability
   , thermal_analysis_strength
where d_gridcell.grid_cell_id = thermal_analysis_coordinates.grid_cell_id 
  and d_gridcell.grid_cell_id = thermal_analysis_probability.grid_cell_id
  and d_gridcell.grid_cell_id = thermal_analysis_strength.grid_cell_id
;

drop table weather_mock_2_night_result purge
;

create table weather_mock_2_night_result as
select latitude
     , longitude
     , thermal_probability
     , thermal_strength
from thermal_analysis_full
where strength_sample_size > 10 -- minimum sample size
;

-- Mock 3
drop table thermal_analysis_accepted_sample purge
;

create table thermal_analysis_accepted_sample as
select facts.*
from weather_mock_3_winter current_weather
   , f_movement facts
   , d_gridcell
   , d_surfacetemperature
   , d_dewpointtemperature
   , d_winddirection
   , d_windspeed
   , d_visibility
   , d_cloudcoverage
   , d_cloudaltitude
where 
   -- pair with reading from nearest station
      facts.grid_id = d_gridcell.grid_cell_id
  and d_gridcell.nearest_weather_station = current_weather.station
   
   -- surface temperature
  and facts.surface_temperature_id = d_surfacetemperature.surface_temperature_id
  and d_surfacetemperature.surface_temperature_fahrenheit between
      current_weather.surface_temperature_fahrenheit - (select surface_temperature from weather_condition_margins) and
      current_weather.surface_temperature_fahrenheit + (select surface_temperature from weather_condition_margins)
      
   -- dew point temperature   
  and facts.dew_point_temperature_id = d_dewpointtemperature.dew_point_temperature_id
  and d_dewpointtemperature.dew_point_temperature_fahrenheit between
      current_weather.dew_point_temperature_fahrenheit - (select dew_point_temperature from weather_condition_margins) and
      current_weather.dew_point_temperature_fahrenheit + (select dew_point_temperature from weather_condition_margins)
      
   -- wind direction 
   and facts.wind_direction_id = d_winddirection.wind_direction_id
   --and d_winddirection.direction = current_weather.wind_direction
   
   -- wind speed
   and facts.wind_speed_id = d_windspeed.wind_speed_id
   and d_windspeed.speed_knots between
       current_weather.wind_speed_knots - (select wind_speed from weather_condition_margins) and
       current_weather.wind_speed_knots + (select wind_speed from weather_condition_margins)
       
   -- visibility
   and facts.visibility_id = d_visibility.visibility_id
   and d_visibility.visibility between
       current_weather.visibility_miles - (select visibility from weather_condition_margins) and
       current_weather.visibility_miles + (select visibility from weather_condition_margins)
       
   -- cloud coverage
   and facts.cloud_coverage_id = d_cloudcoverage.cloud_coverage_id
   --and d_cloudcoverage.cloud_coverage in (current_weather.sky_level_1_coverage, 'NULL')
    
   -- cloud altitude
   and facts.cloud_altitude_id = d_cloudaltitude.cloud_altitude_id
   and d_cloudaltitude.cloud_height between
       current_weather.sky_level_1_altitude_feet - (select cloud_altitude from weather_condition_margins) and
       current_weather.sky_level_1_altitude_feet + (select cloud_altitude from weather_condition_margins)
;

drop table thermal_analysis_probability purge
; 

create table thermal_analysis_probability as 
select all_delta_altitudes.grid_id as grid_cell_id
     , positive_delta_altitudes.row_count/all_delta_altitudes.row_count as thermal_probability
     , all_delta_altitudes.row_count as probability_sample_size_all
     , positive_delta_altitudes.row_count as probability_sample_size_positives
from (select grid_id
           , count(grid_id) as row_count
      from thermal_analysis_accepted_sample 
      group by grid_id) all_delta_altitudes
   , (select grid_id
           , count(grid_id) as row_count
      from thermal_analysis_accepted_sample 
      where delta_altitude > 0
      group by grid_id) positive_delta_altitudes
where all_delta_altitudes.grid_id = positive_delta_altitudes.grid_id
;

drop table thermal_analysis_strength purge
;
 
create table thermal_analysis_strength as 
select grid_id as grid_cell_id
     , avg(delta_altitude) as thermal_strength
     , count(grid_id) as strength_sample_size
from thermal_analysis_accepted_sample
where delta_altitude > 0
group by grid_id
;

drop table thermal_analysis_coordinates purge
;
 
create table thermal_analysis_coordinates as
select grid_cell_id
     , latitude_center as latitude
     , longitude_center as longitude
from d_gridcell
;

drop table thermal_analysis_full purge
;

create table thermal_analysis_full as
select d_gridcell.grid_cell_id
     , latitude
     , longitude
     , thermal_probability
     , probability_sample_size_all
     , probability_sample_size_positives
     , thermal_strength
     , strength_sample_size
from d_gridcell
   , thermal_analysis_coordinates
   , thermal_analysis_probability
   , thermal_analysis_strength
where d_gridcell.grid_cell_id = thermal_analysis_coordinates.grid_cell_id 
  and d_gridcell.grid_cell_id = thermal_analysis_probability.grid_cell_id
  and d_gridcell.grid_cell_id = thermal_analysis_strength.grid_cell_id
;

drop table weather_mock_3_winter_result purge
;

create table weather_mock_3_winter_result as
select latitude
     , longitude
     , thermal_probability
     , thermal_strength
from thermal_analysis_full
where strength_sample_size > 10 -- minimum sample size
;

commit;

-- Shows the result size
select count(*)
from weather_mock_1_day_result
union all
select count(*)
from weather_mock_2_night_result
union all
select count(*)
from weather_mock_3_winter_result
;