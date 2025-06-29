class ExtendedForecastApiService < BaseWeatherApiService
  def initialize(lat:, lon:)
    super()
    @lat = lat
    @lon = lon
  end

  def fetch
    forecast_resp = get_extended_forecast
    forecast_data = handle_response(forecast_resp, error_message: "API error while fetching forecast.")
    return forecast_data if forecast_data[:error]

    build_forecast_data(forecast_data)
  end

  private

  def get_extended_forecast
    get(
      WEATHER_API_ENDPOINTS[:forecast],
      lat: @lat,
      lon: @lon,
      units: "metric",
      cnt: WEATHER_EXTENDED_FORECAST_DAYS
    )
  end

  def build_forecast_data(data)
    {
      forecast_data: data["list"].map do |entry|
        {
          date: Time.at(entry["dt"]).to_date,
          temp: entry["main"]["temp"],
          feels_like: entry["main"]["feels_like"],
          min: entry["main"]["temp_min"],
          max: entry["main"]["temp_max"]
        }
      end,
      city_data: data["city"]
    }
  end
end
