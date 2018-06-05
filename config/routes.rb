Rails.application.routes.draw do
  get 'home/index'
  root 'home#index'


  get '/config/new', to: 'config#new', as: 'new_config'
  get '/config/restore', to: 'config#restore', as: 'restore_config'
  get '/config/:uid/:version/edit', to: 'config#edit', as: 'edit_config_version'
  get '/config/:uid/edit', to: 'config#edit', as: 'edit_config'

  get '/config/:uid/:version', to: 'config#show', as: 'config_version'
  get '/config/:uid', to: 'config#show', as: 'config'

  resources :config, only: [:create]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
