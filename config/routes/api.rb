Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :visits, only: [:create]
      resources :app_users, only: [:create, :update]
      resources :facilities, only: [:index]
      resource  :mobile_tokens, only: [:create]
      resources :topics, only: [:index]
      resources :tags, only: [:index]
      resources :quizzes, only: [:create]

      get "*path" => "api#routing_error"
    end
  end
end
