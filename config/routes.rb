Rails.application.routes.draw do
  root 'home_page#index'
  get '/help', to: 'home_page#help'
  get '/signup', to: 'users#new'
  post  '/signup',    to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/practice', to: 'quizcards#practice'
  get '/judge', to: 'quizcards#judge'
  post '/judge', to: 'quizcards#judge'
  get '/todaycard', to: 'quizcards#show'
  get '/allcard', to: 'quizcards#all'
  get '/register', to: 'quizcards#new'
  post '/register', to: 'quizcards#create'
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :quizcards
  get 'waitdays/chart'
end
