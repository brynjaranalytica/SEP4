awk ' { printf("%s;%s;%s;%s;%s;%s;%s;%s\r\n", substr($0,1,length($0)-36), substr($0,length($0)-34,1), substr($0,length($0)-33,6), substr($0,length($0)-27,8), substr($0,length($0)-19,9), substr($0,length($0)-10,1), substr($0,length($0)-9,5), substr($0,length($0)-4,5)) } ' TempFiles/FetchedRecords.igc > PreparedFiles/DelimitedRecords.txt
