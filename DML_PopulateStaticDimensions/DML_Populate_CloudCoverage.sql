delete from D_CloudCoverage;

-- Data not available
insert into D_CloudCoverage
      values (-1, 'NULL');

declare
  type array_c is varray(5) of varchar(4);
  array array_c := array_c('FEW', 'SCT', 'BKN', 'OVC', 'NCD');
begin
  for i in 1..array.count loop
    insert into D_CloudCoverage
      values (DEFAULT, array(i));
  end loop;  
commit;
end;
/
exit;