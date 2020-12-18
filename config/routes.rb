Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'


  resources :shops
  resources :products
 
end
