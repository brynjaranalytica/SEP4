echo Create and populate dimensional model
pause
sqlplus SEP4/Horsens@SEP4 @"C:\Users\dea\Desktop\SEP4D\git\DDL_DimensionalModel"
sqlplus SEP4/Horsens@SEP4 @"DML_Populate_CloudAltitude"
sqlplus SEP4/Horsens@SEP4 @"DML_Populate_CloudCoverage"
sqlplus SEP4/Horsens@SEP4 @"DML_Populate_Date"
sqlplus SEP4/Horsens@SEP4 @"DML_Populate_DewPointTemperature"
sqlplus SEP4/Horsens@SEP4 @"DML_Populate_GridCell"
sqlplus SEP4/Horsens@SEP4 @"DML_Populate_Pressure"
sqlplus SEP4/Horsens@SEP4 @"DML_Populate_SurfaceTemperature"
sqlplus SEP4/Horsens@SEP4 @"DML_Populate_Time"
sqlplus SEP4/Horsens@SEP4 @"DML_Populate_Visibility"
sqlplus SEP4/Horsens@SEP4 @"DML_Populate_VisibilityType"
sqlplus SEP4/Horsens@SEP4 @"DML_Populate_WindDirection"
sqlplus SEP4/Horsens@SEP4 @"DML_Populate_WindSpeed"
echo Dimensional model created and populated
pause