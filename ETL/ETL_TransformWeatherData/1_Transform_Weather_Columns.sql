drop table TRANSFORM_WEATHER_COLUMNS purge;

-- Remove unnecessary columns from the weather data
create table TRANSFORM_WEATHER_COLUMNS as (select *
                                    from EXTERNAL_WEATHER_DATA where 1 = 0);
                                    
alter table TRANSFORM_WEATHER_COLUMNS
  drop column longitude;
alter table TRANSFORM_WEATHER_COLUMNS
  drop column latitude;
alter table TRANSFORM_WEATHER_COLUMNS
  drop column relative_humidity_percentage;
alter table TRANSFORM_WEATHER_COLUMNS
  drop column one_hour_precipitation_inches;
alter table TRANSFORM_WEATHER_COLUMNS
  drop column sky_level_2_coverage;
alter table TRANSFORM_WEATHER_COLUMNS
  drop column sky_level_3_coverage; 
alter table TRANSFORM_WEATHER_COLUMNS
  drop column sky_level_4_coverage;
alter table TRANSFORM_WEATHER_COLUMNS
  drop column sky_level_2_altitude_feet;
alter table TRANSFORM_WEATHER_COLUMNS
  drop column sky_level_3_altitude_feet;
alter table TRANSFORM_WEATHER_COLUMNS
  drop column sky_level_4_altitude_feet;
alter table TRANSFORM_WEATHER_COLUMNS
  drop column sea_level_pressure_millibar;
alter table TRANSFORM_WEATHER_COLUMNS
  drop column wind_gust_knots;

alter table TRANSFORM_WEATHER_COLUMNS
rename column timestamp to time_stamp;

insert into TRANSFORM_WEATHER_COLUMNS 
  select station
        , timestamp
        , surface_temperature_fahrenheit
        , dew_point_temperature_fahrenheit
        , wind_direction_degrees
        , wind_speed_knots
        , pressure_altimeter_inches
        , visibility_miles
        , sky_level_1_coverage
        , sky_level_1_altitude_feet
  from EXTERNAL_WEATHER_DATA;

commit;
/
exit;