drop table transform_log_data_with_grid_cell_id
;

create table transform_log_data_with_grid_cell_id as
select a.surrogate_key
     , a.file_path
     , a.start_date_time_of_log
     , a.delta_altitude
     , a.latitude
     , a.longitude
     , b.grid_cell_id
from (select * from transform_averaged_position order by surrogate_key) a
left join d_gridcell b on
    ( a.latitude >= b.start_lat_as_decimal
  and a.latitude <= b.end_lat_as_decimal
  and a.longitude >= b.start_long_as_decimal
  and a.longitude <= b.end_long_as_decimal
    )
;




