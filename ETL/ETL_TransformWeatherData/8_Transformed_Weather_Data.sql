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
/
exit;