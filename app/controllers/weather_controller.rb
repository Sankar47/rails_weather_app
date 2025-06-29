class WeatherController < ApplicationController
  def index
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

    render :index
  end
end

