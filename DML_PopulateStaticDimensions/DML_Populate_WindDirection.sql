delete from D_WindDirection;

-- Data not available
insert into D_WindDirection
          values (-1, 'NULL');

declare
   type array_t is varray(9) of varchar2(3);
   array array_t := array_t('S', 'N', 'E', 'W', 'SE', 'NE', 'SW', 'NW');
begin
   for i in 1..array.count loop
      insert into D_WindDirection
          values (DEFAULT, array(i));      
   end loop;
   commit;
end;

