Rails.application.routes.draw do
  resources :appointments
  resources :users
  root 'doctors#index', as: 'doctors_index'
  resources :doctors
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
