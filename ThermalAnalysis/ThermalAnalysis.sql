/* ThermalAnalysis.sql
 *
 * This script contains all the logic for the identification of thermals from
 * the facts in the dimensional model.
 *
 * Several characteristics, such as probability and strength of thermals, are
 * calculalted for each grid cell in the d_gridcell dimension.
 */
 
/* Weather dictated sample
 * Determines the accepted sample of facts to be used for analysis by comparing
 * with the most current weather read.
 *
 * Currently with a mock read.
 */
drop table thermal_analysis_accepted_sample purge
;

create table thermal_analysis_accepted_sample as
select facts.*
from todays_weather_read_mock current_weather
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
   and d_cloudcoverage.cloud_coverage in (current_weather.sky_level_1_coverage, 'NULL')
    
   -- cloud altitude
   and facts.cloud_altitude_id = d_cloudaltitude.cloud_altitude_id
   and d_cloudaltitude.cloud_height between
       current_weather.sky_level_1_altitude_feet - (select cloud_altitude from weather_condition_margins) and
       current_weather.sky_level_1_altitude_feet + (select cloud_altitude from weather_condition_margins)
;

/* Thermal probability query
 * Joins a count of all facts with a positive delta_altitude together with a 
 * count of all facts independent on delta_altitude for every grid cell and 
 * calculates the probability of a thermal as positive count out of total count.
 */
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

/* Thermal strength query
 * Calculates the strength as an average of positive delta_altitudes for every
 * grid cell.
 */
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

/* Coordinates query
 * Fetches the latitude and longitude centers for each grid cell.
 */
drop table thermal_analysis_coordinates purge
;
 
create table thermal_analysis_coordinates as
select grid_cell_id
     , latitude_center as latitude
     , longitude_center as longitude
from d_gridcell
;

/* Combined analysis
 * The seperate queries are joined together to form the complete thermal
 * analysis.
 */
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

/* Trimmed analysis
 * Removing certain columns columns to hide some details in the exportable
 * analysis.
 */
drop table thermal_analysis_exportable purge
;

create table thermal_analysis_exportable as
select latitude
     , longitude
     , thermal_probability
     , thermal_strength
from thermal_analysis_full
where strength_sample_size > 10 -- minimum sample size
;

commit;
-- leftovers, contains threshold example
/*
create table thermal_analysis as
select d_gridcell.latitude_center as latitude
     , d_gridcell.longitude_center as longitude
     , avg(f_movement.delta_altitude) as thermal_strength
     , count(f_movement.grid_id) as sample_size
from f_movement, d_gridcell
where f_movement.grid_id = d_gridcell.grid_cell_id
  and f_movement.delta_altitude > 0
group by d_gridcell.latitude_center, d_gridcell.longitude_center
/* threshold*//*
having avg(f_movement.delta_altitude) > (1 + 10 / sqrt(count(f_movement.grid_id)))
   and count(f_movement.grid_id) /*sample_size*//* > 10
;
*/
