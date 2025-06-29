WEATHER_API_ENDPOINTS = {
  geocoding: "http://api.openweathermap.org/geo/1.0/zip",
  current_weather: "https://api.openweathermap.org/data/2.5/weather",
  forecast: "https://api.openweathermap.org/data/2.5/forecast"
}.freeze

WEATHER_TIMEOUT_SECONDS = 5
WEATHER_EXTENDED_FORECAST_DAYS = 7
WEATHER_CACHE_DURATION = 30.minutes