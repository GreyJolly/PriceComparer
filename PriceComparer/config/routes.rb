Rails.application.routes.draw do
    devise_for :users, controllers: { sessions: "sessions", omniauth_callbacks: "users/omniauth_callbacks" }
  
    resources :reports
  
    resources :products do
      collection do
        post "add_to_wishlist", to: "wishlist#add_to_wishlist"
        get "search", to: "home#search"
      end
      member do
        delete "remove_from_wishlist", to: "wishlist#remove_from_wishlist"
        patch "report_product"
      end
    end
  
    resources :users do
      collection do
        get "search_users", to: "administrator#search_users"
      end
  
      member do
        patch "toggle_analyst", to: "administrator#toggle_analyst"
        patch "toggle_admin", to: "administrator#toggle_admin"
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
  
    get "wishlist", to: "wishlist#wishlist"
  
    resources :wishlists do
      member do
        post "add_label", to: "wishlist#add_label"
        delete "remove_label", to: "wishlist#remove_label"
      end
    end
  
    get "users_list", to: "administrator#users_list"
    get "products_dashboard", to: "analyst#products_dashboard"
  
    root to: "home#index"
  end
  