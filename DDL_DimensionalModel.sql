DROP SEQUENCE sqGridCellSK;
DROP SEQUENCE sqDateSK;
DROP SEQUENCE sqTimeSK;
DROP SEQUENCE sqTemperatureSK;
DROP SEQUENCE sqWindSK;
DROP SEQUENCE sqPressureSK;
DROP SEQUENCE sqVisibilitySK;
DROP SEQUENCE sqCloudCoverageSK;

DROP TABLE F_Movement;
DROP TABLE D_GridCell;
DROP TABLE D_Time;
DROP TABLE D_Date;  
DROP TABLE D_Temperature;
DROP TABLE D_Wind;
DROP TABLE D_Pressure;
DROP TABLE D_Visibility;
DROP TABLE D_CloudCoverage;


-- Sequence for D_GridCell surrogate key
CREATE SEQUENCE sqGridCellSK
START WITH 1
INCREMENT BY 1
NOMAXVALUE
CACHE 100;

-- Sequence for D_Date surrogate key
CREATE SEQUENCE sqDateSK
START WITH 1
INCREMENT BY 1
NOMAXVALUE
CACHE 100;

-- Sequence for D_Time surrogate key
CREATE SEQUENCE sqTimeSK
START WITH 1
INCREMENT BY 1
NOMAXVALUE
CACHE 100;

-- Sequence for D_Temperature surrogate key
create sequence sqTemperatureSK
start with 1
increment by 1
cache 100
noMaxValue
;

-- Sequence for D_Wind surrogate key
create sequence sqWindSK
start with 1
increment by 1
cache 100
noMaxValue
;
 
-- Sequence for D_Pressure surrogate key
create sequence sqPressureSK
start with 1
increment by 1
cache 100
noMaxValue
;

-- Sequence for D_Visibility surrogate key
create sequence sqVisibilitySK
start with 1
increment by 1
cache 100
noMaxValue
;

-- Sequence for D_CloudCoverage surrogate key
create sequence sqCloudCoverageSK
start with 1
increment by 1
cache 100
noMaxValue
;


CREATE TABLE D_GridCell (
  grid_cell_id                 NUMBER(6, 0) 
                               DEFAULT sqGridCellSK.nextVal
                               CONSTRAINT DGridCellPK PRIMARY KEY,
                               
  -- The coordinates of the start of the cell
  -- latitude degrees
  start_lat_deg                NUMBER(3, 0) 
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
CREATE TABLE D_Time (
    time_id         NUMBER(6, 0) 
                    DEFAULT sqTimeSK.nextVal
                    CONSTRAINT DTimePK PRIMARY KEY,
    hour            NUMBER(2, 0) NOT NULL,
    minute          NUMBER(2, 0) NOT NULL,
    second          NUMBER(2, 0) NOT NULL
);

CREATE TABLE D_Date(
    date_id         NUMBER(6, 0) 
                    DEFAULT sqDateSK.nextVal
                    CONSTRAINT DDatePK PRIMARY KEY,
    day             NUMBER(2, 0) NOT NULL,
    month           NUMBER(2, 0) NOT NULL,
    year            NUMBER(4, 0) NOT NULL
);

create table D_Temperature (   
    temperature_id                    number(6, 0)
                                      default sqTemperatureSK.nextVal
                                      constraint DTemperaturePK primary key,
    surface_temperature_kelvin        number(6, 0)
                                      not null,
    surface_temperature_celsius       number(6, 0)
                                      not null,
    surface_temperature_fahrenheit    number(6, 0)
                                      not null,                            
    dew_point_temperature_kelvin      number(6, 0)
                                      not null,
    dew_point_emperature_celsius      number(6, 0)
                                      not null,
    dew_point_emperature_fahrenheit   number(6, 0)
                                      not null
)
;


create table D_Wind (   
    wind_id                           number(6, 0)
                                      default sqWindSK.nextVal
                                      not null
                                      constraint DWindPK primary key,
    direction                         char(2)
                                      not null,
    speed_knots                       number(6, 0)
                                      not null,
    speed_meters_per_second           number(6, 0)
                                      not null
)
;

create table D_Pressure (   
    pressure_id                       number(6, 0)
                                      default sqPressureSK.nextVal
                                      constraint DPressurePK primary key,
    barometric_pressure               number(6, 2)
                                      not null
)
;

create table D_Visibility (   
    visibility_id         number(6, 0)
                          default sqVisibilitySK.nextVal
                          constraint DVisibilityPK primary key,
    visibility            number(6, 0)
                          not null, 
    visibility_type       varchar(12)
                          
                          
                          
                          
)
;
 
create table D_CloudCoverage (   
    cloud_coverage_id     number(6, 0)
                          default sqCloudCoverageSK.nextVal
                          constraint DCloudCoveragePK primary key,
    cloud_coverage        varchar(4)
                          not null,
    cloud_height          number(13, 0)
                          not null
)
;

CREATE TABLE F_Movement (
  delta_altitude          NUMBER(6, 0),
  delta_time              NUMBER(6, 0),
  grid_id                 NUMBER(6, 0)
                          REFERENCES D_GridCell (grid_cell_id),
  start_time_id           NUMBER(6, 0)
                          REFERENCES D_Time (time_id),             
  date_id                 NUMBER(6, 0)
                          REFERENCES D_Date (date_id),
  temperature_id          NUMBER(6, 0)
                          REFERENCES D_Temperature (temperature_id),
  wind_id                 NUMBER(6, 0)
                          REFERENCES D_Wind (wind_id),
  pressure_id             NUMBER(6, 0)
                          REFERENCES D_Pressure (pressure_id),
  visibility_id           NUMBER(6, 0)
                          REFERENCES D_Visibility (visibility_id),
  cloud_coverage_id       NUMBER(6, 0)
                          REFERENCES D_CloudCoverage (cloud_coverage_id),
  CONSTRAINT FMovementPK PRIMARY KEY (grid_id, start_time_id, date_id, temperature_id, wind_id, pressure_id, visibility_id, cloud_coverage_id)
);