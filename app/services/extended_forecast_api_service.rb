class ExtendedForecastApiService < BaseWeatherApiService
  def initialize(lat:, lon:)
    super()
    @lat = lat
    @lon = lon
  end

  def fetch
    forecast_resp = get(
      WEATHER_API_ENDPOINTS[:forecast],
      lat: @lat,
      lon: @lon,
      units: "metric",
      cnt: WEATHER_EXTENDED_FORECAST_DAYS
    )
    forecast_data = handle_response(forecast_resp, error_message: "API error while fetching forecast.")
    return forecast_data if forecast_data[:error]

    {
      forecast_data: forecast_data["list"].map do |entry|
        {
          date: Time.at(entry["dt"]).to_date,
          temp: entry["main"]["temp"],
          feels_like: entry["main"]["feels_like"],
          min: entry["main"]["temp_min"],
          max: entry["main"]["temp_max"]
        }
      end,
      city_data: forecast_data["city"]
    }
  end
end
