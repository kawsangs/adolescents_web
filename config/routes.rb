require "sidekiq/web"

Rails.application.routes.draw do
  use_doorkeeper do
    controllers token_info: "token_info"
  end

  devise_for :users, path: "/", controllers: { confirmations: "confirmations", omniauth_callbacks: "users/omniauth_callbacks", sessions: "sessions" }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "app_users#index"

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

  resources :api_keys do
    member do
      put :archive
      put :restore
    end
  end

  resources :topics do
    put :publish, on: :member
  end

  resources :category_importers
  resources :categories

  resources :facility_importers
  resources :facilities

  resource :locale, only: [:update]
  resources :visits
  resource :about, only: [:show]
  resources :app_users, only: [:index] do
    resources :quizzes, only: [:index, :show]
  end

  resources :tags do
    post :sort, on: :collection
  end

  resources :videos do
    post :sort, on: :collection
  end
  resources :video_batches, except: [:update, :edit], param: :code

  resources :video_authors do
    post :sort, on: :collection
  end

  resources :mobile_notifications
  resources :mobile_notification_importers, except: [:update, :edit], param: :code

  resources :pages
  resource :dashboard_accessibility, only: [:show] do
    put :upsert, on: :collection
  end

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
