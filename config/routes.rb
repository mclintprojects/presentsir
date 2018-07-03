
Rails.application.routes.draw do
  root to: "home#index"
  
  post 'users/signup'
  post 'users/login'

  get 'auth/get_session'
  post 'auth/logout'

  get 'course/all'
  get 'course/search'
  post 'course', to: 'course#new'
  post 'course/mark_attendance'
  put 'course', to: 'course#update'
  delete 'course', to: 'course#delete'

  get 'enrollment/student/all', to: 'enrollment#all_student'
  get 'enrollment/course/all', to: 'enrollment#all_course'
  get 'enrollment/is_logging_attendance'
  post 'enrollment', to: 'enrollment#new'
  delete 'enrollment', to: 'enrollment#delete'

  post 'attendance/new'
  get 'attendance', to: 'attendance#search'

  post 'course_rep', to: 'course_rep#new'
  delete 'course_rep', to: 'course_rep#delete'

  match "*path", to: "home#index", format: false, via: :get
end
