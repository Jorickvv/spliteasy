Rails.application.routes.draw do
  devise_for :users

  root to: "pages#home"

  
  get "up" => "rails/health#show", as: :rails_health_check

  resources :groups do
    resources :expenses
  end


  get "join", to: "groups#join", as: :join_group
  post "join", to: "groups#join_create"
end
