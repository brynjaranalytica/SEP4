delete from D_CloudAltitude;

-- Data not available
insert into D_CloudAltitude
      values (-1, -1);

declare
  cloud_height number(6, 0) := 100;
  cloud_height_max number(6, 0) := 60000;
begin
  while (cloud_height <= cloud_height_max) loop 
    insert into D_CloudAltitude
      values (DEFAULT, cloud_height);
    cloud_height := cloud_height + 1;      
  end loop;
commit;
end;
/
exit;