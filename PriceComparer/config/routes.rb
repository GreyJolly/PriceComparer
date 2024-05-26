Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :products do
    member do
      patch 'wishlist', to: 'home#wishlist'
      patch 'report', to: 'home#report'
    end
  end
  get "home", to: "home#index"
end
