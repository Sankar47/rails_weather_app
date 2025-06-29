class CurrentWeatherApiService < BaseWeatherApiService
  def initialize(zip_code:, country_code:)
    super()
    @zip_code = zip_code
    @country_code = country_code
  end

  def fetch
    location_resp = get_geocoding_data
    location_data = handle_response(location_resp, error_message: "Invalid Zip Code or Country Code.")
    return location_data if location_data[:error]
    return { error: "Location not found." } if location_data.blank?

    @lat = location_data["lat"]
    @lon = location_data["lon"]

    weather_resp = get_weather_data
    weather_data = handle_response(weather_resp, error_message: "API error while fetching weather.")
    return weather_data if weather_data[:error]

    { weather: weather_data }
  end

  private

  def get_geocoding_data
    get(
      WEATHER_API_ENDPOINTS[:geocoding],
      zip: "#{@zip_code},#{@country_code}"
    )
  end

  def get_weather_data
    get(
      WEATHER_API_ENDPOINTS[:current_weather],
      lat: @lat,
      lon: @lon,
      units: "metric"
    )
  end
end
