drop table ETL_Weather_data_important_columns;

create table ETL_Weather_data_important_columns as (select *
                                    from EXTERNAL_WEATHER_DATA where 1 = 0);
                                    
alter table ETL_Weather_data_important_columns
  drop column longitude;
alter table ETL_Weather_data_important_columns
  drop column latitude;
alter table ETL_Weather_data_important_columns
  drop column relative_humidity_percentage;
alter table ETL_Weather_data_important_columns
  drop column one_hour_precipitation_inches;
alter table ETL_Weather_data_important_columns
  drop column sky_level_2_coverage;
alter table ETL_Weather_data_important_columns
  drop column sky_level_3_coverage; 
alter table ETL_Weather_data_important_columns
  drop column sky_level_4_coverage;
alter table ETL_Weather_data_important_columns
  drop column sky_level_2_altitude_feet;
alter table ETL_Weather_data_important_columns
  drop column sky_level_3_altitude_feet;
alter table ETL_Weather_data_important_columns
  drop column sky_level_4_altitude_feet;
alter table ETL_Weather_data_important_columns
  drop column sea_level_pressure_millibar;
alter table ETL_Weather_data_important_columns
  drop column wind_gust_knots;

insert into ETL_Weather_data_important_columns 
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


---------------------------------------------------------------------------------------------------------------------
create table ETL_WEATHER_DATA_CHANGED_DATATYPES as (select *
                                  from ETL_Weather_data_important_columns where 1 = 0); 
  
ALTER TABLE ETL_WEATHER_DATA_CHANGED_DATATYPES
  MODIFY (
    surface_temperature_fahrenheit number(6,0)
  );
  
ALTER TABLE ETL_WEATHER_DATA_CHANGED_DATATYPES
  MODIFY (
    dew_point_temperature_fahrenheit number(6,0)
  );
  
 ALTER TABLE ETL_WEATHER_DATA_CHANGED_DATATYPES
  MODIFY (
    dew_point_temperature_fahrenheit number(6,0)
  );
  
alter table ETL_WEATHER_DATA_CHANGED_DATATYPES 
rename column wind_direction_degrees to wind_direction;

ALTER TABLE ETL_WEATHER_DATA_CHANGED_DATATYPES
 MODIFY (
    wind_direction char(2)
  );

ALTER TABLE ETL_WEATHER_DATA_CHANGED_DATATYPES
 MODIFY (
    wind_speed_knots number(6,0)
  );
  
ALTER TABLE ETL_WEATHER_DATA_CHANGED_DATATYPES
 MODIFY (
    pressure_altimeter_inches number(6,0)
  );

ALTER TABLE ETL_WEATHER_DATA_CHANGED_DATATYPES
 MODIFY (
    visibility_miles number(6,0)
  );
  
ALTER TABLE ETL_WEATHER_DATA_CHANGED_DATATYPES
 MODIFY (
    sky_level_1_coverage varchar2(4)
  );
  
  ALTER TABLE ETL_WEATHER_DATA_CHANGED_DATATYPES
 MODIFY (
    sky_level_1_altitude_feet number(13)
  );

----------------------------------------------------------------------------------------
drop table ETL_Weather_data_Separate_Timestamp;

create table ETL_Weather_data_Separate_Timestamp as (select *
                                  from ETL_Weather_data_important_columns where 1 = 0); 
                                  
alter table ETL_Weather_data_Separate_Timestamp
  drop column timestamp;
       
alter table ETL_Weather_data_Separate_Timestamp 
  add (
    log_year    number(4, 0),
    log_month   NUMBER(2, 0),
    log_day     NUMBER(2, 0),
    log_hour    NUMBER(2, 0),
    log_minute  NUMBER(2, 0),
    log_second  NUMBER(2, 0)
  );

select * from ETL_WEATHER_DATA_SEPARATE_TIMESTAMP;
---- I am supposing that the timestamp is always set
--   I am not inserting into the audit table although i probably should
insert into ETL_WEATHER_DATA_SEPARATE_TIMESTAMP
  select station
        , surface_temperature_fahrenheit
        , dew_point_temperature_fahrenheit
        , wind_direction_degrees
        , wind_speed_knots
        , pressure_altimeter_inches
        , visibility_miles
        , sky_level_1_coverage
        , sky_level_1_altitude_feet
        , extract(year from cast(ETL_WEATHER_DATA_IMPORTANT_COLUMNS.TIMESTAMP as timestamp))
        , extract(month from cast(ETL_WEATHER_DATA_IMPORTANT_COLUMNS.TIMESTAMP as timestamp))
        , extract(day from cast(ETL_WEATHER_DATA_IMPORTANT_COLUMNS.TIMESTAMP as timestamp))
        , extract(hour from cast(ETL_WEATHER_DATA_IMPORTANT_COLUMNS.TIMESTAMP as timestamp))
        , extract(minute from cast(ETL_WEATHER_DATA_IMPORTANT_COLUMNS.TIMESTAMP as timestamp))                                
        , extract(second from cast(ETL_WEATHER_DATA_IMPORTANT_COLUMNS.TIMESTAMP as timestamp))                                
    from ETL_WEATHER_DATA_IMPORTANT_COLUMNS;                      
                                  
----------------------------------------------------------------------------------------------------------                    
drop table ETL_Weather_data_Transform_Wind_Direction;

create table ETL_Weather_data_Transform_Wind_Direction as (select *
                                  from ETL_WEATHER_DATA_SEPARATE_TIMESTAMP where 1 = 0); 

alter table ETL_Weather_data_Transform_Wind_Direction
rename column wind_direction_degrees to wind_direction
;

alter table ETL_Weather_data_Transform_Wind_Direction
modify (wind_direction varchar2(4));


insert into ETL_Weather_data_Transform_Wind_Direction
  select station
        , surface_temperature_fahrenheit
        , dew_point_temperature_fahrenheit
        , CASE 
            WHEN wind_direction_degrees = 'M'
              THEN 'NULL'
            WHEN (ROUND(TO_NUMBER(wind_direction_degrees, '999.99')) >= 337
              and ROUND(TO_NUMBER(wind_direction_degrees, '999.99')) < 22) 
              or ROUND(TO_NUMBER(wind_direction_degrees, '999.99')) = 0
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
        , wind_speed_knots
        , pressure_altimeter_inches
        , visibility_miles
        , sky_level_1_coverage
        , sky_level_1_altitude_feet
        , log_year
        , log_month
        , log_day
        , log_hour
        , log_minute
        , log_second
FROM ETL_WEATHER_DATA_SEPARATE_TIMESTAMP
;

-------------------------------------------------------------------------
drop table ETL_Weather_data_Transform_Wind_Speed;

create table ETL_Weather_data_Transform_Wind_Speed as (select *
                                  from ETL_WEATHER_DATA_TRANSFORM_WIND_DIRECTION where 1 = 0); 

alter table ETL_Weather_data_Transform_Wind_Speed
modify (wind_speed_knots number(6,3));
set autotrace on;

insert into ETL_Weather_data_Transform_Wind_Speed
  select station
        , surface_temperature_fahrenheit
        , dew_point_temperature_fahrenheit
        , wind_direction
        , CASE
            WHEN wind_speed_knots = 'M'
              THEN -1
            WHEN not wind_speed_knots = 'M'
              THEN TO_NUMBER(wind_speed_knots, '999.99')
          END
        , pressure_altimeter_inches
        , visibility_miles
        , sky_level_1_coverage
        , sky_level_1_altitude_feet
        , log_year
        , log_month
        , log_day
        , log_hour
        , log_minute
        , log_second
FROM ETL_Weather_data_Transform_Wind_Direction
;

select * from ETL_Weather_data_Transform_Wind_Speed;