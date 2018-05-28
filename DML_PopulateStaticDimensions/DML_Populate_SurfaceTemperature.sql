delete from D_SurfaceTemperature;

-- Data not available
insert into D_SurfaceTemperature
      values (-1, -1, -1, -1);

declare
  temperature_celsius number(6, 0) := -30;
  temperature_celsius_max number(6, 0) := 50;
  temperature_kelvin number(6, 0);
  temperature_fahrenheit number(6, 0); 
begin
  while (temperature_celsius <= temperature_celsius_max) loop
    temperature_kelvin := temperature_celsius + 273.15;
    temperature_fahrenheit := temperature_celsius * 1.8 + 32;
    insert into D_SurfaceTemperature
      values (DEFAULT, temperature_kelvin, temperature_celsius, temperature_fahrenheit);
    temperature_celsius := temperature_celsius + 1;
  end loop;
commit;
end;
