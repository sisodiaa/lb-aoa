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
    get "posts", to: "dashboard#posts", as: "posts"
    get "drafts", to: "dashboard#drafts", as: "drafts"
    get "published_posts", to: "dashboard#published_posts", as: "published_posts"
    get "tenders", to: "dashboard#tenders", as: "tenders"
  end

  namespace :cms do
    resources :posts do
      resources :documents, only: %i[index create destroy], controller: "post_documents"
    end
  end

  patch "cms/posts/:id/publish", to: "cms/publications#update", as: "publish_cms_post"

  namespace :tms do
    resources :tenders do
      resources :documents, only: %i[index create destroy], controller: "tender_documents"
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

    get "tenders", to: "tenders#tenders", as: :tenders
    resources :tenders, only: :show, path: "/tenders/notice" do
      resources :documents, only: :index, controller: "tender_documents"
      resources :bids, only: %i[index show]
    end

    resources :tenders, only: %i[] do
      get "upcoming", to: "tenders#index", status: "upcoming", on: :collection
      get "current", to: "tenders#index", status: "current", on: :collection
      get "under_review", to: "tenders#index", status: "under_review", on: :collection
      get "reviewed", to: "tenders#index", status: "reviewed", on: :collection
    end
  end

  get "/pages/*page", to: "cms/pages#show", as: "page"
  root to: "cms/pages#show", page: "home"
end
