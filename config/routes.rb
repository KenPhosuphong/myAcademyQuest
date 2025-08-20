Rails.application.routes.draw do
  root "quests#index"
  resources :quests, only: [:index, :destroy, :create, :update]

  get "/brag", to: "brag#index", as: :brag
  get "up" => "rails/health#show", as: :rails_health_check

  # 🚨 must be last!
  match "*path", to: redirect("/"), via: :all
end