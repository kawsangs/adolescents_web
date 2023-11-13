Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :visits, only: [:create]
      resources :app_users, only: [:create, :update]
      resources :facilities, only: [:index]
      resources :videos, only: [:index]
      resource  :mobile_tokens, only: [:create]
      resources :topics, only: [:index]
      resources :tags, only: [:index]
      resources :video_tags, only: [:index]
      resources :quizzes, only: [:create]
      resources :video_authors, only: [:index]
      resources :categories, only: [:index]
      resources :contacts, only: [:index]
      resources :contact_directories, only: [:index]
      resources :survey_forms, only: [:show]
      resources :surveys, only: [:create]

      get "*path" => "api#routing_error"
    end

    namespace :integration do
      # Telegram
      constraints Whitelist do
        telegram_webhook Api::Integration::TelegramWebhooksController
      end
    end
  end
end
