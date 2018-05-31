/* This script is one of the more defining of the transformation.
 * Every logged coordinate, except the very first, of the IGC data is connected
 * with the previous, effectively creating transitions between coordinates
 * (or vectors) with the intention of storing change in contrary to state in the
 * dimensional model.
 *
 * Past transformation: Transform_IGC_1_Format_Date_Time
 * Next transformation: Transform_IGC_3_Latitude_Longitude_As_Decimal
 */
drop table transform_igc_2_connect_coordinates
;

create table transform_igc_2_connect_coordinates
(
  surrogate_key            int
, file_path                varchar2(255)
, start_date_time_of_log   date
, delta_altitude           int
, delta_time               number
, start_latitude           number
, end_latitude             number
, start_longitude          number
, end_longitude            number
)
;

drop sequence sq_connected_coordinates_surrogate_key
;

create sequence sq_connected_coordinates_surrogate_key
  increment by 1
  start with 1
  cache 100
  nomaxvalue
;

declare
  record_count int;
  previous_record transform_igc_1_format_date_time%rowtype;
  new_record transform_igc_2_connect_coordinates%rowtype;
begin
  DBMS_OUTPUT.ENABLE(buffer_size => NULL);
  
  -- loops through every file in the log data
  for current_file in (select distinct(file_path) from transform_igc_1_format_date_time order by file_path asc) loop
    DBMS_OUTPUT.PUT_LINE(current_file.file_path);
    record_count := 0;
  
    -- loops through every record for the current file
    for current_record in (select * from transform_igc_1_format_date_time where file_path = current_file.file_path order by date_of_log asc) loop
      if (record_count <> 0) then
        new_record.surrogate_key := sq_connected_coordinates_surrogate_key.nextval;
        new_record.file_path := current_record.file_path;
        
        new_record.delta_altitude := current_record.pressure_altitude - previous_record.pressure_altitude;
        new_record.delta_time := TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(current_record.date_of_log - previous_record.date_of_log, 'DAY')), 'FM00');
        
        new_record.start_latitude := to_number(substr(previous_record.latitude, 1, length(previous_record.latitude)-1));
        new_record.end_latitude := to_number(substr(current_record.latitude, 1, length(current_record.latitude)-1));
        
        new_record.start_longitude := to_number(substr(previous_record.longitude, 1, length(previous_record.longitude)-1));
        new_record.end_longitude := to_number(substr(current_record.longitude, 1, length(current_record.longitude)-1));
        
        new_record.start_date_time_of_log := previous_record.date_of_log;
        
        insert into transform_igc_2_connect_coordinates values new_record;
                             
      end if;
      previous_record := current_record;
      record_count := record_count + 1;
    end loop;
  end loop;
  commit;
end;