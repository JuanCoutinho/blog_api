Rails.application.routes.draw do
  resources :posts

  namespace :api do
    namespace :v1 do
      resources :posts
    end
  end

  root "posts#index"
end
