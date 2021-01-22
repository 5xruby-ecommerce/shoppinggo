# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", registrations: 'users/registrations' }

  root 'pages#home'
  get :search, to: 'products#search'
  get :my_favorite, to: 'products#my_favorite'

  resources :orders do
    collection do
      post :return
    end
  end

  resources :shops do
    resources :products, shallow: true do
      member do
        post :favorite
      end
    end
  end

  resources :order_list, shallow: true

  resources :users do
    collection do
      post :add_coupon
      get :change_coupon_status
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
    get 'get_coupon_info/:id', action: 'get_coupon_info', as: 'get_coupon_info'
    get 'cal_totalprice', action: 'cal_totalprice', as: 'cal_totalprice'
    delete :empty
    delete 'destroy/:id', action: 'destroy', as: 'destroy'
    put 'update_item/:id', action: 'update_item', as: 'update_item'
  end
end
