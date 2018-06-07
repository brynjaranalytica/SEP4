-- This query populates D_LogSource by inserting all of the possible sources of
-- the IGC log data
insert into D_LOGSOURCE (log)
select distinct(file_path) from TRANSFORM_IGC_8_PREAPARE_FOR_LOAD;
