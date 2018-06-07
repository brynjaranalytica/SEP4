delete from d_date;

-- Data not available
insert into D_Date
    values(-1, to_date('31-12-9999', 'DD-MM-YYYY'), 31, 12, 9999);
 
declare
  selected_date date := to_date('01-01-1960', 'DD-MM-YYYY');
--you can choose until when do you want to insert dates
  last_date date := to_date('01-01-2060', 'DD-MM-YYYY');
--or how many rows do you want to insert
  no_of_dates int := 100;
begin
  while selected_date <= last_date loop
    insert into D_Date
    values(
      DEFAULT,
      selected_date,
      extract(day from selected_date), 
      extract(month from selected_date), 
      extract(year from selected_date));
    
      selected_date := selected_date + INTERVAL '1' DAY;
  end loop;
  commit;
end;
/
exit;