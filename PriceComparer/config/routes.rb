Rails.application.routes.draw do
  # Devise routes with OmniAuth callbacks
  devise_for :users, controllers: { sessions: "sessions", omniauth_callbacks: "users/omniauth_callbacks" }

  # Resource routes for products with custom member actions
  resources :products do
    collection do
      get "search", to: "home#search"
    end
    member do
      post "add_to_wishlist", to: "wishlist#add_to_wishlist"
      delete "remove_from_wishlist", to: "wishlist#remove_from_wishlist"
      patch "report", to: "home#report"
    end
  end

  resources :wishlisted_products do
    collection do
      get "search", to: "wishlist#search"
    end
    member do
      delete "remove_from_wishlist", to: "wishlist#remove_from_wishlist"
      patch "report", to: "home#report"
    end
  end

  # Resource routes for users with custom member actions
  resources :users do
    collection do
      get "search_users", to: "administrator#search_users"
    end

    member do
      patch "toggle_analyst", to: "administrator#toggle_analyst"
      patch "toggle_admin", to: "administrator#toggle_admin"
    end
  end

  get "wishlist", to: "wishlist#wishlist"

  resources :wishlists do
    member do
      post "add_label", to: "wishlist#add_label"
      delete "remove_label", to: "wishlist#remove_label"
    end
  end

  # Administrator only
  get "users_list", to: "administrator#users_list"

  # Analyst only
  get "products_dashboard", to: "analyst#products_dashboard"

  # Root path
  root to: "home#index"
end
