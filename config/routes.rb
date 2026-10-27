Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resource :registration, only: [:new, :create]
  root "pages#home"

  get "services", to: "service_types#index", as: :services
  get "visit", to: "pages#visit", as: :visit
  get "about", to: "pages#about", as: :about

  resources :customers
  resources :bikes
  resources :repairs do
    resources :intake_photos, only: [:destroy], module: :repairs
  end
  resources :service_types
  resources :staff_members

  namespace :api do
    namespace :v1 do
      resources :services, only: [:index, :show, :create]
      resources :repairs, only: [:index, :show]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
