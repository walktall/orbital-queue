Rails.application.routes.draw do
  get 'config/new'

  get 'config/create'

  get 'config/show'

  get 'home/index'
  root 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
