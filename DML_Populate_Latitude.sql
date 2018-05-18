delete from D_Latitude;

-- Inserting the last row of the latitude (57 degrees, 30 minutes, 0 seconds) by hand because I can't make the procedure insert it
insert into D_Latitude(latitude_id, degrees, minutes, seconds, as_decimal)
    values(DEFAULT, 57, 30, 0, 57+30/60+0/3600);

-- A grid covering Denmark starts at latitude 54 degrees, 30 minutes North and extends to 57 degrees, 30 minutes Northt
-- For our purposes, we overlay Denmark  with a grid that is 1/4 minute (15 seconds) of arc South to North 
declare
  start_latitude_degrees number(4, 0) := 54;
  start_latitude_minutes number(3, 0) := 30;
  start_latitude_seconds number(3, 0) := 0;
  as_decimal number(13, 9);
  end_latitude_degrees number(4, 0) := 57;
  end_latitude_minutes number(3, 0) := 30;
begin
  while (start_latitude_degrees < end_latitude_degrees) or (start_latitude_minutes < end_latitude_minutes) loop
    as_decimal := start_latitude_degrees + start_latitude_minutes/60 + start_latitude_seconds/3600;   
    insert into D_Latitude(latitude_id, degrees, minutes, seconds, as_decimal)
    values(
      DEFAULT,
      start_latitude_degrees,
      start_latitude_minutes,
      start_latitude_seconds,
      as_decimal
    );
    
    if start_latitude_seconds = 0 or start_latitude_seconds = 15 or start_latitude_seconds = 30 then
      start_latitude_seconds := start_latitude_seconds + 15;
    else
      start_latitude_seconds := 0;
      start_latitude_minutes := start_latitude_minutes + 1;    
      if start_latitude_minutes >= 60 then
        start_latitude_degrees := start_latitude_degrees + 1;
        start_latitude_minutes := 0;
      end if;
    end if;
  end loop;
  commit;
end;
