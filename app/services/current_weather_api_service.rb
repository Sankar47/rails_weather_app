class CurrentWeatherApiService < BaseWeatherApiService
  def initialize(zip_code:, country_code:)
    super()
    @zip_code = zip_code
    @country_code = country_code
  end

  def fetch
    location_resp = get(
      WEATHER_API_ENDPOINTS[:geocoding],
      zip: "#{@zip_code},#{@country_code}"
    )
    location_data = handle_response(location_resp, error_message: "API error while fetching location.")
    return location_data if location_data[:error]
    return { error: "Location not found." } if location_data.blank?

    lat = location_data["lat"]
    lon = location_data["lon"]

    weather_resp = get(
      WEATHER_API_ENDPOINTS[:current_weather],
      lat: lat,
      lon: lon,
      units: "metric"
    )
    weather_data = handle_response(weather_resp, error_message: "API error while fetching weather.")
    return weather_data if weather_data[:error]

    { weather: weather_data }
  end
end
