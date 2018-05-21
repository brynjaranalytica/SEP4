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
  latitude_id                  NUMBER(6, 0) 
                               DEFAULT sqGridCellSK.nextVal
                               CONSTRAINT DGridCellPK PRIMARY KEY,
  start_latitude_degrees       NUMBER(3, 0) 
                               NOT NULL
                               CONSTRAINT coLatitudeDegrees 
                               CHECK (start_latitude_degrees >= 0 AND start_latitude_degrees <= 90),
  start_latitude_minutes       NUMBER(3, 0)
                               NOT NULL
                               CONSTRAINT coLatitudeMinutes
                               CHECK (start_latitude_minutes >= 0 AND start_latitude_minutes <= 60),
  start_latitude_seconds       NUMBER(3, 0)
                               NOT NULL
                               CONSTRAINT coLatitudeSeconds
                               CHECK (start_latitude_seconds >= 0 AND start_latitude_seconds <= 60),
                               
  end_latitude_degrees         NUMBER(3, 0) 
                               NOT NULL
                               CONSTRAINT coLatitudeDegrees 
                               CHECK (end_latitude_degrees >= 0 AND end_latitude_degrees <= 90),
  end_latitude_minutes         NUMBER(3, 0)
                               NOT NULL
                               CONSTRAINT coLatitudeMinutes
                               CHECK (end_latitude_minutes >= 0 AND end_latitude_minutes <= 60),
  end_latitude_seconds         NUMBER(3, 0)
                               NOT NULL
                               CONSTRAINT coLatitudeSeconds
                               CHECK (end_latitude_seconds >= 0 AND end_latitude_seconds <= 60),
  
  start_longitude_degrees      NUMBER(4, 0) 
                               NOT NULL
                               CONSTRAINT coLongitudeDegrees 
                               CHECK (start_longitude_degrees >= 0 AND start_longitude_degrees <= 180),
  start_longitude_minutes      NUMBER(3, 0)
                               NOT NULL
                               CONSTRAINT coLongitudeMinutes
                               CHECK (start_longitude_minutes >= 0 AND start_longitude_minutes <= 60),
  start_longitude_seconds      NUMBER(3, 0)
                               NOT NULL
                               CONSTRAINT coLongitudeSeconds
                               CHECK (start_longitude_seconds >= 0 AND start_longitude_seconds <= 60),

  end_longitude_degrees      NUMBER(4, 0) 
                               NOT NULL
                               CONSTRAINT coLongitudeDegrees 
                               CHECK (start_longitude_degrees >= 0 AND start_longitude_degrees <= 180),
  end_longitude_minutes      NUMBER(3, 0)
                               NOT NULL
                               CONSTRAINT coLongitudeMinutes
                               CHECK (start_longitude_minutes >= 0 AND start_longitude_minutes <= 60),
  end_longitude_seconds      NUMBER(3, 0)
                               NOT NULL
                               CONSTRAINT coLongitudeSeconds
                               CHECK (start_longitude_seconds >= 0 AND start_longitude_seconds <= 60), 
  as_decimal                   NUMBER(13, 9)
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
    temperature_id                   number(6, 0)
                                     default sqTemperatureSK.nextVal
                                     constraint DTemperaturePK primary key,
    surface_temperature_kelvin         number(6, 0)
                                     not null,
    surface_temperature_celsius        number(6, 0)
                                     not null,
    surface_temperature_fahrenheit     number(6, 0)
                                     not null,                            
    dew_point_temperature_kelvin        number(6, 0)
                                     not null,
    dew_point_emperature_celsius       number(6, 0)
                                     not null,
    dew_point_emperature_fahrenheit    number(6, 0)
                                     not null
)
;

create table D_Wind (   
    wind_id               number(6, 0)
                          default sqWindSK.nextVal
                          not null
                          constraint DWindPK primary key,
    direction             char(2)
                          not null,
    speed                 number(6, 2)
                          not null
)
;

create table D_Pressure (   
    pressure_id           number(6, 0)
                          default sqPressureSK.nextVal
                          constraint DPressurePK primary key,
    barometric_pressure    number(6, 2)
                          not null
)
;

create table D_Visibility (   
    visibility_id         number(6, 0)
                          default sqVisibilitySK.nextVal
                          constraint DVisibilityPK primary key,
    visibility            number(6, 0)
                          not null                       
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
                          REFERENCES D_GridCell (grid_id),
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