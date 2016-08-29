Rails.application.routes.draw do

  root 'categories#index'

  get '/contact', to: 'static_pages#contact'
  get '/about', to: 'static_pages#about'

  # To avoid nesting resources too much, instead of following:
  #
  # resources :categories do
  # 	resources :topics do
  # 	  resources :posts
  # 	end
  # end
  #
  # We are using:

  resources :categories do
    resources :topics, name_prefix: 'category_'
  end

  resources :topics do
    resources :posts, name_prefix: 'topic_'
  end

  resources :posts
  resources :users

end
