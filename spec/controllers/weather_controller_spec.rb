require 'rails_helper'

RSpec.describe WeatherController, type: :controller do
  describe 'GET #search' do
    let(:zip_code) { '12345' }
    let(:country_code) { 'US' }

    context 'when API response is successful' do
      let(:weather_data) { { weather: { temp: 25, description: 'Sunny' } } }

      before do
        allow(CurrentWeatherApiService).to receive(:new)
          .with(zip_code: zip_code, country_code: country_code)
          .and_return(double(fetch: weather_data))
        get :search, params: { zip_code: zip_code, country_code: country_code }
      end

      it 'assigns @weather' do
        expect(assigns(:weather)).to eq(weather_data[:weather])
      end

      it 'renders the current_weather view' do
        expect(response).to render_template(:current_weather)
      end
    end

    context 'when API response has error' do
      let(:error_data) { { error: 'Invalid zip code' } }

      before do
        allow(CurrentWeatherApiService).to receive(:new)
          .and_return(double(fetch: error_data))
        get :search, params: { zip_code: zip_code, country_code: country_code }
      end

      it 'assigns @error_message' do
        expect(assigns(:error_message)).to eq('Invalid zip code')
      end

      it 'renders the address view' do
        expect(response).to render_template(:address)
      end
    end
  end

  describe 'GET #forecast' do
    let(:lat) { '40.7128' }
    let(:lon) { '-74.0060' }

    context 'when forecast is successful' do
      let(:forecast_data) do
        {
          forecast_data: [{ day: 'Monday', temp: 22 }],
          city_data: { name: 'New York' }
        }
      end

      before do
        allow(ExtendedForecastApiService).to receive(:new)
          .with(lat: lat, lon: lon)
          .and_return(double(fetch: forecast_data))
        get :forecast, params: { lat: lat, lon: lon }
      end

      it 'assigns @forecast and @city' do
        expect(assigns(:forecast)).to eq(forecast_data[:forecast_data])
        expect(assigns(:city)).to eq(forecast_data[:city_data])
      end

      it 'renders the upcoming_forecast view' do
        expect(response).to render_template(:upcoming_forecast)
      end
    end

    context 'when forecast API fails' do
      let(:error_data) { { error: 'Location not found' } }

      before do
        allow(ExtendedForecastApiService).to receive(:new)
          .and_return(double(fetch: error_data))
        get :forecast, params: { lat: lat, lon: lon }
      end

      it 'assigns @error_message' do
        expect(assigns(:error_message)).to eq('Location not found')
      end

      it 'renders the current_weather view' do
        expect(response).to render_template(:current_weather)
      end
    end
  end
end
