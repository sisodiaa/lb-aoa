Rails.application.routes.draw do
  namespace :cms do
    resources :posts
  end
end
