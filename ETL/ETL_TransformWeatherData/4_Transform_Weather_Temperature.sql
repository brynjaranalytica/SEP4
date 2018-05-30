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

commit;
/
exit;
