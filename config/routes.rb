Rails.application.routes.draw do
  root "pages#home"

  get "services", to: "service_types#index", as: :services
  get "visit", to: "pages#visit", as: :visit
  get "about", to: "pages#about", as: :about

  resources :customers,     only: [:index, :show]
  resources :bikes,         only: [:index, :show]
  resources :repairs,       only: [:index, :show]
  resources :service_types, only: [:index, :show]
  resources :staff_members, only: [:index, :show]

  get "up" => "rails/health#show", as: :rails_health_check
end