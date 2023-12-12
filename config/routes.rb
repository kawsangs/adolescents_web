Rails.application.routes.draw do
  devise_for :users, path: "/", controllers: { omniauth_callbacks: "users/omniauth_callbacks", sessions: "sessions" }

  devise_scope :user do
    match "/verify_otp" => "sessions#verify_otp", via: :post
    match "/verify_otp" => "sessions#show", via: :get
  end

  # Defines the root path route ("/")
  root "users#index"

  resources :users do
    member do
      post :resend_confirmation
      put :archive
      put :restore
    end
  end

  resource :locale, only: [:update]
end
