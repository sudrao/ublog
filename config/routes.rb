ActionController::Routing::Routes.draw do |map|
  map.resources :uploads

  map.resource :all
  
  map.resource :yammer

  map.resource :twitter
    
# Thumbs is a fake resource, used only to create a separate URL
# for thumbs of photos (assets)
  map.resources :thumbs, :has_many => :assets
  
# Assets are also available non-nested
  map.resources :assets

  map.resources :followers

  map.resources :friends

  map.resources :tagsubs
  
  map.resources :responses

  map.resources :blogs, :has_many => :uploads

  map.resources :tags
  
  map.resources :groups
  
  map.resources :homes do |home|
    home.resource :display
    home.resource :follow
    home.resources :assets
    home.resource :toggle_mobile
    home.resources :threads
  end

  map.resource :session

  map.resource :search

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

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"
  map.connect 'log', :controller => 'log', :action => 'show'
  
  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':vanity', :controller => 'vanity', :action => 'show'
  map.connect '', :controller => 'homes', :action => 'index'
end
