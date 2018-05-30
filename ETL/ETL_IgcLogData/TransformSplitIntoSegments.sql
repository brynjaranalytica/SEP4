drop table transform_one_second_segments
;

create table transform_one_second_segments
(
  surrogate_key     int
, file_path         varchar2(255)
, delta_altitude    number
, start_latitude    number
, end_latitude     number
, start_longitude   number
, end_longitude     number
, start_date_time_of_log date
)
;

drop sequence sq_segments_surrogate_key
;

create sequence sq_segments_surrogate_key
  increment by 1
  start with 1
  cache 100
  nomaxvalue
;

declare
  latitude_interval number;
  longitude_interval number;
  new_record transform_one_second_segments%rowtype;
begin
  DBMS_OUTPUT.ENABLE(buffer_size => NULL);

  for current_record in (select * from transform_coordinates_to_decimal order by file_path, start_date_time_of_log) loop
    latitude_interval := (current_record.end_latitude_as_decimal - current_record.start_latitude_as_decimal) / current_record.delta_time;
    longitude_interval := (current_record.end_longitude_as_decimal - current_record.start_longitude_as_decimal) / current_record.delta_time;
    for s in 1..(current_record.delta_time) loop
    
      new_record.file_path := current_record.file_path;
      new_record.surrogate_key := sq_segments_surrogate_key.nextval;
      
      new_record.delta_altitude := current_record.delta_altitude / current_record.delta_time;
      
      new_record.start_latitude := current_record.start_latitude_as_decimal + (latitude_interval * (s - 1));
      new_record.end_latitude := new_record.start_latitude + latitude_interval;
      
      new_record.start_longitude := current_record.start_longitude_as_decimal + (longitude_interval * (s - 1));
      new_record.end_longitude := new_record.start_longitude + longitude_interval;
      
      new_record.start_date_time_of_log := current_record.start_date_time_of_log + numToDSInterval( (s - 1), 'second' );
       
      insert into transform_one_second_segments values new_record;
      
    end loop;
  end loop;
end;