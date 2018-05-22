delete from D_Visibility;

declare
  visibility number(6, 0) := 0000;
  visibility_max number(6, 0) := 9999;
  type array_v is varray(3) of varchar(12);
  array array_v := array_v('NDV', 'NE', null);
begin
  
     while (visibility <= visibility_max) loop
     for i in 1..array.count loop
        insert into D_Visibility(visibility_id, visibility, visibility_type)
        values (DEFAULT, visibility, array(i));
       end loop;
        visibility := visibility + 1;       
  end loop;
  commit;
end;

select count(*) from D_Visibility;