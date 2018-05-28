delete from D_Pressure;

-- Data not available
insert into D_Pressure
      values (-1, -1);

declare
  pressure number(6, 0) := 600;
  pressure_max number(6, 0) := 2000;
  
begin
  while (pressure <= pressure_max) loop
  
  insert into D_Pressure
      values (DEFAULT, pressure);
      pressure := pressure + 1;
    end loop;
    commit;
end;
/
exit;