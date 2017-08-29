ActionController::Routing::Routes.draw do |map|
  map.get_messages  '/get_messages',  :controller => 'sms', :action => 'get_messages'
  map.documentation  '/documentation',  :controller => 'pages', :action => 'documentation'
  map.sign_up  '/sign_up',  :controller => 'pages', :action => 'sign_up'
  map.sample_code  '/sample_code',  :controller => 'pages', :action => 'sample_code'
  map.login  '/login',  :controller => 'pages', :action => 'login'
  map.contact  '/contact',  :controller => 'pages', :action => 'contact'
  map.my_account  '/my_account',  :controller => 'pages', :action => 'my_account'
  map.logout  '/logout',  :controller => 'pages', :action => 'logout'
  map.change_password  '/change_password',  :controller => 'pages', :action => 'change_password'
  map.recover_password  '/recover_password',  :controller => 'pages', :action => 'recover_password'
  map.activate_password  '/activate_password/:api_key',  :controller => 'pages', :action => 'activate_password'
  map.deliver  '/deliver',  :controller => 'sms', :action => 'deliver'
  map.sms_web  '/sms_web',  :controller => 'pages', :action => 'sms_web'
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
  map.root :controller => "pages", :action => "home"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
