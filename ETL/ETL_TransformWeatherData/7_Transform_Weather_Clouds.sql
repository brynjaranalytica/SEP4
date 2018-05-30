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

commit;
/
exit;