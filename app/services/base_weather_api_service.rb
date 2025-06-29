class BaseWeatherApiService
  def initialize
    @api_key = Rails.application.credentials.dig(:openweather, :api_key)
  end

  private

  def get(endpoint, params)
    Faraday.get(endpoint, params.merge(appid: @api_key))
  rescue Faraday::TimeoutError
    :timeout
  rescue StandardError => e
    e
  end

  def handle_response(response, error_message:)
    return { error: "Request timed out. Please try again later." } if response == :timeout
    return { error: "Unexpected error: #{response.message}" } if response.is_a?(StandardError)
    return { error: error_message } unless response.success?

    JSON.parse(response.body)
  end
end