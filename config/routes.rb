Rails.application.routes.draw do
  root "weather#index"
  post "weather/search", to: "weather#search"
end
