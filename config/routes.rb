require "sidekiq/web"

Rails.application.routes.draw do
  use_doorkeeper do
    controllers token_info: "token_info"
  end

  devise_for :users, path: "/", controllers: { omniauth_callbacks: "users/omniauth_callbacks", sessions: "sessions" }

  devise_scope :user do
    match "/verify_otp" => "sessions#verify_otp", via: :post
    match "/verify_otp" => "sessions#show", via: :get
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

  resources :topic_tags, only: [:index]
  resources :faq_forms do
    put :publish, on: :member
  end

  resources :category_importers
  resources :categories
  resources :category_tags, only: [:index]

  resources :facility_importers
  resources :facilities
  resources :facility_tags

  resource :locale, only: [:update]

  resources :visits
  resource :about, only: [:show]
  resources :app_users, only: [:index] do
    resources :surveys, only: [:index, :show]
  end

  resources :tags do
    post :sort, on: :collection
  end

  resources :video_tags, only: [:index]
  resources :video_importers
  resources :videos do
    post :sort, on: :collection
  end
  resources :video_authors do
    post :sort, on: :collection
  end

  resources :contacts
  resources :contact_importers
  resources :contact_directories, only: [:index]

  resources :mobile_notifications
  resources :mobile_notification_importers, except: [:update, :edit], param: :code

  resources :pages
  resource :dashboard_accessibility, only: [:show] do
    put :upsert, on: :collection
  end

  resource :user_delete_information, only: [:show, :destroy]

  # Telegram bot
  get "helps/how-to-connect-telegram-bot", to: "helps#telegram_bot"
  resource :telegram_bot, only: [:show] do
    put :upsert, on: :collection
  end
  resources :chat_groups, only: [:index]

  resources :survey_forms do
    post :make_a_copy, on: :member
    resources :surveys, only: [:index], module: :survey_forms
  end

  resources :reason_importers
  resources :reasons

  resources :themes do
    put :publish, on: :member
    delete :archive, on: :member
  end

  get "/privacy-policy", to: "privacy_policies#show"
  get "/terms-and-conditions", to: "terms_and_conditions#show"

  mount Pumi::Engine => "/pumi"

  # Sidekiq
  if Rails.env.production?
    authenticate :user, ->(user) { user.primary_admin? } do
      mount Sidekiq::Web => "/sidekiq"
    end
  else
    mount Sidekiq::Web => "/sidekiq"
  end
end
