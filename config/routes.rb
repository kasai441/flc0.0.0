Rails.application.routes.draw do
  
  root 'home_page#index'
  get '/signup', to: 'users#new'
  post  '/signup',    to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/welcome/index', to: 'welcome#index'
  delete '/bye', to: 'welcome#destroy'
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :quizcards
end
