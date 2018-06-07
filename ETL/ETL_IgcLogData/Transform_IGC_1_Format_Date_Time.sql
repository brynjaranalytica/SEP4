/* Transform_IGC_1_Format_Date_Time.sql
 *
 * This script is the first in the chain of transformations of the IGC log data
 * extract. Here, the raw time string is split up and stored together with the
 * date into a single date (or datetime if you will) column.
 *
 * Past transformation: None, Refer to ExtractLogData for extraction
 * Next transformation: Transform_IGC_2_Connect_Coordinates_Launch_Removed
 */
drop table transform_igc_1_format_date_time
;

create table transform_igc_1_format_date_time as
select surrogate_key
     , file_path
     , to_date(year_of_log||month_of_log||day_of_log||' '||substr(time_of_log,1,2)||':'||substr(time_of_log,3,2)||':'||substr(time_of_log,5,2), 'YYMMDD HH24:MI:SS') as date_of_log
     , latitude
     , longitude
     , pressure_altitude
     , gps_altitude
from log_data_extract
;