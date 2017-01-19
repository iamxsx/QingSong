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
  get 'register-choose' => 'users#register_choose'
  get 'register-employee' => 'users#register_employee'
  get 'register-company' => 'users#register_company'
  get 'login' => 'sessions#login'
  post 'login' => 'sessions#create'
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
