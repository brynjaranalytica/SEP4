/* Transform_IGC_5_Average_Latitude_Longitude.sql
 *
 * This script calculates the mid point or average point of the movement from
 * the start and end latitude and longitudes. 
 *
 * Past transformation: Transform_IGC_4_Split_To_Second_Segments
 * Next transformation: Transform_IGC_6_Fetch_Grid_Cell_Id
 */
drop table transform_igc_5_average_latitude_longitude
;

create table transform_igc_5_average_latitude_longitude as
select surrogate_key
     , file_path
     , start_date_time_of_log
     , delta_altitude
     , ((end_latitude + start_latitude) / 2) as average_latitude 
     , ((end_longitude + start_longitude) / 2) as average_longitude
     , start_latitude
     , end_latitude
     , start_longitude
     , end_longitude
     , delta_time
from transform_igc_4_split_to_second_segments
;