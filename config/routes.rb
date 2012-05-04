Gocool::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
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
