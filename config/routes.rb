Rails.application.routes.draw do
  devise_for :admins, skip: %i[registrations], controllers: {
    sessions: "accounts/admins/sessions",
    passwords: "accounts/admins/passwords",
    confirmations: "accounts/admins/confirmations",
    unlocks: "accounts/admins/unlocks"
  }

  scope module: "accounts" do
    devise_scope :admin do
      get "/admins/edit",
        to: "admins/registrations#edit",
        as: "edit_admin_registration"

      match "/admins",
        to: "admins/registrations#update",
        as: "admin_registration",
        via: %i[put patch]

      scope "/management" do
        unauthenticated do
          root to: "admins/sessions#new", as: :management_root
        end
      end
    end
  end

  devise_scope :admin do
    authenticated :admin do
      root to: "management/dashboard#index", as: :admin_root
    end
  end

  namespace :management do
    get "dashboard", to: "dashboard#index", as: "dashboard"
  end

  namespace :cms do
    resources :posts do
      resources :documents, only: %i[index create destroy], controller: "post_documents"
    end
  end

  patch "cms/posts/:id/publish", to: "cms/publications#update", as: "publish_cms_post"

  scope module: "front" do
    resources :posts, only: %i[index show] do
      get "published", on: :collection
      resources :documents, only: :index, controller: "post_documents"
    end
  end

  root to: "front/posts#index"
end
