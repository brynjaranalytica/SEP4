/* ThermalAnalysisWeatherConditionMargins.sql
 *
 * This script can be rerun to change the accepted margins of the different
 * weather parameters.
 *
 * Ideally the margins should be derived from feature analysis like anova
 * testing.
 */ 
drop table weather_condition_margins
;
 
create table weather_condition_margins as
select 10 as surface_temperature
     , 20 as dew_point_temperature
     , 10 as wind_speed
     , 100 as visibility
     , 4000 as cloud_altitude
from dual
;
 
/* Here are bunch of queries to see the count of each value in the ranges of
 * all weather condition dimensions. Can be used to get a rough idea of the
 * distribution of facts.
 */
-- group count of nearest weather stations
select b.nearest_weather_station, count(*)
from f_movement a, d_gridcell b
where a.grid_id = b.grid_cell_id
group by b.nearest_weather_station
;
 
-- group count of surface temperatures
select d_surfacetemperature.surface_temperature_fahrenheit, count(*)
from f_movement, d_surfacetemperature
where f_movement.surface_temperature_id = d_surfacetemperature.surface_temperature_id
group by d_surfacetemperature.surface_temperature_fahrenheit
;

-- group count of dew point temperatures
select b.dew_point_temperature_fahrenheit, count(*)
from f_movement a, d_dewpointtemperature b
where a.dew_point_temperature_id = b.dew_point_temperature_id
group by b.dew_point_temperature_fahrenheit
;

-- group count of wind direction
select b.direction, count(*)
from f_movement a, d_winddirection b
where a.wind_direction_id = b.wind_direction_id
group by b.direction
;

-- group count of wind direction
select b.speed_knots, count(*)
from f_movement a, d_windspeed b
where a.wind_speed_id = b.wind_speed_id
group by b.speed_knots
;

-- group count of visibility
select b.visibility, count(*)
from f_movement a, d_visibility b
where a.visibility_id = b.visibility_id
group by b.visibility
;

-- group count of cloud coverage
select b.cloud_coverage, count(*)
from f_movement a, d_cloudcoverage b
where a.cloud_coverage_id = b.cloud_coverage_id
group by b.cloud_coverage
;

-- group count of cloud altitude
select b.cloud_height, count(*)
from f_movement a, d_cloudaltitude b
where a.cloud_altitude_id = b.cloud_altitude_id
group by b.cloud_height
;