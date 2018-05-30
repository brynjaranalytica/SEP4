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

commit;                      
/
exit;

