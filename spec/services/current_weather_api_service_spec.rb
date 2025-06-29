require 'rails_helper'

RSpec.describe CurrentWeatherApiService do
  let(:zip_code) { '10001' }
  let(:country_code) { 'US' }
  let(:service) { described_class.new(zip_code: zip_code, country_code: country_code) }

  let(:geocoding_response_body) do
    { "lat" => 40.7128, "lon" => -74.0060 }.to_json
  end

  let(:weather_response_body) do
    { "weather" => [{ "main" => "Clear" }], "main" => { "temp" => 22.5 } }.to_json
  end

  it 'returns weather data on success' do
    allow(Faraday).to receive(:get).and_return(
      double(success?: true, body: geocoding_response_body),
      double(success?: true, body: weather_response_body)
    )

    result = service.fetch

    expect(result[:weather]).to include("main" => { "temp" => 22.5 })
  end

  it 'returns error if geocoding API fails' do
    allow(Faraday).to receive(:get).and_return(double(success?: false))

    result = service.fetch

    expect(result[:error]).to eq("Invalid Zip Code or Country Code.")
  end

  it 'returns error if location not found' do
    allow(Faraday).to receive(:get).and_return(double(success?: true, body: {}.to_json))

    result = service.fetch

    expect(result[:error]).to eq("Location not found.")
  end

  it 'returns error if weather API fails' do
    allow(Faraday).to receive(:get).and_return(
      double(success?: true, body: geocoding_response_body),
      double(success?: false)
    )

    result = service.fetch

    expect(result[:error]).to eq("API error while fetching weather.")
  end

  it 'handles timeout gracefully' do
    allow(Faraday).to receive(:get).and_raise(Faraday::TimeoutError)

    result = service.fetch

    expect(result[:error]).to match(/Request timed out/)
  end
end
