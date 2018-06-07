delete from D_WindSpeed;

-- Data not available
insert into D_WindSpeed
          values (-1, -1, -1);

declare
   speed_knots number(6, 0) := 0;
   speed_knots_max number(6, 0) := 120;
   speed_meters_per_second number(6, 0);
begin
    while(speed_knots <= speed_knots_max) loop
      speed_meters_per_second := speed_knots * 0.514444;
      insert into D_WindSpeed
          values (DEFAULT, speed_knots, speed_meters_per_second);
      speed_knots := speed_knots + 1;
    end loop;
   commit;
end;
/
exit;
