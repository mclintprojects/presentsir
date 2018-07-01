
Rails.application.routes.draw do
  root to: "home#index"
  
  post 'users/signup'
  post 'users/login'

  get 'auth/get_session'

  match "*path", to: "home#index", format: false, via: :get
end
