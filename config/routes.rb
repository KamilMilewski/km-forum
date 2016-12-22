Rails.application.routes.draw do
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/delete'

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
    resources :topics, name_prefix: 'category_',
                       except: [:index, :show, :edit, :update, :destroy]
  end

  resources :topics, only: [:show, :edit, :update, :destroy] do
    resources :posts, name_prefix: 'topic_',
                      except: [:index, :show, :edit, :update, :destroy]
  end

  resources :posts, only: [:edit, :update, :destroy]
  resources :post_votes, only: [:create, :update, :destroy]

  resources :users
  # Custom user resources.
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  # Sessions resources.
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # Account activation path - it is used in activation links in emails sent to
  # new users.
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]

  # SANDBOX only. For database reset and seed with fake data.
  delete '/reset_kmf', to: 'sandbox_db_resets#reset'
  post '/seed_kmf', to: 'sandbox_db_resets#seed'
end
