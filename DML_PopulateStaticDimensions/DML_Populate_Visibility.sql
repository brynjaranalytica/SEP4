delete from D_Visibility;

-- Data not available
insert into D_Visibility
      values (-1, -1);

declare
  visibility number(6, 0) := 0000;
  visibility_max number(6, 0) := 9999;
begin
  while (visibility <= visibility_max) loop
    insert into D_Visibility
      values (DEFAULT, visibility);
    visibility := visibility + 1;       
  end loop;
  commit;
end;

