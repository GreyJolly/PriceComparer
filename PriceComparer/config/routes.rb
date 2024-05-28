Rails.application.routes.draw do
	# Devise routes with OmniAuth callbacks
	devise_for :users, controllers: { sessions: 'sessions', omniauth_callbacks: 'users/omniauth_callbacks' }
	
	# Resource routes for products with custom member actions
	resources :products do
	  member do
		patch 'wishlist', to: 'home#wishlist'
		patch 'report', to: 'home#report'
	  end
	end
	
	# Resource routes for users with custom member actions
	resources :users do
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
  