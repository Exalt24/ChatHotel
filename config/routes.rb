Rails.application.routes.draw do
  get "password_resets/new"
  get "password_resets/edit"
  namespace :admin do
      resources :hotels
      resources :day_price_adjustments
      resources :bookings do
        member do
          patch :toggle_status
        end
      end
      resources :users do
        member do
          patch :toggle_admin
        end
      end
  end

  resources :bookings do
    collection do
      post :calculate_price
    end
    member do
      patch :cancel
    end
  end
  resources :hotels do
    member do
      post :room_price
    end
    resources :reviews
  end
  resources :users, only: [ :show, :edit, :update, :create ]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "home#index"

  get "admin", to: "admin#index", as: "admin"

  get "signup" => "users#new"
  get "login" => "sessions#new"
  post "login" => "sessions#create"
  delete "logout" => "sessions#destroy"
  resources :account_activations, only: [ :edit ]
  resources :password_resets, only: [ :new, :create, :edit, :update ]
end
