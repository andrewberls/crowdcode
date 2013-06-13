Crowdcode::Application.routes.draw do

  resources :reviews do
    member do
      post 'votes'
      post 'comments'
    end

    collection do
      match 'search'
      get 'tags'
    end
  end
  resources :r, controller: "reviews" # Alias review paths as 'r'

  resources :comments

  resources :users

  resources :sessions, only: [:new, :create, :destroy]
  match 'login'  => 'sessions#new',     as: 'login'
  match 'logout' => 'sessions#destroy', as: 'logout'
  match 'auth/:provider/callback' => 'sessions#create_from_github'
  match 'auth/failure'            => 'sessions#failure_from_github'

  root to: 'static#start'

  match '*a' => 'static#not_found'

end
