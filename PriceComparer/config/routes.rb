Rails.application.routes.draw do
<<<<<<< HEAD
	# Devise routes with OmniAuth callbacks
	devise_for :users, controllers: { sessions: 'sessions', omniauth_callbacks: 'users/omniauth_callbacks' }
	
	# Resource routes for products with custom member actions
	resources :products do
		collection do
			get 'search', to: 'home#search'
		end
	  member do
		patch 'wishlist', to: 'home#wishlist'
		patch 'report', to: 'home#report'
	  end
	end

	
	# Resource routes for users with custom member actions
	resources :users do

		collection do
			get 'search_users', to: 'administrator#search_users'
		end

		member do
		  patch 'toggle_analyst', to: 'administrator#toggle_analyst'
		  patch 'toggle_admin', to: 'administrator#toggle_admin'
		end
	end


	
  
	# Custom route for the administrator user list
	get 'users_list', to: 'administrator#users_list'
  
	# Root path
	root to: 'home#index'
  end
  
=======
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

  # Administrator only users list
  get "users_list", to: "administrator#users_list"

  # Root path
  root to: "home#index"
end
>>>>>>> 0ec63ad6fdf6d1bdd187b16eef7ca984a0512c73
