delete from D_VisibilityType;

-- Data not available
insert into D_VisibilityType
      values (-1, 'NULL');

declare
  type array_v is varray(2) of varchar(12);
  array array_v := array_v('NDV', 'NE');
begin
  for i in 1..array.count loop
    insert into D_VisibilityType
      values (DEFAULT, array(i));
  end loop;
commit;
end;
/
exit;