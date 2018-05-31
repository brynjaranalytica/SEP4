drop table TRANSFORMED_WEATHER_DATA purge;

drop sequence sq_transformed_weather_data_surrogate_key
;
  
create sequence sq_transformed_weather_data_surrogate_key
  increment by 1
  start with 1
  cache 100
  nomaxvalue
;

-- Last step of transforming the weather data
-- Put all of the transformed data in one table where
-- all columns have the correct datatype and validated contents
create table TRANSFORMED_WEATHER_DATA as (select 0 as surrogate_key, TRANSFORM_WEATHER_CLOUDS.*
                                  from TRANSFORM_WEATHER_CLOUDS where 1 = 0); 
                                  
create index ix_transformed_weather_data_date on transformed_weather_data(log_date);
create index ix_transformed_weather_data_station on transformed_weather_data(station);

-- good thing it's all fine
-- bad thing is that we don't have a PK
-- this doesn't work because there are duplicate values
-- seconds are always 0
-- ALTER TABLE TRANSFORM_WEATHER_DONE
-- ADD CONSTRAINT TransformWeatherDonePK PRIMARY KEY (station, log_date, log_hour, log_minute, log_second);

insert into TRANSFORMED_WEATHER_DATA
  select sq_transformed_weather_data_surrogate_key.nextval as surrogate_key, TRANSFORM_WEATHER_CLOUDS.* from TRANSFORM_WEATHER_CLOUDS;

execute dbms_stats.gather_table_stats('SEP4', 'TRANSFORMED_WEATHER_DATA');

commit;
/
exit;