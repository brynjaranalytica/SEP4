drop table transform_corrected_times
;

create table transform_corrected_times as
select surrogate_key
     , file_path
     , to_date(year_of_log||month_of_log||day_of_log||' '||substr(time_of_log,1,2)||':'||substr(time_of_log,3,2)||':'||substr(time_of_log,5,2), 'YYMMDD HH24:MI:SS') as date_of_log
     , latitude
     , longitude
     , pressure_altitude
     , gps_altitude
from log_data_extract
;