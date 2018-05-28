create table ETL_WEATHER_DATA_IMPORTANT_COLUMNS as (select *
                                    from EXTERNAL_WEATHER_DATA where 1 = 0);
                                    
alter table ETL_WEATHER_DATA_IMPORTANT_COLUMNS
  DROP COLUMN longitude;
alter table ETL_WEATHER_DATA_IMPORTANT_COLUMNS
  DROP COLUMN latitude;
alter table ETL_WEATHER_DATA_IMPORTANT_COLUMNS
  DROP COLUMN relative_humidity_percentage;
alter table ETL_WEATHER_DATA_IMPORTANT_COLUMNS
  DROP COLUMN one_hour_precipitation_inches;
alter table ETL_WEATHER_DATA_IMPORTANT_COLUMNS
  DROP COLUMN sky_level_2_coverage;
alter table ETL_WEATHER_DATA_IMPORTANT_COLUMNS
  DROP COLUMN sky_level_3_coverage; 
alter table ETL_WEATHER_DATA_IMPORTANT_COLUMNS
  DROP COLUMN sky_level_4_coverage;
alter table ETL_WEATHER_DATA_IMPORTANT_COLUMNS
  DROP COLUMN sky_level_2_altitude_feet;
alter table ETL_WEATHER_DATA_IMPORTANT_COLUMNS
  DROP COLUMN sky_level_3_altitude_feet;
alter table ETL_WEATHER_DATA_IMPORTANT_COLUMNS
  DROP COLUMN sky_level_4_altitude_feet;
alter table ETL_WEATHER_DATA_IMPORTANT_COLUMNS
  DROP COLUMN sea_level_pressure_millibar;
alter table ETL_WEATHER_DATA_IMPORTANT_COLUMNS
  DROP COLUMN wind_gust_knots;

select * from ETL_WEATHER_DATA_IMPORTANT_COLUMNS;


insert into ETL_WEATHER_DATA_IMPORTANT_COLUMNS 
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
  from external_weather_data;
  
  

