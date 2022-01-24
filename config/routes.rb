Rails.application.routes.draw do
  namespace :cms do
    resources :posts do
      resources :documents, only: %i[index create destroy], controller: 'post_documents'
    end
  end
end
