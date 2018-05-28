delete from D_TEMPERATURE;

-- Data not available
insert into D_Temperature
      values (-1, -1, -1, -1, -1, -1, -1);

declare
  temperature_celsius number(6, 0) := -30;
  temperature_celsius_max number(6, 0) := 50;
  temperature_kelvin number(6, 0);
  temperature_fahrenheit number(6, 0); 
  
  dew_point_temperature_celsius number(6, 0) := -65;
  dew_point_temperature_celsius_max number(6, 0) := 50;
  dew_point_temperature_kelvin number(6, 0);
  dew_point_temperature_fahrenheit number(6, 0);
begin

  while (temperature_celsius <= temperature_celsius_max) loop
  
    while (dew_point_temperature_celsius <= dew_point_temperature_celsius_max) loop   
    
      temperature_kelvin := temperature_celsius + 273.15;
      dew_point_temperature_kelvin := dew_point_temperature_celsius + 273.15;
      temperature_fahrenheit := temperature_celsius * 1.8 + 32;
      dew_point_temperature_fahrenheit := dew_point_temperature_celsius * 1.8 + 32;
      
      insert into D_Temperature
      values (DEFAULT, temperature_kelvin, temperature_celsius, temperature_fahrenheit, 
      dew_point_temperature_kelvin, dew_point_temperature_celsius, dew_point_temperature_fahrenheit);
      
      dew_point_temperature_celsius := dew_point_temperature_celsius + 1;
    end loop;
    temperature_celsius := temperature_celsius + 1;
    dew_point_temperature_celsius := -65;
  end loop;
  commit;
end;
