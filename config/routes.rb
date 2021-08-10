# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  get '/activate', to: 'activations#show'
  post '/verify', to: 'activations#verify'
  resources :activations
  resources :names
  root 'dashboard#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
