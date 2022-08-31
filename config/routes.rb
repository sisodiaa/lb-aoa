Rails.application.routes.draw do
  if Rails.env.production? || Rails.env.staging?
    require "sidekiq/web"
    authenticate :admin do
      mount Sidekiq::Web => "/sidekiq"
    end
  end

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
          # Navigate to this root after logging out from admin's dashboard
          root to: "admins/sessions#new", as: :management_root
        end
      end
    end
  end

  namespace :management do
    get "dashboard", to: "dashboard#index", as: "dashboard"
  end

  devise_for :admins, skip: %i[registrations], controllers: {
    sessions: "accounts/admins/sessions",
    passwords: "accounts/admins/passwords",
    confirmations: "accounts/admins/confirmations",
    unlocks: "accounts/admins/unlocks"
  }

  devise_scope :admin do
    authenticated :admin do
      root to: "management/dashboard#index", as: :admin_root
    end
  end

  devise_for :owners, skip: :registrations, controllers: {
    sessions: "accounts/owners/sessions",
    passwords: "accounts/owners/passwords",
    confirmations: "accounts/owners/confirmations",
    unlocks: "accounts/owners/unlocks"
  }

  devise_scope :owner do
    resource :registration, only: [:new, :create, :edit, :update],
      path: "owners", path_names: {new: "sign_up"},
      controller: "accounts/owners/registrations",
      as: :owner_registration

    authenticated :owner do
      root to: "accounts/owners/dashboards#show", as: :owner_root
    end
  end

  scope module: "accounts" do
    namespace :owners do
      resource :profile, only: [:edit, :update]
      resource :dashboard, only: :show do
        member do
          get "account"
          get "profile"
          get "properties"
        end
      end
    end
  end

  namespace :cms do
    resources :categories, except: :destroy
    resources :tags, only: :index

    resources :posts do
      resources :documents, only: %i[index new create destroy], controller: "post_documents"
    end
  end

  patch "cms/posts/:id/publish", to: "cms/publications#update", as: "publish_cms_post"

  namespace :tms do
    resources :tenders do
      resources :documents, only: %i[index new create destroy], controller: "tender_documents"
      resources :bids, only: %i[index show] do
        resource :selection, only: %i[new create]
      end
    end
  end

  patch "tms/tenders/:id/publish", to: "tms/publications#update", as: "publish_tms_tender"

  scope module: :tms do
    resources :tenders, only: [], path: "/tenders/notice" do
      resources :bids, only: %i[new create]
    end
  end

  scope module: "front" do
    resources :posts, only: %i[index show] do
      get "published", on: :collection
      resources :documents, only: :index, controller: "post_documents"
    end

    get "tenders", to: "tenders#index", as: :tenders
    resources :tenders, only: :show, path: "/tenders/notice" do
      get "published", on: :collection
      resources :documents, only: :index, controller: "tender_documents"
      resources :bids, only: %i[index show]
    end

    resources :tenders, only: %i[] do
      get "upcoming", to: "tenders#index", status: "upcoming", on: :collection
      get "current", to: "tenders#index", status: "current", on: :collection
      get "under_review", to: "tenders#index", status: "under_review", on: :collection
      get "reviewed", to: "tenders#index", status: "reviewed", on: :collection
    end

    namespace :search do
      resources :posts, only: %i[index new] do
        get "results", on: :collection
      end
    end
  end

  get "/pages/*page", to: "cms/pages#show", as: "page"
  # An owner after logging out is redirected to this root
  root to: "cms/pages#show", page: "home"
end
