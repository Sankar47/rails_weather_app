require 'rails_helper'

RSpec.describe ExtendedForecastApiService do
  let(:lat) { 40.7128 }
  let(:lon) { -74.0060 }
  let(:service) { described_class.new(lat: lat, lon: lon) }

  let(:forecast_response_body) do
    {
      "list" => [
        {
          "dt" => Time.now.to_i,
          "main" => {
            "temp" => 21.5,
            "feels_like" => 20.0,
            "temp_min" => 19.0,
            "temp_max" => 23.0
          }
        }
      ],
      "city" => { "name" => "New York" }
    }.to_json
  end

  it 'returns forecast data on success' do
    allow(Faraday).to receive(:get).and_return(double(success?: true, body: forecast_response_body))

    result = service.fetch

    expect(result[:forecast_data].first[:temp]).to eq(21.5)
    expect(result[:city_data]["name"]).to eq("New York")
  end

  it 'returns error if forecast API fails' do
    allow(Faraday).to receive(:get).and_return(double(success?: false))

    result = service.fetch

    expect(result[:error]).to eq("API error while fetching forecast.")
  end

  it 'handles timeout gracefully' do
    allow(Faraday).to receive(:get).and_raise(Faraday::TimeoutError)

    result = service.fetch

    expect(result[:error]).to match(/Request timed out/)
  end
end
