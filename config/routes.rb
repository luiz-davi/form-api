Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :create, :update, :destroy]
      resources :formularies, only: [:index, :create, :update, :destroy]
      resources :questions, only: [:index, :create, :update, :destroy]
      resources :visits, only: [:create, :update, :index, :destroy]
      resources :answers, only: [:create, :index, :update, :destroy]

      post 'authenticate', to: "authentication#create"
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
