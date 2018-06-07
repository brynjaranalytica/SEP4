/* This script extracts all the prepared weather data stored in the PreparedFiles
 * directory of the WeatherDataPrepper.
 */

/* Directory and external table */
drop directory weather_data_location
;

create or replace directory weather_data_location as 'C:\SEP4\ETL\ETL_TransformWeatherData\WeatherDataPrepper\PreparedFiles'
;

grant read, write on directory weather_data_location to public
;

drop table external_weather_data
;

create table external_weather_data
(
  station                            varchar2(50)
, timestamp                          varchar2(50)
, longitude                          varchar2(50)
, latitude                           varchar2(50)
, surface_temperature_fahrenheit     varchar2(50)
, dew_point_temperature_fahrenheit   varchar2(50)
, relative_humidity_percentage       varchar2(50)
, wind_direction_degrees             varchar2(50)
, wind_speed_knots                   varchar2(50)
, one_hour_precipitation_inches      varchar2(50)
, pressure_altimeter_inches          varchar2(50)
, sea_level_pressure_millibar        varchar2(50)
, visibility_miles                   varchar2(50)
, wind_gust_knots                    varchar2(50)
, sky_level_1_coverage               varchar2(50)
, sky_level_2_coverage               varchar2(50)
, sky_level_3_coverage               varchar2(50)
, sky_level_4_coverage               varchar2(50)
, sky_level_1_altitude_feet          varchar2(50)
, sky_level_2_altitude_feet          varchar2(50)
, sky_level_3_altitude_feet          varchar2(50)
, sky_level_4_altitude_feet          varchar2(50)
)
organization external
(
  type oracle_loader
  default directory weather_data_location
  access parameters
  (
    records delimited by newline
    characterset WE8ISO8859P1
    string sizes are in characters
    badfile 'weather.bad'
    discardfile 'weather.dis'
    logfile 'weather.log'    
    fields terminated by ',' 
    optionally enclosed by '"'
  )
  location ('PreparedWeatherData.txt')
)
;