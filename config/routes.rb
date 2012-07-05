Gocool::Application.routes.draw do

  authenticated :user do
    # Set root path to a different page if authenticated
    #root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users, :only => %w[show index]

  namespace :api do
    resources :sessions, :only => %w[index create destroy]
  end

  mount CoolGames::Engine, :at => '/'
end
