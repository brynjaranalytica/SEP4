/* This script takes each movement between two coordinates, invariable of the
 * time and splits it into 1 second movements. This means that a movement that
 * took 12 seconds is split into 12 individual 1 second movements. The intention
 * is that in the end, all altitude changes are invariable of the time of the
 * movement, as they are all 1 second long.
 *
 * Another effect is that the coordinates of the movements can be made finer
 * and thereby the movements can more easily be pointed to a specific grid cell
 * in which the movement took place.
 *
 * The coordinates are split by dividing the stretch from start to end
 * coordinates into the number of segments being made and each new 1 second
 * segment are assigned new start and end coordinates.
 *
 * This is an example of regression(?) in which we cannot exactly say how each
 * second behaved, since the speed of the glider could be variable over the
 * course of a longer movement, but we are taking a calculated guess in order to
 * better data to be analysed in the dimensional model.
 *
 * Past transformation: Transform_IGC_3_Latitude_Longitude_As_Decimal
 * Next transformation: Transform_IGC_5_Average_Latitude_Longitude
 */
drop table transform_igc_4_split_to_second_segments
;

create table transform_igc_4_split_to_second_segments
(
  surrogate_key           int
, file_path               varchar2(255)
, start_date_time_of_log  date
, delta_altitude          number
, start_latitude          number
, end_latitude            number
, start_longitude         number
, end_longitude           number
, delta_time              number
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
  new_record transform_igc_4_split_to_second_segments%rowtype;
begin
  DBMS_OUTPUT.ENABLE(buffer_size => NULL);

  for current_record in (select * from transform_igc_3_latitude_longitude_as_decimal order by file_path, start_date_time_of_log) loop
    latitude_interval := (current_record.end_latitude_as_decimal - current_record.start_latitude_as_decimal) / current_record.delta_time;
    longitude_interval := (current_record.end_longitude_as_decimal - current_record.start_longitude_as_decimal) / current_record.delta_time;
    for second in 1..(current_record.delta_time) loop
    
      new_record.file_path := current_record.file_path;
      new_record.surrogate_key := sq_segments_surrogate_key.nextval;
      
      new_record.delta_altitude := current_record.delta_altitude / current_record.delta_time;
      
      new_record.start_latitude := current_record.start_latitude_as_decimal + (latitude_interval * (second - 1));
      new_record.end_latitude := new_record.start_latitude + latitude_interval;
      
      new_record.start_longitude := current_record.start_longitude_as_decimal + (longitude_interval * (second - 1));
      new_record.end_longitude := new_record.start_longitude + longitude_interval;
      
      new_record.start_date_time_of_log := current_record.start_date_time_of_log + numToDSInterval( (second - 1), 'second' );
      new_record.delta_time := current_record.delta_time / current_record.delta_time;
       
      insert into transform_igc_4_split_to_second_segments values new_record;
      
    end loop;
  end loop;
end;