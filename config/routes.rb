Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  get "up" => "rails/health#show", as: :rails_health_check
  resources :chats, only: [:index, :show, :new, :create, :destroy] do
    resources :messages, only: [:create]
  end


  # Defines the root path route ("/")
  # root "posts#index"
end
