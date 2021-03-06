DROP SEQUENCE sqGridCellSK;
DROP SEQUENCE sqDateSK;
DROP SEQUENCE sqTimeSK;
DROP SEQUENCE sqSurfaceTemperatureSK;
DROP SEQUENCE sqDewPointTemperatureSK;
DROP SEQUENCE sqWindSpeedSK;
DROP SEQUENCE sqWindDirectionSK;
DROP SEQUENCE sqPressureSK;
DROP SEQUENCE sqVisibilitySK;
DROP SEQUENCE sqCloudCoverageSK;
DROP SEQUENCE sqCloudAltitudeSK;
DROP SEQUENCE sqLogSourceSK;
DROP SEQUENCE sqAuditSK;

DROP TABLE F_Movement PURGE;
DROP TABLE D_GridCell PURGE;
DROP TABLE D_Time PURGE;
DROP TABLE D_Date PURGE;  
DROP TABLE D_SurfaceTemperature PURGE;
DROP TABLE D_DewPointTemperature PURGE;
DROP TABLE D_WindSpeed PURGE;
DROP TABLE D_WindDirection PURGE;
DROP TABLE D_Pressure PURGE;
DROP TABLE D_Visibility PURGE;
DROP TABLE D_CloudCoverage PURGE;
DROP TABLE D_CloudAltitude PURGE;
DROP TABLE D_LogSource PURGE;
DROP TABLE D_Audit PURGE;


-- Sequence for D_GridCell surrogate key
CREATE SEQUENCE sqGridCellSK
START WITH 0
INCREMENT BY 1
CACHE 100
NOMAXVALUE
MINVALUE 0
;

-- Sequence for D_Date surrogate key
CREATE SEQUENCE sqDateSK
START WITH 0
INCREMENT BY 1
CACHE 100
NOMAXVALUE
MINVALUE 0
;

-- Sequence for D_Time surrogate key
CREATE SEQUENCE sqTimeSK
START WITH 0
INCREMENT BY 1
CACHE 100
NOMAXVALUE
MINVALUE 0
;

-- Sequence for D_SurfaceTemperature surrogate key
create sequence sqSurfaceTemperatureSK
start with 0
increment by 1
cache 100
noMaxValue
minvalue 0
;

-- Sequence for D_DewPointTemperature surrogate key
create sequence sqDewPointTemperatureSK
start with 0
increment by 1
cache 100
noMaxValue
minvalue 0
;

-- Sequence for D_WindSpeed surrogate key
create sequence sqWindSpeedSK
start with 0
increment by 1
cache 100
noMaxValue
minvalue 0
;

-- Sequence for D_WindDirection surrogate key
create sequence sqWindDirectionSK
start with 0
increment by 1
cache 100
noMaxValue
minvalue 0
;
 
-- Sequence for D_Pressure surrogate key
create sequence sqPressureSK
start with 0
increment by 1
cache 100
noMaxValue
minvalue 0
;

-- Sequence for D_Visibility surrogate key
create sequence sqVisibilitySK
start with 0
increment by 1
cache 100
noMaxValue
minvalue 0
;

-- Sequence for D_CloudCoverage surrogate key
create sequence sqCloudCoverageSK
start with 0
increment by 1
cache 100
noMaxValue
minvalue 0
;

-- Sequence for D_CloudAltitude surrogate key
create sequence sqCloudAltitudeSK
start with 0
increment by 1
cache 100
noMaxValue
minvalue 0
;

-- Sequence for D_LogSource surrogate key
create sequence sqLogSourceSK
start with 0
increment by 1
cache 100
noMaxValue
minvalue 0
;

-- Sequence for D_Audit surrogate key
create sequence sqAuditSK
start with 0
increment by 1
cache 100
noMaxValue
minvalue 0
;


CREATE TABLE D_GridCell (
  grid_cell_id                 NUMBER(6, 0) 
                               DEFAULT sqGridCellSK.nextVal
                               CONSTRAINT DGridCellPK PRIMARY KEY,
  -- The coordinates of the start of the cell                      
  -- latitude degrees
  start_lat_deg 	       NUMBER(3, 0) 
                               NOT NULL
                               CONSTRAINT coStartLatDeg 
                               CHECK (start_lat_deg >= 0 AND start_lat_deg <= 90),
  -- latitude minutes
  start_lat_min                NUMBER(3, 0)
                               NOT NULL
                               CONSTRAINT coStartLatMin
                               CHECK (start_lat_min >= 0 AND start_lat_min <= 60),
  -- latitude seconds
  start_lat_s                  NUMBER(3, 0)
                               NOT NULL
                               CONSTRAINT coStartLatS
                               CHECK (start_lat_s >= 0 AND start_lat_s <= 60),
  -- latitude as a decimal
  start_lat_as_decimal         NUMBER(10, 6)
                               NOT NULL,                          
  -- longitude degrees
  start_long_deg               NUMBER(4, 0) 
                               NOT NULL
                               CONSTRAINT coStartLongDeg
                               CHECK (start_long_deg >= 0 AND start_long_deg <= 180),
  -- longitude minutes
  start_long_min               NUMBER(3, 0)
                               NOT NULL
                               CONSTRAINT coStartLongMin
                               CHECK (start_long_min >= 0 AND start_long_min <= 60),
  -- longitude seconds
  start_long_s                 NUMBER(3, 0)
                               NOT NULL
                               CONSTRAINT coStartLongS
                               CHECK (start_long_s >= 0 AND start_long_s <= 60),
  -- longitude as a decimal
  start_long_as_decimal        NUMBER(10, 6)
                               NOT NULL,
  ------------------------------------------------------------------------------------------
  -- The coordinates of the end of the cell (1 second before the next cell's start coordinates)                       
  -- latitude degrees
  end_lat_deg                  NUMBER(3, 0) 
                               NOT NULL
                               CONSTRAINT coEndLatDeg 
                               CHECK (end_lat_deg >= 0 AND end_lat_deg <= 90),
  -- latitude minutes
  end_lat_min                  NUMBER(3, 0)
                               NOT NULL,
                              -- CONSTRAINT coEndLatMin
                               --CHECK (end_lat_min >= 0 AND end_lat_min <= 60),
  -- latitude seconds
  end_lat_s                    NUMBER(3, 0)
                               NOT NULL
                               CONSTRAINT coEndLatS
                               CHECK (end_lat_s >= 0 AND end_lat_s <= 60),
  -- latitude as a decimal
  end_lat_as_decimal           NUMBER(10, 6)
                               NOT NULL,                          
  -- longitude degrees
  end_long_deg                 NUMBER(4, 0) 
                               NOT NULL
                               CONSTRAINT coEndLongDeg
                               CHECK (end_long_deg >= 0 AND end_long_deg <= 180),
  -- longitude minutes
  end_long_min                 NUMBER(3, 0)
                               NOT NULL
                               CONSTRAINT coEndLongMin
                               CHECK (end_long_min >= 0 AND end_long_min <= 60),
  -- longitude seconds
  end_long_s                   NUMBER(3, 0)
                               NOT NULL
                               CONSTRAINT coEndLongS
                               CHECK (end_long_s >= 0 AND end_long_s <= 60),
  -- longitude as a decimal
  end_long_as_decimal          NUMBER(10, 6)
                               NOT NULL                           
);

CREATE INDEX ix_d_gridcell_start_latitude ON d_gridcell (start_lat_deg, start_lat_min, start_lat_s);
CREATE INDEX ix_d_gridcell_start_longitude ON d_gridcell (start_long_deg, start_long_min, start_long_s);
CREATE INDEX ix_d_gridcell_start_latitude_as_decimal ON d_gridcell (start_lat_as_decimal);
CREATE INDEX ix_d_gridcell_start_longitude_as_decimal ON d_gridcell (start_long_as_decimal);
EXECUTE DBMS_STATS.GATHER_TABLE_STATS ('SEP4','D_GRIDCELL');

CREATE TABLE D_Time (
    time_id         NUMBER(6, 0) 
                    DEFAULT sqTimeSK.nextVal
                    CONSTRAINT DTimePK PRIMARY KEY,
    hour            NUMBER(2, 0) NOT NULL,
    minute          NUMBER(2, 0) NOT NULL,
    second          NUMBER(2, 0) NOT NULL
);

CREATE INDEX ix_d_time_hour_minute_second ON d_time (hour, minute, second);
EXECUTE DBMS_STATS.GATHER_TABLE_STATS ('SEP4','D_TIME');

CREATE TABLE D_Date(
    date_id         NUMBER(6, 0) 
                    DEFAULT sqDateSK.nextVal
                    CONSTRAINT DDatePK PRIMARY KEY,
    date_as_date    DATE NOT NULL,
    day             NUMBER(2, 0) NOT NULL,
    month           NUMBER(2, 0) NOT NULL,
    year            NUMBER(4, 0) NOT NULL
);

CREATE INDEX ix_d_date_year_month_day ON d_date (year, month, day);
EXECUTE DBMS_STATS.GATHER_TABLE_STATS ('SEP4','D_DATE');

create table D_SurfaceTemperature (   
    surface_temperature_id            number(6, 0)
                                      default sqSurfaceTemperatureSK.nextVal
                                      constraint DSurfaceTemperaturePK primary key,
    surface_temperature_fahrenheit    number(6, 0)
                                      not null,                               
    surface_temperature_celsius       number(6, 0)
                                      not null,
    surface_temperature_kelvin        number(6, 0)
                                      not null                                     
)
;

CREATE INDEX ix_d_surfacetemperature_fahrenheit ON d_surfacetemperature (surface_temperature_fahrenheit);
CREATE INDEX ix_d_surfacetemperature_celsius ON d_surfacetemperature (surface_temperature_celsius);
CREATE INDEX ix_d_surfacetemperature_kelvin ON d_surfacetemperature (surface_temperature_kelvin);
EXECUTE DBMS_STATS.GATHER_TABLE_STATS ('SEP4','D_SURFACETEMPERATURE');

create table D_DewPointTemperature (   
    dew_point_temperature_id          number(6, 0)
                                      default sqDewPointTemperatureSK.nextVal
                                      constraint DDewPointTemperaturePK primary key,
    dew_point_temperature_fahrenheit   number(6, 0)
                                      not null, 
    dew_point_temperature_celsius      number(6, 0)
                                      not null,                                 
    dew_point_temperature_kelvin      number(6, 0)
                                      not null   
)
;

CREATE INDEX ix_d_dewpointtemperature_fahrenheit ON d_dewpointtemperature (dew_point_temperature_fahrenheit);
CREATE INDEX ix_d_dewpointtemperature_celsius ON d_dewpointtemperature (dew_point_temperature_celsius);
CREATE INDEX ix_d_dewpointtemperature_kelvin ON d_dewpointtemperature (dew_point_temperature_kelvin);
EXECUTE DBMS_STATS.GATHER_TABLE_STATS ('SEP4','D_DEWPOINTTEMPERATURE');

create table D_WindSpeed (   
    wind_speed_id                     number(6, 0)
                                      default sqWindSpeedSK.nextVal
                                      not null
                                      constraint DWindSpeedPK primary key,
    speed_knots                       number(6, 0)
                                      not null,
    speed_meters_per_second           number(6, 0)
                                      not null
)
;

CREATE INDEX ix_d_windspeed_knots ON d_windspeed (speed_knots);
CREATE INDEX ix_d_windspeed_meters_per_secnd ON d_windspeed (speed_meters_per_second);
EXECUTE DBMS_STATS.GATHER_TABLE_STATS ('SEP4', 'D_WINDSPEED');

create table D_WindDirection (   
    wind_direction_id                 number(6, 0)
                                      default sqWindDirectionSK.nextVal
                                      not null
                                      constraint DWindDirectionPK primary key,
    direction                         varchar2(4)
                                      not null
)
;

CREATE INDEX ix_d_winddirection_direction ON d_winddirection (direction);
EXECUTE DBMS_STATS.GATHER_TABLE_STATS ('SEP4', 'D_WINDDIRECTION');

create table D_Pressure (   
    pressure_id                       number(6, 0)
                                      default sqPressureSK.nextVal
                                      constraint DPressurePK primary key,
    barometric_pressure               number(6, 0)
                                      not null
)
;

CREATE INDEX ix_d_pressure_barometric_pressure ON d_pressure (barometric_pressure);
EXECUTE DBMS_STATS.GATHER_TABLE_STATS ('SEP4', 'D_PRESSURE');

create table D_Visibility (   
    visibility_id         number(6, 0)
                          default sqVisibilitySK.nextVal
                          constraint DVisibilityPK primary key,
    visibility            number(6, 0)
                          not null                      
)
;

CREATE INDEX ix_d_visibility_visibility ON d_visibility (visibility);
EXECUTE DBMS_STATS.GATHER_TABLE_STATS ('SEP4', 'D_VISIBILITY');

create table D_CloudCoverage (   
    cloud_coverage_id     number(6, 0)
                          default sqCloudCoverageSK.nextVal
                          constraint DCloudCoveragePK primary key,
    cloud_coverage        varchar(4)
                          not null
)
;

CREATE INDEX ix_d_cloudcoverage_cloud_coverage ON d_cloudcoverage (cloud_coverage);
EXECUTE DBMS_STATS.GATHER_TABLE_STATS ('SEP4', 'D_CLOUDCOVERAGE');

create table D_CloudAltitude (   
    cloud_altitude_id     number(6, 0)
                          default sqCloudAltitudeSK.nextVal
                          constraint DCloudAltitudePK primary key,
    cloud_height          number(13, 0)
                          not null
)
;

CREATE INDEX ix_d_cloudaltitude_cloud_height ON d_cloudaltitude (cloud_height);
EXECUTE DBMS_STATS.GATHER_TABLE_STATS ('SEP4', 'D_CLOUDALTITUDE');

CREATE TABLE D_LogSource (
    log_source_id   NUMBER(6, 0) 
                    DEFAULT sqLogSourceSK.nextVal
                    CONSTRAINT DLogSourcePK PRIMARY KEY,
    log             VARCHAR2(255)
                    NOT NULL
);

CREATE TABLE D_Audit (
    audit_id        NUMBER(6, 0) 
                    DEFAULT sqAuditSK.nextVal
                    CONSTRAINT DAuditPK PRIMARY KEY,
    fixed_no        NUMBER(6, 0) NOT NULL,
    discarded_no    NUMBER(6, 0) NOT NULL,
    ignored_no      NUMBER(6, 0) NOT NULL
);

CREATE TABLE F_Movement (
  delta_altitude            NUMBER(6, 0),
  delta_time                NUMBER(6, 0),
  log_source_id             NUMBER(6, 0)
                            REFERENCES D_LogSource (log_source_id),
  grid_id                   NUMBER(6, 0)
                            REFERENCES D_GridCell (grid_cell_id),
  start_time_id             NUMBER(6, 0)
                            REFERENCES D_Time (time_id),             
  date_id                   NUMBER(6, 0)
                            REFERENCES D_Date (date_id),
  surface_temperature_id    NUMBER(6, 0)
                            REFERENCES D_SurfaceTemperature (surface_temperature_id),                        
  dew_point_temperature_id  NUMBER(6, 0)
                            REFERENCES D_DewPointTemperature (dew_point_temperature_id),
  wind_speed_id             NUMBER(6, 0)
                            REFERENCES D_WindSpeed (wind_speed_id),
  wind_direction_id         NUMBER(6, 0)
                            REFERENCES D_WindDirection (wind_direction_id),                        
  pressure_id               NUMBER(6, 0)
                            REFERENCES D_Pressure (pressure_id),
  visibility_id             NUMBER(6, 0)
                            REFERENCES D_Visibility (visibility_id),
  cloud_coverage_id         NUMBER(6, 0)
                            REFERENCES D_CloudCoverage (cloud_coverage_id),
  cloud_altitude_id         NUMBER(6, 0)
                            REFERENCES D_CloudAltitude (cloud_altitude_id),
  audit_id		    NUMBER(6, 0)
                            REFERENCES D_Audit (audit_id),
  CONSTRAINT FMovementPK PRIMARY KEY (log_source_id, grid_id, start_time_id, date_id, 
  surface_temperature_id, dew_point_temperature_id, wind_speed_id, 
  wind_direction_id,pressure_id, visibility_id,
  cloud_coverage_id, cloud_altitude_id)
  --, audit_id)
);
/
exit;