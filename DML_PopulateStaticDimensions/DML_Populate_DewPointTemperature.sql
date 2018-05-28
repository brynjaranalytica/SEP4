delete from D_DewPointTemperature;

-- Data not available
insert into D_DewPointTemperature
      values (-1, -1, -1, -1);

declare
  dew_point_temperature_celsius number(6, 0) := -65;
  dew_point_temperature_celsius_max number(6, 0) := 50;
  dew_point_temperature_kelvin number(6, 0);
  dew_point_temperature_fahrenheit number(6, 0);
begin
  while (dew_point_temperature_celsius <= dew_point_temperature_celsius_max) loop   
    dew_point_temperature_kelvin := dew_point_temperature_celsius + 273.15;
    dew_point_temperature_fahrenheit := dew_point_temperature_celsius * 1.8 + 32;
    insert into D_DewPointTemperature
      values (DEFAULT, dew_point_temperature_kelvin, dew_point_temperature_celsius, dew_point_temperature_fahrenheit);
    dew_point_temperature_celsius := dew_point_temperature_celsius + 1;
  end loop;
commit;
end;
