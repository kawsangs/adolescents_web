Rails.application.routes.draw do
  devise_for :users, path: "/", controllers: { confirmations: "confirmations" }
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
end
