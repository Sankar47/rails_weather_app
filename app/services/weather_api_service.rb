class WeatherApiService
  BASE_URL = "http://api.openweathermap.org/geo/1.0/direct"
  WEATHER_URL = "https://api.openweathermap.org/data/2.5/weather"

  def initialize(city:, state:, country_code:)
    @city = city
    @state = state
    @country_code = country_code
    @api_key = Rails.application.credentials.dig(:openweather, :api_key)
  end

  def fetch
    location_resp = Faraday.get(BASE_URL, {
      q: "#{@city},#{@state},#{@country_code}",
      limit: 1,
      appid: @api_key
    })

    return { error: "API error while fetching location." } unless location_resp.success?

    location_data = JSON.parse(location_resp.body)
    return { error: "Location not found." } if location_data.empty?

    lat = location_data.first["lat"]
    lon = location_data.first["lon"]

    weather_resp = Faraday.get(WEATHER_URL, {
      lat: lat,
      lon: lon,
      appid: @api_key,
      units: "metric"
    })

    return { error: "API error while fetching weather." } unless weather_resp.success?

    { weather: JSON.parse(weather_resp.body) }
  rescue StandardError => e
    { error: "Unexpected error: #{e.message}" }
  end
end
