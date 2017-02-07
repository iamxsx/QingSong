Rails.application.routes.draw do


  # 后台管理系统的控制器
  namespace :admin do
    root 'static_pages#index'
    get 'sessions/create'
    get 'login' => 'login_and_register#login' #登录页
    post 'login' => 'sessions#create' #登录操作
    get 'logout' => 'sessions#destroy'  #注销
    get 'register' => 'login_and_register#register' #注册页
    post 'register' => 'admin_users#create'
    resources :users
    resources :lessons
    resources :companies
    resources :admin_users
  end


  root 'static_pages#index'
  get 'login' => 'sessions#login'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy'
  get 'register-choose' => 'users#register_choose'
  get 'register-success' => 'users#register_success'
  get 'register-suspend' => 'users#register_suspend'
  get 'register-employee' => 'users#register_employee'
  post 'register-employee' => 'users#create_employee'
  get 'register-company' => 'users#register_company'
  post 'register-company' => 'companies#create_company'
  get '/company/send-verify-code' => 'companies#send_verify_code'

  #后台页面
  get '/users/user-center' => 'users#user_center'
  get '/users/com-profile' => 'users#com_profile'
  get '/users/com-employee' => 'users#com_employee'
  get '/users/com-course' => 'users#com_course'
  get '/users/emp-profile' => 'users#emp_profile'
  get '/users/emp-course' => 'users#emp_course'
  get '/users/emp-exam' => 'users#emp_exam'


  # 注意resources 后面是有个s的，没有加s生成的url不一样
  resources :scores
  resources :roles
  resources :lessons
  resources :users
  resources :account_activations, only: [:edit]
  resources :invitation_codes
  resources :companies

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
