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
  match "homepage" => "homepage#index", :as => "homepage"

  match "my_uploads" => "users#my_uploads"
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

  mount Perens::InstantUser::Engine => '/'

  root :to => "homepage#index"

  namespace :internal do
    match "test" => "test#index"
  end

  match "misc/:action(/:id.:format)", :controller => "misc"

  namespace :admin do
    resources :games
  end
  match "admin/:controller/:action(/:id.:format)"
end
