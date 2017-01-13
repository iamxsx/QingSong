Rails.application.routes.draw do
  root 'static_pages#index'

  get 'register-choose' => 'users#register_choose'

  get 'register-employee' => 'users#register_employee'

  # post 'register-employee' => 'users#register_employee'

  get 'register-company' => 'users#register_company'

  # post 'register-company' => 'users#register_company'

  get 'login' => 'sessions#login'

  post 'login' => 'sessions#create'

  resources :scores
  resources :roles
  resources :lessons
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
