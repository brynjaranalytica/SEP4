echo Transform IGC Log Data
pause
sqlplus SEP4/Horsens@SEP4 @"Transform_IGC_1_Format_Date_Time"
sqlplus SEP4/Horsens@SEP4 @"Transform_IGC_2_Connect_Coordinates_Launch_Removed"
sqlplus SEP4/Horsens@SEP4 @"Transform_IGC_3_Latitude_Longitude_As_Decimal"
sqlplus SEP4/Horsens@SEP4 @"Transform_IGC_4_Split_To_Second_Segments"
sqlplus SEP4/Horsens@SEP4 @"Transform_IGC_5_Average_Latitude_Longitude"
sqlplus SEP4/Horsens@SEP4 @"Transform_IGC_6_Fetch_Grid_Cell_Id"
sqlplus SEP4/Horsens@SEP4 @"Transform_IGC_7_Join_Weather_Data"
sqlplus SEP4/Horsens@SEP4 @"Transform_IGC_8_Prepare_For_Load"
echo IGC Log Data Transformed
pause