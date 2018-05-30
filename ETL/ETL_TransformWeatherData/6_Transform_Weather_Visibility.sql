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

commit;
/
exit;