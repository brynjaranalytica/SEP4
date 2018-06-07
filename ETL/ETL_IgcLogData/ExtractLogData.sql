/* This script extracts all the delimited log data stored in the PreparedFiles
 * directory of the IgcLogDataPrepper.
 * External tables are made for records and dates and then tied together
 * by filename in a single table 'log_data_extract'
 */

/* Directory and external tables */
drop directory igc_log_data_location
;

create or replace directory igc_log_data_location as 'C:\SEP4\ETL\ETL_IgcLogData\IgcLogDataPrepper\PreparedFiles'
;

grant read, write on directory igc_log_data_location to public
;

drop table external_records
;

create table external_records
(
  file_path             varchar2(255)
, record_type           varchar2(50)
, time_of_log           varchar2(50)
, latitude              varchar2(50)
, longitude             varchar2(50)
, satellite_coverage    varchar2(50)
, pressure_altitude     varchar2(50)
, gps_altitude          varchar2(50)
)
organization external
(
  type oracle_loader
  default directory igc_log_data_location
  access parameters
  (
    records delimited by newline
    characterset WE8ISO8859P1
    string sizes are in characters
    badfile 'records.bad'
    discardfile 'records.dis'
    logfile 'records.log'    
    fields terminated by ';' 
    optionally enclosed by '"'
  )
  location ('DelimitedRecords.txt')
)
;

drop table external_dates
;

create table external_dates
(
  file_path     varchar2(255)
, day           varchar(50)
, month         varchar(50)
, year          varchar(50)
)
organization external
(
  type oracle_loader
  default directory igc_log_data_location
  access parameters
  (
    records delimited by newline
    characterset WE8ISO8859P1
    string sizes are in characters
    badfile 'dates.bad'
    discardfile 'dates.dis'
    logfile 'dates.log'    
    fields terminated by ';' 
    optionally enclosed by '"'
  )
  location ('DelimitedDates.txt')
)
;

/* Records are joined to their specific date by filename.
 * Columns such as record type and satellite coverage are not selected since
 * they are redundant
 */ 
drop sequence sq_log_data_surrogate_key
;

create sequence sq_log_data_surrogate_key
  increment by 1
  start with 1
  cache 100
  nomaxvalue
;
 
drop table log_data_extract purge
;
 
create table log_data_extract as
select sq_log_data_surrogate_key.nextval as surrogate_key
     , external_dates.file_path as file_path
     , external_dates.year as year_of_log
     , external_dates.month as month_of_log
     , external_dates.day as day_of_log
     , external_records.time_of_log as time_of_log
     , external_records.latitude as latitude
     , external_records.longitude as longitude
     , external_records.pressure_altitude as pressure_altitude
     , external_records.gps_altitude as gps_altitude
from external_records
join external_dates
  on (external_records.file_path = external_dates.file_path)
;