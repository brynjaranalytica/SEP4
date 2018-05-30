echo Transform weather data
pause
sqlplus SEP4/Horsens@SEP4 @"1_Transform_Weather_Columns"
sqlplus SEP4/Horsens@SEP4 @"2_Transform_Weather_Timestamp"
sqlplus SEP4/Horsens@SEP4 @"3_Transform_Weather_Wind"
sqlplus SEP4/Horsens@SEP4 @"4_Transform_Weather_Temperature"
sqlplus SEP4/Horsens@SEP4 @"5_Transform_Weather_PressureAltitude"
sqlplus SEP4/Horsens@SEP4 @"6_Transform_Weather_Visibility"
sqlplus SEP4/Horsens@SEP4 @"7_Transform_Weather_Clouds"
sqlplus SEP4/Horsens@SEP4 @"8_Transformed_Weather_Data"
echo Weather data transformed
pause