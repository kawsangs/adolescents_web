Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :visits, only: [:create]

      get "*path" => "api#routing_error"
    end
  end
end
