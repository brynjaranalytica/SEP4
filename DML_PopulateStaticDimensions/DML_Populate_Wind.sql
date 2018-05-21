delete from D_Wind;

declare
   speed_knots number(6, 0) := 0;
   speed_knots_max number(6, 0) := 120;
   speed_meters_per_second number(6, 0);
   type array_t is varray(8) of varchar2(2);
   array array_t := array_t('S', 'N', 'E', 'W', 'SE', 'NE', 'SW', 'NW');
begin
    while(speed_knots <= speed_knots_max) loop
      speed_meters_per_second := speed_knots * 0.514444;
      for i in 1..array.count loop
        insert into D_Wind (wind_id, direction, speed_knots, speed_meters_per_second)
          values (DEFAULT, array(i), speed_knots, speed_meters_per_second);
      end loop;
      speed_knots := speed_knots + 1;
   end loop;
end;