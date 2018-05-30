drop table transform_connected_coordinates
;

create table transform_connected_coordinates
(
  surrogate_key            int
, file_path                varchar2(255)
, delta_altitude           int
, delta_time               number
, start_latitude           number
, end_latitude             number
, start_longitude          number
, end_longitude            number
, start_date_time_of_log   date
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
  previous_record transform_corrected_times%rowtype;
  new_record transform_connected_coordinates%rowtype;
begin
  DBMS_OUTPUT.ENABLE(buffer_size => NULL);
  
  -- loops through every file in the log data
  for current_file in (select distinct(file_path) from transform_corrected_times order by file_path asc) loop
    DBMS_OUTPUT.PUT_LINE(current_file.file_path);
    record_count := 0;
  
    -- loops through every record for the current file
    for current_record in (select * from transform_corrected_times where file_path = current_file.file_path order by date_of_log asc) loop
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
        
        insert into transform_connected_coordinates values new_record;
                             
      end if;
      previous_record := current_record;
      record_count := record_count + 1;
    end loop;
  end loop;
  commit;
end;