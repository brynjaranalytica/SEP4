drop table transform_coordinates_to_decimal
;

create table transform_coordinates_to_decimal
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
  minutes_factor number := 0.01;
  
  decimals_of_a_minute int;
  decimals_of_a_minute_factor number := 0.0001;
  
  minutes_as_decimal_degrees number;
  seconds_as_decimal_degrees number;
  start_latitude_as_decimal number;
  new_record transform_coordinates_to_decimal%rowtype;
begin
  DBMS_OUTPUT.ENABLE(buffer_size => NULL);
  for current_record in (select * from transform_connected_coordinates) loop
    new_record.surrogate_key := current_record.surrogate_key;
    new_record.file_path := current_record.file_path;
    new_record.start_date_time_of_log := current_record.start_date_time_of_log;
    new_record.delta_altitude := current_record.delta_altitude;
    new_record.delta_time := current_record.delta_time;
  
    -- start latitude is calculated as decimals
    degrees := floor(current_record.start_latitude / 100000);
    minutes := floor(mod(current_record.start_latitude,100000) / 1000);
    decimals_of_a_minute := floor(mod(current_record.start_latitude,1000) / 10);
    minutes_as_decimal_degrees := minutes * (100/60);
    new_record.start_latitude_as_decimal := degrees + minutes_as_decimal_degrees * minutes_factor + decimals_of_a_minute * decimals_of_a_minute_factor;
    
    -- end latitude is calculated as decimals
    degrees := floor(current_record.end_latitude / 100000);
    minutes := floor(mod(current_record.end_latitude,100000) / 1000);
    decimals_of_a_minute := floor(mod(current_record.end_latitude,1000) / 10);
    minutes_as_decimal_degrees := minutes * (100/60);
    new_record.end_latitude_as_decimal := degrees + minutes_as_decimal_degrees * minutes_factor + decimals_of_a_minute * decimals_of_a_minute_factor;
    
    -- start longitude is calculated as decimals
    degrees := floor(current_record.start_longitude / 100000);
    minutes := floor(mod(current_record.start_longitude,100000) / 1000);
    decimals_of_a_minute := floor(mod(current_record.start_longitude,1000) / 10);
    minutes_as_decimal_degrees := minutes * (100/60);
    new_record.start_longitude_as_decimal := degrees + minutes_as_decimal_degrees * minutes_factor + decimals_of_a_minute * decimals_of_a_minute_factor;
    
    -- end longitude is calculated as decimals
    degrees := floor(current_record.end_longitude / 100000);
    minutes := floor(mod(current_record.end_longitude,100000) / 1000);
    decimals_of_a_minute := floor(mod(current_record.end_longitude,1000) / 10);
    minutes_as_decimal_degrees := minutes * (100/60);
    new_record.end_longitude_as_decimal := degrees + minutes_as_decimal_degrees * minutes_factor + decimals_of_a_minute * decimals_of_a_minute_factor;
    
    insert into transform_coordinates_to_decimal values new_record;
    
  end loop;
end;
