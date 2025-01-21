Rails.application.routes.draw do
  # Página principal
  root "home#index"

  # Autenticación con Devise
  devise_for :users

  # Namespace para administración
  namespace :admin do
    # CRUD para categorías
    resources :categories

    # CRUD para usuarios, con rutas personalizadas
    resources :users do
      member do
        patch :activate
        patch :deactivate
      end
      collection do
        get :profile
        get :profile_edit
        patch :update_profile
      end
    end

    # CRUD para productos, con rutas personalizadas
    resources :products do
      member do
        patch :activate
        delete "delete_image/:image_id", to: "products#delete_image", as: "delete_image"
      end
    end

    # CRUD para ventas, con rutas personalizadas
    resources :sales do
      post "add_product", on: :collection
    end
  end

  # Detalle del home
  get "home/show/:id", to: "home#show", as: "home_show"

  get "admin/sales/new", to: "sales#new", as: "new_sales"

  # Creacionde un producto
  get "admin/products/new/", to: "products#new", as: "new_products"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
end
