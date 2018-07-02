
Rails.application.routes.draw do
  root to: "home#index"
  
  post 'users/signup'
  post 'users/login'

  get 'auth/get_session'
  post 'auth/logout'

  get 'course/all'
  get 'course/search'
  post 'course/new'
  post 'course/update'
  delete 'course/delete'

  match "*path", to: "home#index", format: false, via: :get
end
