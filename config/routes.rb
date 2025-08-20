Rails.application.routes.draw do
  resources :quests
  root "quests#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
