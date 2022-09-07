Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :visits, only: [:create]
      resources :app_users, only: [:create, :update ]
      resources :facilities, only: [:index]

      get "*path" => "api#routing_error"
    end
  end
end
