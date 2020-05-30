Rails.application.routes.draw do
  resources :investmentassets
  resources :portfolios
  resources :aqueries

  resources :assets
  #get 'home/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #get '/assets', :to=> 'portfolios#new'


  root :to=> 'aqueries#index'
end
