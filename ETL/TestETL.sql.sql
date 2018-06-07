/* TestETL.sql
 *
 * This script is a test framework with a line of tests on the transformation
 * process.
 *
 * The tests are stored in a table with a column 'result' dictating whether
 * the test passed or not.
 *
 * The table also contains information about other variables such as the input
 * and output table names of the transformation step and the condition the test
 * must pass.
 */
drop table test purge
;

create table test
(
  id                            varchar2(255)
, name                          varchar2(255)
, description                   varchar2(255)
, condition_text                varchar2(255)
, condition_logic               varchar2(255)
, input_table                   varchar2(255)
, output_table                  varchar2(255)
, test_parameter_1_description  varchar2(255)
, test_parameter_2_description  varchar2(255)
, test_parameter_3_description  varchar2(255)
, test_parameter_1              varchar2(255)
, test_parameter_2              varchar2(255)
, test_parameter_3              varchar2(255)
, result                        varchar2(255)
)
;

-- Test Transform_IGC_1_Format_Date_Time
insert into test
select '01-01' 
       as id

     , 'Transform_IGC_1_Format_Date_Time' 
       as name
     
     , 'Testing if raw time string and seperate year, month, day columns were' 
       || 'properly formatted into a date datatype' 
       as description
       
     , 'Count of rows where extraction of year, month, day, hour, minute,'
       || 'second from output are equal to the corresponding values in input'
       || 'should match the row count of both input and output tables'
       as condition_text
       
     , 'test_parameter_3 = test_parameter_1 '
       || 'and test_parameter_3 = test_parameter_2'
       as condition_logic
     
     , 'LOG_DATA_EXTRACT' 
       as input_table
     
     , 'TRANSFORM_IGC_1_FORMAT_DATE_TIME' 
       as output_table
       
     , 'Row count of input table'
       as test_parameter_1_description
       
     , 'Row count of output table'
       as test_parameter_2_description
       
     , 'Row count where extract of output date is equal to separate values in '
       || 'input table'
       as test_parameter_3_description
     
     , (select count(*) from log_data_extract) 
       as test_parameter_1
     
     , (select count(*) from transform_igc_1_format_date_time) 
       as test_parameter_2
     
     , (select count(*) from log_data_extract input
                           , transform_igc_1_format_date_time output
                        where input.surrogate_key = output.surrogate_key
                          and substr(extract(year from output.date_of_log), 3, 2) = input.year_of_log
                          and extract(month from output.date_of_log) = to_number(input.month_of_log)
                          and extract(day from output.date_of_log) = to_number(input.day_of_log)
                          -- hour, minute, second yet to be implemented
       ) 
       as test_parameter_3
     
     , null 
       as result
from dual
;

update test
set result = case
             when test_parameter_3 = test_parameter_1
              and test_parameter_3 = test_parameter_2
             then 'Passed'
             else 'Failed'
             end
where id = '01-01'
;

-- Test Transform_IGC_2_Connect_Coordinates
insert into test
select '02-01' 
       as id

     , 'Transform_IGC_2_Connect_Coordinates' 
       as name
     
     , 'Testing if coordinates of the source table were properly connected into'
       || 'a movements/vectors with delta values'
       as description
       
     , 'The difference in row count between the input and output tables should'
       || 'be equal to the number of files/flights processed, since there will'
       || 'be 1 less vector than for each flight than there are coordinates'
       as condition_text
       
     , 'test_parameter_1 - test_parameter_2 = test_parameter_3'
       as condition_logic
     
     , 'TRANSFORM_IGC_1_FORMAT_DATE_TIME' 
       as input_table
     
     , 'TRANSFORM_IGC_2_CONNECT_COORDINATES' 
       as output_table
     
     , 'Row count of input table'
       as test_parameter_1_description
       
     , 'Row count of output table'
       as test_parameter_2_description
       
     , 'Count of distinct source files/flights'
       as test_parameter_3_description
     
     , (select count(*) from transform_igc_1_format_date_time) 
       as test_parameter_1
     
     , (select count(*) from transform_igc_2_connect_coordinates) 
       as test_parameter_2
     
     , (select count(distinct(file_path)) from transform_igc_1_format_date_time)
       as test_parameter_3
     
     , null 
       as result
from dual
;

update test
set result = case
             when test_parameter_1 - test_parameter_2 = test_parameter_3
             then 'Passed'
             else 'Failed'
             end
where id = '02-01'
;

-- Test Transform_IGC_4_Split_To_Second_Segments
-- Is sum of delta time in input equal to row count in output
insert into test
select '04-01' 
       as id

     , 'Transform_IGC_4_Split_To_Second_Segments delta_time test' 
       as name
     
     , 'Testing if vectors were properly split into segments each with 1 second'
       || 'as delta time by looking at delta_time'
       as description
       
     , 'The row count of the output table should be equal to the sum of delta'
       || 'time in the input table'
       as condition_text
       
     , 'test_parameter_1 = test_parameter_2'
       as condition_logic
     
     , 'TRANSFORM_IGC_3_LATITUDE_LONGITUDE_AS_DECIMAL' 
       as input_table
     
     , 'TRANSFORM_IGC_4_SPLIT_TO_SECOND_SEGMENTS' 
       as output_table
     
     , 'Sum of delta_time in input table'
       as test_parameter_1_description
       
     , 'Row count of output table'
       as test_parameter_2_description
       
     , null
       as test_parameter_3_description
     
     , (select sum(delta_time) from transform_igc_3_latitude_longitude_as_decimal) 
       as test_parameter_1
     
     , (select count(*) from transform_igc_4_split_to_second_segments) 
       as test_parameter_2
     
     , null
       as test_parameter_3
     
     , null 
       as result
from dual
;

update test
set result = case
             when test_parameter_1 = test_parameter_2
             then 'Passed'
             else 'Failed'
             end
where id = '04-01'
;

-- Test Transform_IGC_4_Split_To_Second_Segments
-- Sum of delta_altitude should be the same for input and output tables
insert into test
select '04-02' 
       as id

     , 'Transform_IGC_4_Split_To_Second_Segments delta_altitude test' 
       as name
     
     , 'Testing if vectors were properly split into segments each with 1 second'
       || 'as delta time by looking at delta_altitude'
       as description
       
     , 'The sum of delta_altitude should be equal for both input and output '
       || 'when the sum for the output is rounded to nearest whole number'
       as condition_text
       
     , 'test_parameter_1 = test_parameter_2'
       as condition_logic
     
     , 'TRANSFORM_IGC_3_LATITUDE_LONGITUDE_AS_DECIMAL' 
       as input_table
     
     , 'TRANSFORM_IGC_4_SPLIT_TO_SECOND_SEGMENTS' 
       as output_table
     
     , 'Sum of delta_altitude in input table'
       as test_parameter_1_description
       
     , 'Sum of delta_altitude in output table rounded to nearest whole number'
       as test_parameter_2_description
       
     , null
       as test_parameter_3_description
     
     , (select sum(delta_altitude) from transform_igc_3_latitude_longitude_as_decimal) 
       as test_parameter_1
     
     , (select round(sum(delta_altitude)) from transform_igc_4_split_to_second_segments) 
       as test_parameter_2
     
     , null
       as test_parameter_3
     
     , null 
       as result
from dual
;

update test
set result = case
             when test_parameter_1 = test_parameter_2
             then 'Passed'
             else 'Failed'
             end
where id = '04-02'
;

-- Test Transform_IGC_5_Average_Latitude_Longitude
-- Sum of start latitude together with end latitude in input should be equal
-- to sum of average latitude times 2 in output
insert into test
select '05-01' 
       as id

     , 'Transform_IGC_5_Average_Latitude_Longitude latitude test' 
       as name
     
     , 'Testing if latitude was properly averaged in the transformation'
       as description
       
     , 'The sum of start_latitude plus end_latitude in input should be equal to'
       || ' the sum of average_latitude multiplied by 2 in the output'
       as condition_text
       
     , 'test_parameter_1 = test_parameter_2'
       as condition_logic
     
     , 'TRANSFORM_IGC_4_SPLIT_TO_SECOND_SEGMENTS' 
       as input_table
     
     , 'TRANSFORM_IGC_5_AVERAGE_LATITUDE_LONGITUDE' 
       as output_table
     
     , 'Sum of start_latitude plus end_latitude in input table'
       as test_parameter_1_description
       
     , 'Sum of average_latitude times 2 in output table'
       as test_parameter_2_description
       
     , null
       as test_parameter_3_description
     
     , (select round(sum(start_latitude + end_latitude),10) from transform_igc_4_split_to_second_segments) 
       as test_parameter_1
     
     , (select round(sum(average_latitude) * 2, 10) from transform_igc_5_average_latitude_longitude) 
       as test_parameter_2
     
     , null
       as test_parameter_3
     
     , null 
       as result
from dual
;

update test
set result = case
             when test_parameter_1 = test_parameter_2
             then 'Passed'
             else 'Failed'
             end
where id = '05-01'
;

-- Test Transform_IGC_5_Average_Latitude_Longitude
-- Sum of start latitude together with end latitude in input should be equal
-- to sum of average latitude times 2 in output
insert into test
select '05-02' 
       as id

     , 'Transform_IGC_5_Average_Latitude_Longitude longitude test' 
       as name
     
     , 'Testing if longitude was properly averaged in the transformation'
       as description
       
     , 'The sum of start_longitude plus end_longitude in input should be equal '
       || 'to the sum of average_latitude multiplied by 2 in the output'
       as condition_text
       
     , 'test_parameter_1 = test_parameter_2'
       as condition_logic
     
     , 'TRANSFORM_IGC_4_SPLIT_TO_SECOND_SEGMENTS' 
       as input_table
     
     , 'TRANSFORM_IGC_5_AVERAGE_LATITUDE_LONGITUDE' 
       as output_table
     
     , 'Sum of start_longitude plus end_longitude in input table'
       as test_parameter_1_description
       
     , 'Sum of average_longitude times 2 in output table'
       as test_parameter_2_description
       
     , null
       as test_parameter_3_description
     
     , (select round(sum(start_longitude + end_longitude),10) from transform_igc_4_split_to_second_segments) 
       as test_parameter_1
     
     , (select round(sum(average_longitude) * 2, 10) from transform_igc_5_average_latitude_longitude) 
       as test_parameter_2
     
     , null
       as test_parameter_3
     
     , null 
       as result
from dual
;

update test
set result = case
             when test_parameter_1 = test_parameter_2
             then 'Passed'
             else 'Failed'
             end
where id = '05-02'
;

-- See test results
select *
from test
;

select *
from test
where result = 'Passed'
;

select *
from test
where result = 'Failed'
;

commit;