Rails.application.routes.draw do
  get 'welcome/index'
  
  resources :articles do
    resources :comments
  end
  # creates comments as a nested resource within articles
  
  root 'articles#index'
  
  resources :cards
  resources :lists
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
