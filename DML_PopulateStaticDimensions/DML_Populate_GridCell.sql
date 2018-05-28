delete from D_Gridcell;

-- Data not available
insert into D_GridCell
values (-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

declare
--- when we insert into the GridCell, we insert both the start coordinates and the end coordinates of the cell 
  current_latitude_degrees number(4, 0) := 54;
  current_latitude_minutes number(3, 0) := 30;
  current_latitude_seconds number(3, 0) := 0;
  current_latitude_as_decimal number(13, 10);
  
  current_longitude_degrees number(4, 0) := 8;
  current_longitude_minutes number(3, 0) := 0;
  current_longitude_seconds number(3, 0) := 0;
  current_longitude_as_decimal number(13, 10);
  
  next_latitude_degrees number(4, 0) := 54;
  next_latitude_minutes number(3, 0) := 30;
  next_latitude_seconds number(3, 0) := 0;
  next_latitude_as_decimal number(13, 10);
  
  next_longitude_degrees number(4, 0) := 8;
  next_longitude_minutes number(3, 0) := 0;
  next_longitude_seconds number(3, 0) := 0;
  next_longitude_as_decimal number(13, 10);
  
  end_latitude_degrees number(4, 0);
  end_latitude_minutes number(3, 0);
  end_latitude_seconds number(3, 0);
  end_latitude_as_decimal number(13, 10);
  
  end_longitude_degrees number(4, 0);
  end_longitude_minutes number(3, 0);
  end_longitude_seconds number(3, 0);
  end_longitude_as_decimal number(13, 10);
  
  --- these values are used to limit the number of records to be inserted into the table
  max_longitude_degrees number(4, 0) := 11;
  max_latitude_degrees number(4, 0) := 57;
  max_latitude_minutes number(3, 0) := 30;

begin
-- For each longitude value, all the possible combinations with a latitude value are inserted into the database
-- In this way we have the coordinates of the start and end point of each grid cell
  while current_longitude_degrees < max_longitude_degrees loop
    current_longitude_as_decimal := current_longitude_degrees + current_longitude_minutes/60 + current_longitude_seconds/3600;
   
    --calculate the longitude of the next cell
    if current_longitude_seconds = 0 then
       next_longitude_degrees := current_longitude_degrees;
       next_longitude_minutes := current_longitude_minutes;
       next_longitude_seconds := next_longitude_seconds + 30;
     else
       next_longitude_seconds := 0;
       next_longitude_minutes := current_longitude_minutes + 1;
       if current_longitude_minutes >= 60 then
         next_longitude_degrees := current_longitude_degrees + 1;
         next_longitude_minutes := 0;
       end if;
     end if;
     
     -- the end of the current cell has a longitude 1 second less than the longitude of the start of the next cell   
     if (next_longitude_seconds = 0) then
       end_longitude_degrees := next_longitude_degrees;
       end_longitude_minutes := next_longitude_minutes - 1;
       end_longitude_seconds := 59;
        if (end_longitude_minutes = -1) then 
          end_longitude_degrees := next_longitude_degrees - 1;
          end_longitude_minutes := 59;
        end if;
     else
       end_longitude_degrees := next_longitude_degrees;
       end_longitude_minutes := next_longitude_minutes;
       end_longitude_seconds := next_longitude_seconds - 1;
    end if;
    end_longitude_as_decimal := end_longitude_degrees + end_longitude_minutes/60 + end_longitude_seconds/3600;
    
    
    while ((current_latitude_degrees < max_latitude_degrees) or (current_latitude_minutes < max_latitude_minutes)) loop
        current_latitude_as_decimal := current_latitude_degrees + current_latitude_minutes/60 + current_latitude_seconds/3600;   
        
        -- calculate the latitude of the next cell
        if current_latitude_seconds = 0 or current_latitude_seconds = 15 or current_latitude_seconds = 30 then
          next_latitude_degrees := current_latitude_degrees;
          next_latitude_minutes := current_latitude_minutes;
          next_latitude_seconds := current_latitude_seconds + 15;          
        else
          next_latitude_seconds := 0;
          next_latitude_minutes := current_latitude_minutes + 1;    
          if next_latitude_minutes >= 60 then
            next_latitude_degrees := current_latitude_degrees + 1;
            next_latitude_minutes := 0;
          end if;
        end if;
        
        -- the end of the current cell has a latitude 1 second less than the latitude of the start of the next cell
        if(next_latitude_seconds = 0) then
          end_latitude_degrees := next_latitude_degrees;
          end_latitude_minutes := next_latitude_minutes - 1;
          end_latitude_seconds := 59;
          if (end_latitude_minutes = -1) then 
            end_latitude_degrees := next_latitude_degrees - 1;
            end_latitude_minutes := 59;
          end if;
        else
          end_latitude_degrees := next_latitude_degrees;
          end_latitude_minutes := next_latitude_minutes;
          end_latitude_seconds := next_latitude_seconds - 1;
        end if;
          end_latitude_as_decimal := end_latitude_degrees + end_latitude_minutes/60 + end_latitude_seconds/3600;
              
        insert into D_GridCell
        values(DEFAULT, 
              current_latitude_degrees, current_latitude_minutes, current_latitude_seconds, ROUND(current_latitude_as_decimal, 6), --start of cell latitude
              current_longitude_degrees, current_longitude_minutes, current_longitude_seconds, ROUND(current_longitude_as_decimal, 6), --start of cell longitude
              end_latitude_degrees, end_latitude_minutes, end_latitude_seconds, ROUND(end_latitude_as_decimal, 6), --end of cell latitude
              end_longitude_degrees, end_longitude_minutes, end_longitude_seconds, ROUND(end_longitude_as_decimal, 6) --end of cell longitude
              );
      
        current_latitude_degrees := next_latitude_degrees;
        current_latitude_minutes := next_latitude_minutes;
        current_latitude_seconds := next_latitude_seconds;
      
      end loop;
      
      current_latitude_degrees := 54;
      current_latitude_minutes := 30;
      current_latitude_seconds := 0;
      
      current_longitude_degrees := next_longitude_degrees;
      current_longitude_minutes := next_longitude_minutes;
      current_longitude_seconds := next_longitude_seconds;
  end loop;
commit;
end;
/
exit;