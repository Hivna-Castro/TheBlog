Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "posts#index"
  
  get 'signup', to: 'users#new', as: 'signup'     # form de cadastro
  post 'signup', to: 'users#create'                # criar usuário
  get 'login', to: 'sessions#new', as: 'login'    # form p/ logar
  post 'login', to: 'sessions#create'             # autenticar 
  get 'logout', to: 'sessions#destroy', as: :logout

  resources :posts, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
    resources :comments, only: [:create, :destroy]
    
    collection do  
      get :my_posts
    end
  end

  resources :tags, only: [:index, :create, :destroy] do
    member do
      delete 'destroy_from_post/:post_id', to: 'tags#destroy_from_post', as: 'destroy_from_post'
    end
  end

  resources :users, only: [:edit, :update] do
    collection do
      get :forgot_password_form
      post :forgot_password
      get :reset_password_form
      patch :reset_password
    end
  end

end
