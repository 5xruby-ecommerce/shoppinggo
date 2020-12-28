# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  root 'pages#home'

  resources :users do
    collection do 
      post :add_coupon
    end
  end

  resources :shops
  resources :products
  resources :coupons do
    collection do
      get :list
    end
  end

  # resource :carts, only:[:show, :destroy] do
  #   post 'add_item/:id', action: 'add_item', as: 'add_item'
  #   get :checkout
  #   get :cancel
  # end
  resource :carts, only:[:show] do
    post 'add_item/:id', action: 'add_item', as: 'add_item'
    get :checkout
    get :cancel
    delete 'destroy/:id', action: 'destroy', as: 'destroy'
    post 'update_item/:id', action: 'update_item', as: 'update_item'
  end

end
