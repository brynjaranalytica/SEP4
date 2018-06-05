/* ThermalAnalysis.sql
 *
 * This script contains all the logic for the identification of thermals from
 * the facts in the dimensional model.
 *
 * Several characteristics, such as probability and strength of thermals, are
 * calculalted for each grid cell in the d_gridcell dimension.
 */

/* Coordinates query
 * Fetches the latitude and longitude centers for each grid cell.
 */
drop table thermal_analysis_coordinates purge
;
 
create table thermal_analysis_coordinates as
select grid_cell_id
     , latitude_center as latitude
     , longitude_center as longitude
from d_gridcell
;

/* Thermal probability query
 * Joins a count of all positive delta altitudes with a count of all rows
 * for every grid cell and calculates the probability as positives / all.
 */
drop table thermal_analysis_probability purge
; 

create table thermal_analysis_probability as 
select all_delta_altitudes.grid_id as grid_cell_id
     , positive_delta_altitudes.row_count/all_delta_altitudes.row_count as thermal_probability
     , all_delta_altitudes.row_count as probability_sample_size_all
     , positive_delta_altitudes.row_count as probability_sample_size_positives
from (select grid_id
           , count(grid_id) as row_count
      from f_movement 
      group by grid_id) all_delta_altitudes
   , (select grid_id
           , count(grid_id) as row_count
      from f_movement 
      where delta_altitude > 0
      group by grid_id) positive_delta_altitudes
where all_delta_altitudes.grid_id = positive_delta_altitudes.grid_id
;

/* Thermal strength query
 * Calculates the strength as an average of positive delta_altitudes for every
 * grid cell.
 */
drop table thermal_analysis_strength purge
;
 
create table thermal_analysis_strength as 
select grid_id as grid_cell_id
     , avg(delta_altitude) as thermal_strength
     , count(grid_id) as strength_sample_size
from f_movement
where delta_altitude > 0
group by grid_id
;

/* Combined analysis
 * The seperate queries are joined together to form the complete thermal
 * analysis.
 */
drop table thermal_analysis_full purge
;

create table thermal_analysis_full as
select d_gridcell.grid_cell_id
     , latitude
     , longitude
     , thermal_probability
     , probability_sample_size_all
     , probability_sample_size_positives
     , thermal_strength
     , strength_sample_size
from d_gridcell
   , thermal_analysis_coordinates
   , thermal_analysis_probability
   , thermal_analysis_strength
where d_gridcell.grid_cell_id = thermal_analysis_coordinates.grid_cell_id 
  and d_gridcell.grid_cell_id = thermal_analysis_probability.grid_cell_id
  and d_gridcell.grid_cell_id = thermal_analysis_strength.grid_cell_id
;

/* Trimmed analysis
 * Removing certain columns columns to hide some details in the exportable
 * analysis.
 */
drop table thermal_analysis_exportable purge
;

create table thermal_analysis_exportable as
select latitude
     , longitude
     , thermal_probability
     , thermal_strength
from thermal_analysis_full
;


-- leftovers
create table thermal_analysis as
select d_gridcell.latitude_center as latitude
     , d_gridcell.longitude_center as longitude
     , avg(f_movement.delta_altitude) as thermal_strength
     , count(f_movement.grid_id) as sample_size
from f_movement, d_gridcell
where f_movement.grid_id = d_gridcell.grid_cell_id
  and f_movement.delta_altitude > 0
group by d_gridcell.latitude_center, d_gridcell.longitude_center
/* threshold*/
having avg(f_movement.delta_altitude) > (1 + 10 / sqrt(count(f_movement.grid_id)))
   and count(f_movement.grid_id) /*sample_size*/ > 10
;

select count(*)
from thermal_analysis
;

select *
from thermals, thermals_2
where thermals.thermal_probability = thermals_2.thermal_probability
;

select *
from thermals
;

commit;
