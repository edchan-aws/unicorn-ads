Rails.application.routes.draw do
  namespace :admin do
    resources :db_configurations
  end
  resources :ads
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'home#index'
end
