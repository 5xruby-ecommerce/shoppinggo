# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", registrations: 'users/registrations' }

  root 'pages#home'
  get :search, to: 'products#search'

  resources :orders

  resources :shops do
    resources :products, shallow: true do 
      member do
        post :favorite
      end
    end
  end

  resources :coupons do
    collection do
      get :list
    end
  end

  resources :rooms do
    resources :messages , shallow: true
  end

  resource :carts, only:[:show, :destroy] do
    post 'add_item/:id', action: 'add_item', as: 'add_item'
    get :checkout
    post :return
    delete :empty
    delete 'destroy/:id', action: 'destroy', as: 'destroy'
    post 'update_item/:id', action: 'update_item', as: 'update_item'
  end
end
