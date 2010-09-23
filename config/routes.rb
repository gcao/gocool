Gocool::Application.routes.draw do
  # map.homepage 'homepage', :controller => 'homepage', :action => 'index'
  match "homepage" => "homepage#index", :as => "homepage"
  
  # map.signup 'signup', :controller => 'users', :action => 'new'
  match "signup" => "users#new", :as => "signup"
  # map.logout 'logout', :controller => 'sessions', :action => 'destroy'
  match "logout" => "sessions#destroy", :as => "logout"
  # map.login 'login', :controller => 'sessions', :action => 'new'
  match "login" => "sessions#new", :as => "login"

  resources :sessions
  resources :users
  
  # map.my_uploads 'my_uploads', :controller => 'users', :action => 'my_uploads'
  match "my_uploads" => "users#my_uploads"
  # map.my_favorites 'my_favorites', :controller => 'users', :action => 'my_favorites'
  match "my_favorites" => "users#my_favorites"

  match "games/my_turn" => "my_turn#my_turn"

  resources :games do
    member do
      get *%w(play resign undo_guess_moves next do_this mark_dead messages)
      post *%w(send_message)
    end
    collection do
      get *%w(waiting)
    end
  end
  
  resources :uploads
  # map.upload_search 'upload_search', :controller => 'upload_search', :action => 'index'
  match "upload_search" => "upload_search#index"

  resources :players do
    collection do
      get *%w(search suggest suggest_opponents)
    end
  end

  resources :pairs

  resources :invitations do
    member do 
      get *%w(accept reject cancel)
    end
  end

  root :to => "homepage#index"

  # map.test 'test', :controller => 'internal/test', :action => 'index'
  namespace :internal do
    match "test" => "test#index"
  end

  # map.connect 'misc/:action/:id', :controller => 'misc'
  match "misc/:action(/:id.:format)", :controller => "misc"

  # map.connect '/admin/misc/:action/:id.:format', :controller => 'admin/misc'
  namespace :admin do
    resources :games
  end
  match "admin/:controller/:action(/:id.:format)"
end
