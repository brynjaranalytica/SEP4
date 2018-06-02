/* This script prepares the joined igc log and weather data for loading.
 * If there are duplicate surrogate keys in the Transform_IGC_7_Join_Weather_Data
 * that means that 2 records of weather data were found for the log record.
 * A log record should be matched with only one weather data record, otherwise 
 * in the Transform_IGC_7_Join_Weather_Data there will be 2 records - the same 
 * log data joined with two different weather records (the values in the weather 
 * records is almost the same, the only difference between them is in the minute 
 * that they were created) - which would cause an error (duplicate values) when 
 * loading the data in the F_Movement table.
 * 
 * To solve this problem, one of the duplicate records is simply dropped. Since the
 * records are nearly identical, no loss of data occurs because we still have one of them.
 *
 * Past transformation: Transform_IGC_7_Join_Weather_Data
 */
 drop table TRANSFORM_IGC_8_PREAPARE_FOR_LOAD;
 
 create table TRANSFORM_IGC_8_PREAPARE_FOR_LOAD as (select *
                                  from TRANSFORM_IGC_7_JOIN_WEATHER_DATA where 1 = 0);
 
 -- Insert records with non-duplicate surrogate keys
 insert into TRANSFORM_IGC_8_PREAPARE_FOR_LOAD                       
  select * from TRANSFORM_IGC_7_JOIN_WEATHER_DATA
  where SURROGATE_KEY not in (select SURROGATE_KEY from TRANSFORM_IGC_7_JOIN_WEATHER_DATA
                              group by SURROGATE_KEY
                              having count(SURROGATE_KEY) > 1)
 ;
 
 -- Insert only one of each record that has a duplicate surrogate key
 begin
  for r in (select SURROGATE_KEY from TRANSFORM_IGC_7_JOIN_WEATHER_DATA
            group by SURROGATE_KEY
            having count(SURROGATE_KEY) > 1)
  loop
    insert into TRANSFORM_IGC_8_PREAPARE_FOR_LOAD 
      select * from TRANSFORM_IGC_7_JOIN_WEATHER_DATA where surrogate_key = r.SURROGATE_KEY FETCH FIRST 1 ROWS ONLY;
  end loop;
 end;
 
 --should be 560737
 select COUNT(*) from TRANSFORM_IGC_8_PREAPARE_FOR_LOAD;
 
 --should return no result
 select SURROGATE_KEY from TRANSFORM_IGC_8_PREAPARE_FOR_LOAD
 group by SURROGATE_KEY
 having count(SURROGATE_KEY) > 1
 ;
 