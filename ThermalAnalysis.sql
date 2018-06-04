drop table thermal_analysis purge
;

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
