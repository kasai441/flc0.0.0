Rails.application.routes.draw do
  get 'home_page/show'
  root 'home_page#show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
