/* Transform_IGC_6_Fetch_Grid_Cell_Id.sql
 *
 * This script joins all the transformed movements together with the cell in the
 * grid of Denmark in which the movement falls into, by looking at the latitude
 * and longitude of the movement (which are averages between the start and end
 * points) and pinpointing in which latitude and longitude ranges they are a
 * member of in the d_gridcell dimensions.
 *
 * In the off chance that the latitude and longitude cannot be matched within
 * the ranges of a cell in the grid, then the id is coalesced to -1 which points
 * to the dummy row of the dimension. This also accounts for cases where
 * coordinates have been logged outside of the grid.
 *
 * Past transformation: Transform_IGC_5_Average_Latitude_Longitude
 * Next transformation: Transform_IGC_7_Join_Weather_Data
 */
drop table transform_igc_6_fetch_grid_cell_id
;

create table transform_igc_6_fetch_grid_cell_id as
select a.surrogate_key
     , a.file_path
     , a.start_date_time_of_log
     , a.delta_altitude
     , coalesce(b.grid_cell_id, -1) as grid_cell_id
     , b.nearest_weather_station
     , a.average_latitude
     , a.average_longitude
     , a.start_latitude
     , a.end_latitude
     , a.start_longitude
     , a.end_longitude
     , a.delta_time
from transform_igc_5_average_latitude_longitude a
left join d_gridcell b on
    ( a.average_latitude >= b.start_lat_as_decimal
  and a.average_latitude < b.end_lat_as_decimal
  and a.average_longitude >= b.start_long_as_decimal
  and a.average_longitude < b.end_long_as_decimal
    )
;