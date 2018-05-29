drop table transform_averaged_position
;

create table transform_averaged_position as
select surrogate_key
     , file_path
     , delta_altitude
     , ((end_latitude + start_latitude) / 2) as latitude 
     , ((end_longitude + start_longitude) / 2) as longitude
     , start_date_time_of_log
from transform_one_second_segments
;