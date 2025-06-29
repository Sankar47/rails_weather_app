class WeatherController < ApplicationController
  def address
  end

  def current_weather
  end

  def upcoming_forecast
  end

  def search
    @zip_code = params[:zip_code]
    @country_code = params[:country_code]

    result = CurrentWeatherApiService.new(
      zip_code: @zip_code,
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
    @lat = params[:lat]
    @lon = params[:lon]

    result = ExtendedForecastApiService.new(
      lat: @lat,
      lon: @lon
    ).fetch

    if result[:error]
      @error_message = result[:error]
    else
      @forecast, @city = result[:forecast_data], result[:city_data]
    end

    render :upcoming_forecast
  end
end

