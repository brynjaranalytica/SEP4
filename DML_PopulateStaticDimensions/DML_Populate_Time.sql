-- Time dimension population:
delete from D_Time;

-- Data not available
insert into D_Time(time_id, hour, minute, second)
    values(-1, -1, -1, -1);

declare
  selected_time date := to_date('00:00:00', 'HH24:MI:SS');
--you can choose until when do you want to insert time
  last_time date := to_date('23:59:59', 'HH24:MI:SS');
--or how many rows do you want to insert
  no_of_rows int := 100;
begin
  while selected_time <= last_time loop
    insert into D_Time(hour, minute, second)
    values(
      to_number(to_char(selected_time, 'HH24')),
      to_number(to_char(selected_time, 'MI')),
      to_number(to_char(selected_time, 'SS'))
    );

    selected_time := selected_time + INTERVAL '1' SECOND;
  end loop;
  commit;
end;