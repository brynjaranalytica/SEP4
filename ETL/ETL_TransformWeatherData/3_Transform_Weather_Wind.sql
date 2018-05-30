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

commit;
/
exit;