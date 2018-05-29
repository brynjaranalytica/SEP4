select delta_time, avg(delta_altitude), avg(delta_altitude)/delta_time
from transform_connected_coordinates
where delta_altitude >= 0
group by delta_time
order by delta_time;

select delta_time, avg(delta_altitude)
from transform_1
where delta_altitude <= 0
group by delta_time
order by delta_time;


select file_path, delta_time, start_time_of_log
from transform_1
where delta_time > 1000
;

select file_path, max(start_time_of_log)
from transform_1
group by file_path;

select *
from transform_1
order by delta_time desc;

select *
from transform_1
order by delta_altitude asc;

select count(*)
from transform_1;

select sum(delta_time) as seconds
from transform_connected_coordinates;
select count(*) as seconds
from transform_one_second_segments;

select sum(delta_altitude)
from transform_one_second_segments;

select sum(delta_altitude)
from transform_connected_coordinates;

select avg(start_latitude + end_latitude)
from transform_connected_coordinates
union
select avg(start_latitude + end_latitude)
from transform_one_second_segments;

select avg(start_longitude + end_longitude)
from transform_connected_coordinates
union
select avg(start_longitude + end_longitude)
from transform_one_second_segments;