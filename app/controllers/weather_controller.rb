class WeatherController < ApplicationController
  def address
  end

  def current_weather
  end

  def upcoming_forecast
  end

  def search
    @city = params[:city]
    @state = params[:state]
    @country_code = params[:country_code]

    result = WeatherApiService.new(
      city: @city,
      state: @state,
      country_code: @country_code
    ).fetch

    if result[:error]
      @error_message = result[:error]
    else
      @weather = result[:weather]
    end

    render :current_weather
  end

  def forecast
    lat = params[:lat]
    lon = params[:lon]
    service = WeatherApiService.new(city: "", state: "", country_code: "")
    @forecast, @city = service.fetch_extended_forecast(lat: lat, lon: lon)

    render :upcoming_forecast
  end
end

