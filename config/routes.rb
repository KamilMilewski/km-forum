Rails.application.routes.draw do

  get 'static_pages/contact'

  get 'static_pages/about'

  root 'categories#index'
  resources :categories do
  	resources :topics do
  	  resources :posts
  	end
  end

  resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
