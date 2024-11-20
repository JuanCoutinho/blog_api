Rails.application.routes.draw do
  get 'home/index'
  # Rotas para o site (views HTML)
  root 'home#index'
  get 'profile', to: 'users#profile'

  # Rotas para autenticação com Devise
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # Namespace para a API
  namespace :api do
    namespace :v1 do
      resources :posts, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
