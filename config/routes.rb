Gocool::Application.routes.draw do

  authenticated :user do
    # Set root path to a different page if authenticated
    #root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users, :only => [:show, :index]

  mount CoolGames::Engine, :at => '/'

  if Rails.env.development?
    ApiTaster.routes do
      get '/api/games'
    end

    mount ApiTaster::Engine => "/test"
  end
end
