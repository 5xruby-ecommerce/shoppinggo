# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'

  resources :shops
  resources :products


  resource :carts, only:[:show, :destroy] do
    post 'add_item/:id', action: 'add_item', as: 'add_item'
  end


end
