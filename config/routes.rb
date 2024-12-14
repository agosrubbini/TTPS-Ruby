Rails.application.routes.draw do
  root 'home#index'
  devise_for :users
  
  namespace :admin do
    resources :categories
  end
  namespace :admin do
    resources :users do
      member do
        patch :activate
        patch :deactivate
      end
    end
  end

  namespace :admin do
    resources :products do
      member do
        patch :activate
      end
    end
  end
  
  namespace :admin do
    resources :sails do
      post 'add_product', on: :collection
    end
  end

  get 'home/show/:id', to: 'home#show', as: 'home_show'
  get 'admin/products/new/', to: 'products#new', as: 'new_products'
  get 'admin/product/edit/:id', to: 'products#edit', as: 'edit_products'
  get 'admin/sails/new/', to: 'sails#new', as: 'new_sails'
  get 'admin/user/new/', to: 'users#new', as: 'new_users'
  get 'admin/user/edit/:id', to: 'users#edit', as: 'edit_users'


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
