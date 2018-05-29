grep -E -o -h '^[A-Z]{4},([^,]*,){20}[^,]*' WeatherDataFiles/* > TempFiles/FetchedWeatherData.txt
