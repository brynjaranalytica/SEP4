delete from D_CloudCoverage;

declare
  cloud_height number(6, 0) := 100;
  cloud_height_max number(6, 0) := 60000;
  type array_c is varray(4) of varchar(4);
  array array_c := array_c('FEW', 'SCT', 'BKN', 'OVC');
begin
  
     while (cloud_height <= cloud_height_max) loop 
     for i in 1..array.count loop
        insert into D_CloudCoverage(cloud_coverage_id, cloud_coverage, cloud_height)
        values (DEFAULT, array(i), cloud_height);
       end loop;  
        cloud_height := cloud_height + 1;      
      
  end loop;
  commit;
end;

insert into D_CloudCoverage(cloud_coverage_id, cloud_coverage, cloud_height)
        values (DEFAULT, 'NSC', -1);

select count(*) from D_CloudCoverage;
