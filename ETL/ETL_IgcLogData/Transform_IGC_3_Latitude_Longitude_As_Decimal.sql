/* Transform_IGC_3_Latitude_Longitude_As_Decimal.sql
 *
 * This script takes the raw coordinates and calculates them into degrees with
 * decimals. In order to do this the minutes with a cap of 60 must be converted
 * into its equivalent value out of 100.
 *
 * An example of a raw latitude could be 5559949. The numbers have the following
 * meaning: 
 * The first 55 are the degrees.
 * The following 59 are the minutes
 * The last 949 are the tenth, hundredth and thousandth of a minute.
 *
 * Knowing this, the last 5 digits can be regarded as the minute. The minute is
 * then converted by multiplying by 100/60. In this example the result would be
 * 59.949 minutes * (100/60) = 99.915
 * These are then added to the degrees with the proper factor. In this case the 
 * 99.915 minutes are equal to 0.99915 degrees and finally the result are the
 * degrees with decimals, in this example 55.99915.
 *
 * Past transformation: Transform_IGC_2_Connect_Coordinates_Launch_Removed
 * Next transformation: Transform_IGC_4_Split_To_Second_Segments
 */
drop table transform_igc_3_latitude_longitude_as_decimal
;

create table transform_igc_3_latitude_longitude_as_decimal
(
  surrogate_key                 int
, file_path                     varchar2(255)
, start_date_time_of_log        date
, delta_altitude                number
, delta_time                    number
, start_latitude_as_decimal     number
, end_latitude_as_decimal       number
, start_longitude_as_decimal    number 
, end_longitude_as_decimal      number
)
;

declare
  degrees int;
  minutes int;
  minutes_factor number := 0.00001;
  minutes_as_decimal_degrees number;
  new_record transform_igc_3_latitude_longitude_as_decimal%rowtype;
begin
  DBMS_OUTPUT.ENABLE(buffer_size => NULL);
  for current_record in (select * from  transform_igc_2_connect_coordinates) loop
    new_record.surrogate_key := current_record.surrogate_key;
    new_record.file_path := current_record.file_path;
    new_record.start_date_time_of_log := current_record.start_date_time_of_log;
    new_record.delta_altitude := current_record.delta_altitude;
    new_record.delta_time := current_record.delta_time;
  
    -- start latitude
    degrees := floor(current_record.start_latitude / 100000);                                      -- fetching the first 1/2 digits (degrees)
    minutes := floor(mod(current_record.start_latitude,100000));                                   -- fetching the last 5 digits (minutes with decimals)
    minutes_as_decimal_degrees := minutes * (100/60);                                              -- converting the minutes into decimal range
    new_record.start_latitude_as_decimal := degrees + minutes_as_decimal_degrees * minutes_factor; -- adding it all together
    
    -- end latitude
    degrees := floor(current_record.end_latitude / 100000);
    minutes := floor(mod(current_record.end_latitude,100000));
    minutes_as_decimal_degrees := minutes * (100/60);
    new_record.end_latitude_as_decimal := degrees + minutes_as_decimal_degrees * minutes_factor;
    
    -- start longitude
    degrees := floor(current_record.start_longitude / 100000);
    minutes := floor(mod(current_record.start_longitude,100000));
    minutes_as_decimal_degrees := minutes * (100/60);
    new_record.start_longitude_as_decimal := degrees + minutes_as_decimal_degrees * minutes_factor;
    
    -- end longitude
    degrees := floor(current_record.end_longitude / 100000);    
    minutes := floor(mod(current_record.end_longitude,100000));
    minutes_as_decimal_degrees := minutes * (100/60);
    new_record.end_longitude_as_decimal := degrees + minutes_as_decimal_degrees * minutes_factor;
    
    insert into transform_igc_3_latitude_longitude_as_decimal values new_record;
    
  end loop;
end;
