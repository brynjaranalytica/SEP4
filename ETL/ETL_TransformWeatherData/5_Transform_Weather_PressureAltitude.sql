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

commit;
/
exit;
