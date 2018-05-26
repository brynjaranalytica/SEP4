drop table GridCellToAirport;
drop table weather_stations;

-- when running this on the server, don't create the weather_stations table
-- because it's already there
-- i've created it in order to test the GridCellToAirport table

create table weather_stations (
  INITIALS char(4) CONSTRAINT airport_initials PRIMARY KEY,
  latitude number(13, 6) NOT NULL,
  longitude number(13, 6) NOT NULL
);

INSERT INTO weather_stations VALUES ('EKYT', 57.0964, 9.8506);
INSERT INTO weather_stations VALUES ('EKSN', 57.5044, 10.2228);
INSERT INTO weather_stations VALUES ('EKVD', 55.4375, 9.3336);
INSERT INTO weather_stations VALUES ('EKSP', 55.2253, 9.2633);
INSERT INTO weather_stations VALUES ('EKKA', 56.2933, 9.1139);
INSERT INTO weather_stations VALUES ('EKVJ', 55.9911, 8.3539);
INSERT INTO weather_stations VALUES ('EKBI', 55.7381, 9.1675);
INSERT INTO weather_stations VALUES ('EKAH', 56.3083, 10.6256);
INSERT INTO weather_stations VALUES ('EKEB', 55.5281, 8.5631);
INSERT INTO weather_stations VALUES ('EKSB', 54.9622, 9.7875);

create table ETL_GridCellToAirport(
  cell_id number(6, 0) REFERENCES D_GridCell(grid_cell_id),
  airport char(4) REFERENCES Weather_stations(initials)
);