Rails.application.routes.draw do
  root "pages#home"

  get "services", to: "service_types#index", as: :services
  get "visit", to: "pages#visit", as: :visit
  get "about", to: "pages#about", as: :about

  resources :customers
  resources :bikes
  resources :repairs
  resources :service_types
  resources :staff_members

  get "up" => "rails/health#show", as: :rails_health_check
end