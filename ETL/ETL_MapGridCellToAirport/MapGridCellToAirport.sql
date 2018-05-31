/* This script locates the nearest weather station for each grid cell and 
 * assigns it to a new column in the dimension.
 */
 
/* A view of every station and their coordinates is located in the external
 * weather data.
 */
drop materialized view weather_stations
;

create materialized view weather_stations as
select distinct(station) as station_initials
     , to_number(latitude, '99.9999') as latitude
     , to_number(longitude, '99.9999') as longitude
from external_weather_data
;

/* The center of latitude and longitude is calculated for each grid cell
 * to be used as reference point of the cell.
 */
alter table d_gridcell
drop column latitude_center
;

alter table d_gridcell
drop column longitude_center
;

alter table d_gridcell
add latitude_center as
((end_lat_as_decimal + start_lat_as_decimal) / 2)
;

alter table d_gridcell
add longitude_center as
((end_long_as_decimal + start_long_as_decimal) / 2)
;

/* Then the distance to each weather station is calculated by the Pythagorean
 * equation for each grid cell.
 */
drop materialized view distance_to_station
;
 
create materialized view distance_to_station as
select a.grid_cell_id, b.station_initials, sqrt(power(a.latitude_center - b.latitude, 2) + power(a.longitude_center - b.longitude, 2)) as distance
from (select * from d_gridcell) a, weather_stations b
;

/* Then the shortest distance for each grid cell is determined. */
drop materialized view shortest_distance
;

create materialized view shortest_distance as
select grid_cell_id, station_initials as nearest_airport, distance
from distance_to_station a
where distance <= (select min(distance) from distance_to_station b where a.grid_cell_id = b.grid_cell_id)
order by grid_cell_id
;

/* Then a column is added to the dimension for grid cells holding the initials
 * of the nearest station. Every grid cell looks into the view of shortest
 * distances and sets the new column value as the found weather station. An 
 * index is added to the materialized view to decrease the lookup time for each 
 * grid cell.
 */
create index ix_shortest_distance_id on shortest_distance(grid_cell_id)
;

execute dbms_stats.gather_table_stats('SEP4','SHORTEST_DISTANCE')
;

alter table d_gridcell
drop column nearest_weather_station
;

alter table d_gridcell
add nearest_weather_station char(4)
;

update d_gridcell a
set nearest_weather_station = (select nearest_airport from shortest_distance b where a.grid_cell_id = b.grid_cell_id)
;

drop materialized view weather_stations
;

drop materialized view distance_to_station
;

drop materialized view shortest_distance
;