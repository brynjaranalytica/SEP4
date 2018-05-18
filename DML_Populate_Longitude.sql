delete from D_Longitude;


-- A grid covering Denmark starts at longitude 8 degrees East and extends to 11 degrees East
-- For our purposes, we overlay Denmark with a grid that is 1/2 a minute (30 seconds) of arc West to East
declare
  start_longitude_degrees number(4, 0) := 8;
  start_longitude_minutes number(3, 0) := 0;
  start_longitude_seconds number(3, 0) := 0;
  as_decimal number(13, 9);
  end_longitude_degrees number(4, 0) := 11;
begin
  while start_longitude_degrees < end_longitude_degrees loop
    as_decimal := start_longitude_degrees + start_longitude_minutes/60 + start_longitude_seconds/3600;
    insert into D_Longitude(longitude_id, degrees, minutes, seconds, as_decimal)
    values(
      DEFAULT,
      start_longitude_degrees,
      start_longitude_minutes,
      start_longitude_seconds,
      as_decimal
    );
    
    if start_longitude_seconds = 0 then
      start_longitude_seconds := start_longitude_seconds + 30;
    else
      start_longitude_seconds := 0;
      start_longitude_minutes := start_longitude_minutes + 1;
      if start_longitude_minutes >= 60 then
        start_longitude_degrees := start_longitude_degrees + 1;
        start_longitude_minutes := 0;
      end if;
    end if;
  end loop;
  commit;
end;
