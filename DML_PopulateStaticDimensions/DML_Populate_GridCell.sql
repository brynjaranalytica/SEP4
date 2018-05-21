delete from D_Gridcell;

declare
  longitude_degrees number(4, 0) := 8;
  longitude_minutes number(3, 0) := 0;
  longitude_seconds number(3, 0) := 0;
  longitude_as_decimal number(13, 10);
  max_longitude_degrees number(4, 0) := 11;
  
  latitude_degrees number(4, 0) := 54;
  latitude_minutes number(3, 0) := 30;
  latitude_seconds number(3, 0) := 0;
  latitude_as_decimal number(13, 10);
  max_latitude_degrees number(4, 0) := 57;
  max_latitude_minutes number(3, 0) := 30;
begin
-- For each longitude value, all the possible combinations with a latitude value are inserted into the database
-- In this way we have the coordinates of the starting point of each grid cell
  while longitude_degrees < max_longitude_degrees loop
    longitude_as_decimal := longitude_degrees + longitude_minutes/60 + longitude_seconds/3600;
      while ((latitude_degrees < max_latitude_degrees) or (latitude_minutes < max_latitude_minutes))
      -- the following row in the condition is here because without it, either too little rows(withouth the combinations for latitude 57.5) 
      -- or too many rows (it inserts all of the combinations for 57.5, including 57.5 and 15 seconds, 30 seconds, etc.) are inserted
            or (latitude_degrees = 57 and latitude_minutes = 30 and latitude_seconds = 0) loop
        latitude_as_decimal := latitude_degrees + latitude_minutes/60 + latitude_seconds/3600;   
        
        insert into D_GridCell(grid_cell_id, latitude_degrees, latitude_minutes, latitude_seconds,
            latitude_as_decimal, longitude_degrees, longitude_minutes, longitude_seconds, longitude_as_decimal)
        values(DEFAULT, latitude_degrees, latitude_minutes, latitude_seconds, latitude_as_decimal,
              longitude_degrees, longitude_minutes, longitude_seconds, longitude_as_decimal);
  
        -- calculate the latitude of the next cell
        if latitude_seconds = 0 or latitude_seconds = 15 or latitude_seconds = 30 then
          latitude_seconds := latitude_seconds + 15;
        else
          latitude_seconds := 0;
          latitude_minutes := latitude_minutes + 1;    
          if latitude_minutes >= 60 then
            latitude_degrees := latitude_degrees + 1;
            latitude_minutes := 0;
          end if;
        end if;
      end loop;
      
      latitude_degrees := 54;
      latitude_minutes := 30;
      latitude_seconds := 0;
      
      --calculate the longitude of the next cell
      if longitude_seconds = 0 then
        longitude_seconds := longitude_seconds + 30;
      else
        longitude_seconds := 0;
        longitude_minutes := longitude_minutes + 1;
        if longitude_minutes >= 60 then
          longitude_degrees := longitude_degrees + 1;
          longitude_minutes := 0;
        end if;
      end if;
  end loop;
commit;
end;