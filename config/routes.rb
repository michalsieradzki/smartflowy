# config/routes.rb
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

  # Dashboard dla zalogowanych użytkowników
  authenticated :user do
    root to: 'dashboard#index', as: :authenticated_root
  end

  # Publiczna strona główna dla niezalogowanych
  root 'pages#dashboard'

  # Dostęp użytkownika do projektów i zadań
  resources :projects, only: [:index, :show, :edit, :update] do
    resources :todo_lists, only: [:show, :new, :create]
  end

  resources :todo_lists, only: [:show] do
    resources :tasks, only: [:new, :create]
  end

  resources :tasks, only: [:index, :show, :update, :edit] do
    member do
      patch :change_status
    end
    resources :comments, only: [:create, :destroy]
  end
  resources :kanban, only: [:index] do
    collection do
      post :update_status
    end
  end

  resources :notifications, only: [:index] do
    member do
      post :mark_as_read
      post :mark_as_unread
    end

    collection do
      post :mark_all_as_read
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
