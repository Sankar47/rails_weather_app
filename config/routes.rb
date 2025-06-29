Rails.application.routes.draw do
  root "weather#address"
  get "weather/current_weather", to: "weather#current_weather"
  get "weather/upcoming_forecast", to:"weather#upcoming_forecast"
  post "weather/search", to: "weather#search"
  post "weather/forecast", to: "weather#forecast"
end
