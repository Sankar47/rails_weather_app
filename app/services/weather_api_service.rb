class WeatherApiService
  def initialize(zip_code:, country_code:)
    @zip_code = zip_code
    @country_code = country_code
    @api_key = Rails.application.credentials.dig(:openweather, :api_key)
  end

  def fetch
    location_resp = Faraday.get(WEATHER_API_ENDPOINTS[:geocoding], {
      zip: "#{@zip_code},#{@country_code}",
      appid: @api_key
    })

    return { error: "API error while fetching location." } unless location_resp.success?

    location_data = JSON.parse(location_resp.body)
    return { error: "Location not found." } if location_data.blank?

    lat = location_data["lat"]
    lon = location_data["lon"]

    weather_resp = Faraday.get(WEATHER_API_ENDPOINTS[:current_weather], {
      lat: lat,
      lon: lon,
      appid: @api_key,
      units: "metric"
    })

    return { error: "API error while fetching weather." } unless weather_resp.success?

    { weather: JSON.parse(weather_resp.body) }
  rescue Faraday::TimeoutError
    { error: "Request timed out. Please try again later." }
  rescue StandardError => e
    { error: "Unexpected error: #{e.message}" }
  end

  def fetch_extended_forecast(lat:, lon:)
    forecast_resp = Faraday.get(WEATHER_API_ENDPOINTS[:forecast], {
      lat: lat,
      lon: lon,
      units: "metric",
      cnt: WEATHER_EXTENDED_FORECAST_DAYS,
      appid: @api_key
    })

    return [] unless forecast_resp.success?

    forecast_data = JSON.parse(forecast_resp.body)

    forecast_table_data = forecast_data["list"].map do |entry|
      {
        date: Time.at(entry["dt"]).to_date,
        temp: entry["main"]["temp"],
        feels_like: entry["main"]["feels_like"],
        min: entry["main"]["temp_min"],
        max: entry["main"]["temp_max"]
      }
    end

    city_data = forecast_data["city"]

    return forecast_table_data, city_data
  rescue Faraday::TimeoutError
    { error: "Request timed out. Please try again later." }
  rescue => e
    Rails.logger.error("Extended forecast error: #{e.message}")
    []
  end
end
