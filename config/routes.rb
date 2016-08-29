Rails.application.routes.draw do

  root 'categories#index'

  get '/contact', to: 'static_pages#contact'
  get '/about', to: 'static_pages#about'


  resources :categories do
  	resources :topics do
  	  resources :posts
  	end
  end

  resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
