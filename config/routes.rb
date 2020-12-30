# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", registrations: "user/registrations" }
  root 'pages#home'
  
   devise_scope :user do
     get 'change_password', to: 'user/registrations#change_password'
   end
   
  resources :shops
  resources :products

  resource :carts, only:[:show, :destroy] do
    post 'add_item/:id', action: 'add_item', as: 'add_item'
    get :checkout
    get :cancel
  end

end
