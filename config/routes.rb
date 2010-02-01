ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  map.homepage 'homepage', :controller => 'homepage', :action => 'index'
  map.signup 'signup', :controller => 'users', :action => 'new'
  map.logout 'logout', :controller => 'sessions', :action => 'destroy'
  map.login 'login', :controller => 'sessions', :action => 'new'

  map.test 'test', :controller => 'internal/test', :action => 'index'

  map.resources :sessions

  map.resources :users
  map.my_uploads 'my_uploads', :controller => 'users', :action => 'my_uploads'
  map.my_favorites 'my_favorites', :controller => 'users', :action => 'my_favorites'

  map.resources :games
  map.resources :uploads
  map.upload_search 'upload_search', :controller => 'upload_search', :action => 'index'

  map.resources :uploads
  map.resources :pasties
  map.resources :players, :collection => {:search => :get, :suggest => :get, :suggest2 => :get}
  map.resources :pairs
  map.resources :online_pairs
  map.resources :online_players, :collection => {:search => :get}

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "homepage"

  map.connect 'misc/:action/:id', :controller => 'misc'

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
