Rails.application.routes.draw do
  resources :invitation_codes
  root 'static_pages#index'

  get 'register-choose' => 'users#register_choose'

  get 'register-employee' => 'users#register_employee'

  # post 'register-employee' => 'users#register_employee'

  get 'register-company' => 'users#register_company'

  # post 'register-company' => 'users#register_company'

  get 'login' => 'sessions#login'

  post 'login' => 'sessions#create'

  # 注意resources 后面是有个s的，没有加s生成的url不一样

  resources :scores
  resources :roles
  resources :lessons
  resources :users
  resources :account_activations, only: [:edit]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
