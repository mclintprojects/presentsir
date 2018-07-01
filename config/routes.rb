
Rails.application.routes.draw do
  root to: "home#index"
  
  post 'users/signup'
  post 'users/login'

  get 'auth/get_session'
  post 'auth/logout'

  get 'course/all'
  post 'course/new'
  post 'course/update'
  post 'course/delete'

  match "*path", to: "home#index", format: false, via: :get
end
