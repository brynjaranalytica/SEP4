To prepare files, insert desired files into 'LogFiles' and execute 'run_all.bat' - 'PreparedFiles' will hold the result.

------------------------------------------------------------------------------------------------------------------------

Executing 'run_all.bat' runs all the '.sh' scripts.

'grep_fetch_records.sh' fetches all lines that match the glider record entry presented to us in the project proposal
from the 'LogFiles' directory. 
(type, coordinates, altitude, etc.).

'grep_fetch_dates.sh' fetches all dates in the headers of files in the 'LogFiles' directory.

Fetched records and dates are stored in TempFiles.

The 'awk_delimit_dates.sh' and 'awk_delimit_records.sh' scripts insert delimiters in the temporary files
making them ready to be picked up by whatever database.