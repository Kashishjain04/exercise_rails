Rails.application.routes.draw do
  root 'doctors#index', as: 'doctors_index'
  resources :doctors
  resources :appointments

  get '/login' => 'users#new', as: 'login'
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
