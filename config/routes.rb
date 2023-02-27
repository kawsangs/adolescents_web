require "sidekiq/web"

Rails.application.routes.draw do
  devise_for :users, path: "/", controllers: { omniauth_callbacks: "users/omniauth_callbacks", sessions: "sessions" }

  devise_scope :user do
    match "/verify_otp" => "sessions#verify_otp", via: :post
    match "/verify_otp" => "sessions#show", via: :get
  end

  use_doorkeeper do
    controllers token_info: "token_info"
  end

  # Defines the root path route ("/")
  root "app_users#index"

  resources :users do
    member do
      post :resend_confirmation
      put :archive
      put :restore
    end
  end

  resources :api_keys do
    member do
      put :archive
      put :restore
    end
  end

  resources :topics do
    put :publish, on: :member
  end

  resource :locale, only: [:update]
  resources :visits
  resource :about, only: [:show]
  resources :app_users, only: [:index] do
    resources :quizzes, only: [:index, :show]
  end

  resources :facilities
  resources :tags do
    post :sort, on: :collection
  end

  resources :facility_batches, except: [:update, :edit], param: :code
  resources :videos
  resources :video_batches, except: [:update, :edit], param: :code
  resources :mobile_notifications
  resources :mobile_notification_importers, except: [:update, :edit], param: :code

  resources :pages

  get "/privacy-policy", to: "privacy_policies#show"
  get "/terms-and-conditions", to: "terms_and_conditions#show"

  mount Pumi::Engine => "/pumi"

  if Rails.env.production?
    # Sidekiq
    authenticate :user, lambda { |u| u.primary_admin? } do
      mount Sidekiq::Web => "/sidekiq"
    end
  else
    mount Sidekiq::Web => "/sidekiq"
  end
end
