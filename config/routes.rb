Crowdcode::Application.routes.draw do

  resources :reviews do
    post 'votes', on: :member
    post 'comments', on: :member
  end
  match 'r/:id' => "reviews#show", as: 'r' # Shorthand path

  resources :comments

  resources :users

  resources :sessions, only: [:new, :create, :destroy]
  match 'login'  => 'sessions#new',     as: 'login'
  match 'logout' => 'sessions#destroy', as: 'logout'
  match "auth/:provider/callback" => "sessions#create_from_github"
  match "auth/failure"            => "sessions#failure_from_github"
  # match 'forgot_password'       => 'sessions#forgot_password', as: 'forgot_password'
  # match 'reset_password/:token' => 'sessions#reset_password',  as: 'reset_password'

  root to: 'static#start'

  match '*a' => 'static#not_found'

end
