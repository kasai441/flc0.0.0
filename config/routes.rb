Rails.application.routes.draw do
  root 'home_page#show'
  get '/signup', to: 'users#new'
end
