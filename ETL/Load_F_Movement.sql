INSERT INTO F_MOVEMENT(delta_altitude, delta_time, log_source_id, grid_id, start_time_id, date_id, 
surface_temperature_id, dew_point_temperature_id, wind_speed_id, wind_direction_id, 
pressure_id, visibility_id, cloud_coverage_id, cloud_altitude_id)

  SELECT jwd.delta_altitude, jwd.delta_time, ls.log_source_id, grid_cell_id, t.TIME_ID, d.DATE_ID, st.SURFACE_TEMPERATURE_ID, dp.DEW_POINT_TEMPERATURE_ID,
          ws.WIND_SPEED_ID, wd.WIND_DIRECTION_ID, p.PRESSURE_ID, v.VISIBILITY_ID, clc.CLOUD_COVERAGE_ID, ca.CLOUD_ALTITUDE_ID
  FROM TRANSFORM_IGC_8_PREAPARE_FOR_LOAD jwd
  
  JOIN D_LogSource ls ON ls.LOG = jwd.FILE_PATH
  JOIN D_Time t ON t.hour =  TO_NUMBER(to_char(jwd.START_DATE_TIME_OF_LOG, 'HH24'), '99')
        and t.minute = TO_NUMBER(to_char(jwd.START_DATE_TIME_OF_LOG, 'MI'), '99')
        and t.second = TO_NUMBER(to_char(jwd.START_DATE_TIME_OF_LOG, 'SS'), '99')
  JOIN D_Date d ON d.DATE_AS_DATE = TO_DATE(to_char(jwd.START_DATE_TIME_OF_LOG, 'YY-MON-DD'))
  JOIN D_SurfaceTemperature st ON st.SURFACE_TEMPERATURE_FAHRENHEIT = jwd.SURFACE_TEMPERATURE_FAHRENHEIT 
  JOIN D_Dewpointtemperature dp ON dp.DEW_POINT_TEMPERATURE_FAHRENHEIT = jwd.DEW_POINT_TEMPERATURE_FAHRENHEIT
  JOIN D_WINDSPEED ws ON ws.SPEED_KNOTS = jwd.WIND_SPEED_KNOTS
  JOIN D_WINDDIRECTION wd ON jwd.WIND_DIRECTION = wd.DIRECTION
  JOIN D_Pressure p ON p.BAROMETRIC_PRESSURE = jwd.PRESSURE_ALTIMETER_INCHES
  JOIN D_VISIBILITY v ON v.VISIBILITY = jwd.VISIBILITY_MILES
  JOIN D_CLOUDCOVERAGE clc ON clc.CLOUD_COVERAGE = jwd.SKY_LEVEL_1_COVERAGE
  JOIN D_CLOUDALTITUDE ca ON ca.CLOUD_HEIGHT = jwd.SKY_LEVEL_1_ALTITUDE_FEET
;

-- should be 551631
select COUNT(*) from F_MOVEMENT;

