Rails.application.routes.draw do
  namespace :admin do
    root to: 'dashboard#index'
    resources :users do
      member do
        patch :disable
      end
    end
    resources :versions, only: [:index, :show]
    resources :companies, only: [:index, :new, :create, :edit, :update]
    resources :projects do
      delete 'attachments/:attachment_id', to: 'projects#delete_attachment', as: :attachment
    end
    resources :todo_lists
    resources :tasks
    resources :comments, only: [:index, :destroy]
  end
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  root 'pages#dashboard'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
