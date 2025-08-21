# config/routes.rb
Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root to: "chats#index", as: :authenticated_root
  end

  unauthenticated do
    devise_scope :user do
      root to: "devise/sessions#new", as: :unauthenticated_root
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  resources :chats, only: [:index, :show, :create, :destroy] do
    member do
      post :sendmail   # <- this creates sendmail_chat_path(@chat)
    end
    resources :messages, only: [:create]
  end
end
