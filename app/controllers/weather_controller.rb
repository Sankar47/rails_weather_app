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

    handle_weather_response(
      service: CurrentWeatherApiService.new(zip_code: @zip_code, country_code: @country_code),
      render_view: :current_weather,
      success_block: ->(result) { @weather = result[:weather] }
    )
  end

  def forecast
    @lat = params[:lat]
    @lon = params[:lon]

    handle_weather_response(
      service: ExtendedForecastApiService.new(lat: @lat, lon: @lon),
      render_view: :upcoming_forecast,
      success_block: ->(result) {
        @forecast = result[:forecast_data]
        @city = result[:city_data]
      }
    )
  end

  private

  def handle_weather_response(service:, render_view:, success_block:)
    result = service.fetch

    if result[:error]
      @error_message = result[:error]
    else
      success_block.call(result)
    end

    render render_view
  end
end

