Rails.application.routes.draw do

  get 'waitdays/chart'

  root 'home_page#index'
  get '/help', to: 'home_page#help'
  get '/signup', to: 'users#new'
  post  '/signup',    to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/welcome/index', to: 'welcome#index'
  delete '/bye', to: 'welcome#destroy'
  get '/practice', to: 'quizcards#practice'
  get '/judge', to: 'quizcards#judge'
  post '/judge', to: 'quizcards#judge'
  get '/list', to: 'quizcards#show'
  get '/register', to: 'quizcards#new'
  post '/register', to: 'quizcards#create'
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :quizcards
end
