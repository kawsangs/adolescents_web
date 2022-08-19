require "sidekiq/web"

Rails.application.routes.draw do
  use_doorkeeper do
    controllers token_info: "token_info"
  end

  devise_for :users, path: "/", controllers: { confirmations: "confirmations", omniauth_callbacks: "users/omniauth_callbacks", sessions: "sessions" }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "users#index"

  # https://github.com/plataformatec/devise/wiki/How-To:-Override-confirmations-so-users-can-pick-their-own-passwords-as-part-of-confirmation-activation
  as :user do
    match "/confirmation" => "confirmations#update", via: :put, as: :update_user_confirmation
  end

  resources :users do
    member do
      post :resend_confirmation
      put :archive
      put :restore
    end
  end

  resource :locale, only: [:update]

  resources :api_keys do
    member do
      put :archive
      put :restore
    end
  end

  resources :visits

  resource :about, only: [:show]

  resource :about, only: [:show]

  get "/privacy-policy", to: "privacy_policies#show"

  if Rails.env.production?
    # Sidekiq
    authenticate :user, lambda { |u| u.primary_admin? } do
      mount Sidekiq::Web => "/sidekiq"
    end
  else
    mount Sidekiq::Web => "/sidekiq"
  end
end
