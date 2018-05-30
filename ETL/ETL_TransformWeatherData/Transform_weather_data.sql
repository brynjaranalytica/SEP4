--------------------------------------------------------------------------------------
-- 1_Transform_Weather_Columns
--------------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------------
-- 2_Transform_Weather_Timestamp
--------------------------------------------------------------------------------------
drop table TRANSFORM_WEATHER_TIMESTAMP purge;

-- Separate the timestamp into date and time ready to analyze
create table TRANSFORM_WEATHER_TIMESTAMP as (select *
                                  from TRANSFORM_WEATHER_COLUMNS where 1 = 0); 
                                 
alter table TRANSFORM_WEATHER_TIMESTAMP
  drop column time_stamp;
       
alter table TRANSFORM_WEATHER_TIMESTAMP 
  add (
    log_date    DATE,
    log_hour    NUMBER(2, 0),
    log_minute  NUMBER(2, 0),
    log_second  NUMBER(2, 0)
  );

-- The timestamp is never missing
insert into TRANSFORM_WEATHER_TIMESTAMP
  select station
        , surface_temperature_fahrenheit
        , dew_point_temperature_fahrenheit
        , wind_direction_degrees
        , wind_speed_knots
        , pressure_altimeter_inches
        , visibility_miles
        , sky_level_1_coverage
        , sky_level_1_altitude_feet
        , to_date(time_stamp, 'YYYY-MM-DD HH24:MI')
        , extract(hour from cast (to_date(time_stamp, 'YYYY-MM-DD HH24:MI') AS TIMESTAMP))
        , extract(minute from cast (to_date(time_stamp, 'YYYY-MM-DD HH24:MI') AS TIMESTAMP))                                
        , extract(second from cast (to_date(time_stamp, 'YYYY-MM-DD HH24:MI') AS TIMESTAMP))                         
    from TRANSFORM_WEATHER_COLUMNS;                      

--------------------------------------------------------------------------------------
-- 3_Transform_Weather_Wind
--------------------------------------------------------------------------------------
drop table TRANSFORM_WEATHER_WIND purge;

-- Turn the wind degrees into a direction
-- Validate wind direction
-- Change the datatypes of the wind direction and wind speed columns
-- Validate wind speed
create table TRANSFORM_WEATHER_WIND as (select *
                                  from TRANSFORM_WEATHER_TIMESTAMP where 1 = 0); 

alter table TRANSFORM_WEATHER_WIND
rename column wind_direction_degrees to wind_direction
;

alter table TRANSFORM_WEATHER_WIND
modify (
        wind_direction varchar2(4)
      , wind_speed_knots number(6,0)
);

insert into TRANSFORM_WEATHER_WIND
  select station
        , surface_temperature_fahrenheit
        , dew_point_temperature_fahrenheit
        , CASE 
            WHEN wind_direction_degrees = 'M'
              THEN 'NULL'
            WHEN (ROUND(TO_NUMBER(wind_direction_degrees, '999.99')) >= 337 and ROUND(TO_NUMBER(wind_direction_degrees, '999.99')) <= 360)
              or (ROUND(TO_NUMBER(wind_direction_degrees, '999.99')) >= 0 and ROUND(TO_NUMBER(wind_direction_degrees, '999.99')) < 22) 
                THEN 'N'
            WHEN ROUND(TO_NUMBER(wind_direction_degrees, '999.99')) >= 22
              and ROUND(TO_NUMBER(wind_direction_degrees, '999.99')) < 67
                THEN 'NE'
            WHEN ROUND(TO_NUMBER(wind_direction_degrees, '999.99')) >= 67
              and ROUND(TO_NUMBER(wind_direction_degrees, '999.99')) < 112
                THEN 'E'
            WHEN ROUND(TO_NUMBER(wind_direction_degrees, '999.99')) >= 112 
              and ROUND(TO_NUMBER(wind_direction_degrees, '999.99')) < 157
                THEN 'SE'
            WHEN ROUND(TO_NUMBER(wind_direction_degrees, '999.99')) >= 157
            and ROUND(TO_NUMBER(wind_direction_degrees, '999.99')) < 202
              THEN 'S'
            WHEN ROUND(TO_NUMBER(wind_direction_degrees, '999.99')) >= 202
            and ROUND(TO_NUMBER(wind_direction_degrees, '999.99')) < 247
              THEN 'SW'
            WHEN ROUND(TO_NUMBER(wind_direction_degrees, '999.99')) >= 247
            and ROUND(TO_NUMBER(wind_direction_degrees, '999.99')) < 292
              THEN 'W'
            WHEN ROUND(TO_NUMBER(wind_direction_degrees, '999.99')) >= 292
            and ROUND(TO_NUMBER(wind_direction_degrees, '999.99')) < 337
              THEN 'NW'
            END
        , CASE
            WHEN wind_speed_knots = 'M'
              THEN -1
            ELSE
              ROUND(TO_NUMBER(wind_speed_knots, '999999.99999'), 0)
          END
        , pressure_altimeter_inches
        , visibility_miles
        , sky_level_1_coverage
        , sky_level_1_altitude_feet
        , log_date
        , log_hour
        , log_minute
        , log_second
    FROM TRANSFORM_WEATHER_TIMESTAMP;

--------------------------------------------------------------------------------------
-- 4_Transform_Weather_Temperature
--------------------------------------------------------------------------------------
drop table TRANSFORM_WEATHER_TEMPERATURE purge;

-- Change the datatypes of the surface temperature and dew point temperature columns
-- Validate surface temperature
-- Validate dew point temperature
create table TRANSFORM_WEATHER_TEMPERATURE as (select *
                                  from TRANSFORM_WEATHER_WIND where 1 = 0); 

ALTER TABLE TRANSFORM_WEATHER_TEMPERATURE
  MODIFY (
    surface_temperature_fahrenheit number(6,0),
    dew_point_temperature_fahrenheit number(6,0)
  );

insert into TRANSFORM_WEATHER_TEMPERATURE
  select station
        , CASE
            WHEN surface_temperature_fahrenheit = 'M'
              THEN -1
            ELSE
              ROUND(TO_NUMBER(surface_temperature_fahrenheit, '999999.99999'), 0)
          END
        , CASE
            WHEN dew_point_temperature_fahrenheit = 'M'
              THEN -1
            ELSE
              ROUND(TO_NUMBER(dew_point_temperature_fahrenheit, '999999.99999'), 0)
          END
        , wind_direction
        , wind_speed_knots
        , pressure_altimeter_inches
        , visibility_miles
        , sky_level_1_coverage
        , sky_level_1_altitude_feet
        , log_date
        , log_hour
        , log_minute
        , log_second
    from TRANSFORM_WEATHER_WIND;

--------------------------------------------------------------------------------------
-- 5_Transform_Weather_PressureAltitude
--------------------------------------------------------------------------------------
drop table TRANSFORM_WEATHER_PRESSURE purge;

-- Change the datatype of the pressure altitude column
-- Probably should convert to feet
-- Validate pressure altitude
-- is it the pressure altitude
create table TRANSFORM_WEATHER_PRESSURE as (select *
                                  from TRANSFORM_WEATHER_TEMPERATURE where 1 = 0); 

ALTER TABLE TRANSFORM_WEATHER_PRESSURE
 MODIFY (pressure_altimeter_inches number(6,0));

insert into TRANSFORM_WEATHER_PRESSURE
  select station
        , surface_temperature_fahrenheit
        , dew_point_temperature_fahrenheit
        , wind_direction
        , wind_speed_knots
        , CASE
            WHEN pressure_altimeter_inches = 'M'
              THEN -1
            ELSE
              ROUND(TO_NUMBER(pressure_altimeter_inches, '999999.99999'), 0)
          END
        , visibility_miles
        , sky_level_1_coverage
        , sky_level_1_altitude_feet
        , log_date
        , log_hour
        , log_minute
        , log_second
    from TRANSFORM_WEATHER_TEMPERATURE;

--------------------------------------------------------------------------------------
-- 6_Transform_Weather_Visibility
--------------------------------------------------------------------------------------
drop table TRANSFORM_WEATHER_VISIBILITY purge;

-- Change the datatype of the visibility column
-- Validate visibility
create table TRANSFORM_WEATHER_VISIBILITY as (select *
                                  from TRANSFORM_WEATHER_PRESSURE where 1 = 0); 

ALTER TABLE TRANSFORM_WEATHER_VISIBILITY
 MODIFY (visibility_miles number(6,0));
 
insert into TRANSFORM_WEATHER_VISIBILITY
  select station
        , surface_temperature_fahrenheit
        , dew_point_temperature_fahrenheit
        , wind_direction
        , wind_speed_knots
        , pressure_altimeter_inches
        , CASE
            WHEN visibility_miles = 'M'
              THEN -1
            ELSE
              ROUND(TO_NUMBER(visibility_miles, '999999.99999'), 0)
          END
        , sky_level_1_coverage
        , sky_level_1_altitude_feet
        , log_date
        , log_hour
        , log_minute
        , log_second
    from TRANSFORM_WEATHER_PRESSURE;

--------------------------------------------------------------------------------------
-- 7_Transform_Weather_Clouds
--------------------------------------------------------------------------------------
drop table TRANSFORM_WEATHER_CLOUDS purge;

-- Change the datatypes of the cloud coverage and cloud altitude columns
-- Validate cloud coverage
-- Validate cloud altitude
create table TRANSFORM_WEATHER_CLOUDS as (select *
                                  from TRANSFORM_WEATHER_VISIBILITY where 1 = 0); 

ALTER TABLE TRANSFORM_WEATHER_CLOUDS
 MODIFY (
    sky_level_1_coverage varchar2(4),
    sky_level_1_altitude_feet number(13)
  );
 
insert into TRANSFORM_WEATHER_CLOUDS
  select station
        , surface_temperature_fahrenheit
        , dew_point_temperature_fahrenheit
        , wind_direction
        , wind_speed_knots
        , pressure_altimeter_inches
        , visibility_miles
        , CASE
            WHEN sky_level_1_coverage = 'M' or sky_level_1_coverage = '///'
              THEN 'NULL'
            ELSE
              sky_level_1_coverage
          END
        , CASE
            WHEN sky_level_1_altitude_feet = 'M'
              THEN -1
            ELSE
              ROUND(TO_NUMBER(sky_level_1_altitude_feet, '999999.99999'), 0)
          END
        , log_date
        , log_hour
        , log_minute
        , log_second
    from TRANSFORM_WEATHER_VISIBILITY;

--------------------------------------------------------------------------------------
-- 8_Transformed_Weather_Data
--------------------------------------------------------------------------------------
drop table TRANSFORMED_WEATHER_DATA purge;

-- Last step of transforming the weather data
-- Put all of the transformed data in one table where
-- all columns have the correct datatype and validated contents
create table TRANSFORMED_WEATHER_DATA as (select *
                                  from TRANSFORM_WEATHER_CLOUDS where 1 = 0); 

-- good thing it's all fine
-- bad thing is that we don't have a PK
-- this doesn't work because there are duplicate values
-- seconds are always 0
-- ALTER TABLE TRANSFORM_WEATHER_DONE
-- ADD CONSTRAINT TransformWeatherDonePK PRIMARY KEY (station, log_date, log_hour, log_minute, log_second);

insert into TRANSFORMED_WEATHER_DATA
  select * from TRANSFORM_WEATHER_CLOUDS;

commit;