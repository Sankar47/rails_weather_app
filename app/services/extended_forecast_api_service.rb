class ExtendedForecastApiService
  def initialize(lat:, lon:)
    @lat = lat
    @lon = lon
    @api_key = Rails.application.credentials.dig(:openweather, :api_key)
  end

  def fetch
    result = {}
    forecast_resp = Faraday.get(WEATHER_API_ENDPOINTS[:forecast], {
      lat: @lat,
      lon: @lon,
      units: "metric",
      cnt: WEATHER_EXTENDED_FORECAST_DAYS,
      appid: @api_key
    })

    return [] unless forecast_resp.success?

    forecast_data = JSON.parse(forecast_resp.body)

    result[:forecast_data] = forecast_data["list"].map do |entry|
      {
        date: Time.at(entry["dt"]).to_date,
        temp: entry["main"]["temp"],
        feels_like: entry["main"]["feels_like"],
        min: entry["main"]["temp_min"],
        max: entry["main"]["temp_max"]
      }
    end

    result[:city_data] = forecast_data["city"]

    return result
  rescue Faraday::TimeoutError
    { error: "Request timed out. Please try again later." }
  rescue StandardError => e
    { error: "Unexpected error: #{e.message}" }
  end
end
