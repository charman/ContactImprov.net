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

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # [CTH]
  map.resource :session, :collection => { :no_cookies_for_you => :get }

  map.activate '/activate/:activation_code', :controller => 'user', :action => 'activate'
  #  TODO: Should this be 'map.reset_password'?
  map.activate '/reset_password/:password_reset_code', :controller => 'user', :action => 'reset_password'

  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  
  map.index               '/',              :controller => 'home',          :action => 'index'
  map.admin_index         '/admin',         :controller => 'admin/home',    :action => 'index'
  map.events_index        '/events',        :controller => 'events',        :action => 'index'
  map.jams_index          '/jams',          :controller => 'jams',          :action => 'index'
  map.people_index        '/people',        :controller => 'people',        :action => 'index'
  map.organizations_index '/organizations', :controller => 'organizations', :action => 'index'

  map.connect '/events/list/:year/:month',                   :controller => 'events',        :action => 'list'
  map.connect '/events/list/:year',                          :controller => 'events',        :action => 'list'
  map.connect '/jams/list/:country_name/:us_state',          :controller => 'jams',          :action => 'list'
  map.connect '/jams/list/:country_name',                    :controller => 'jams',          :action => 'list'
  map.connect '/organizations/list/:country_name/:us_state', :controller => 'organizations', :action => 'list'
  map.connect '/organizations/list/:country_name',           :controller => 'organizations', :action => 'list'
  map.connect '/people/list/:country_name/:us_state',        :controller => 'people',        :action => 'list'
  map.connect '/people/list/:country_name',                  :controller => 'people',        :action => 'list'

  #  TODO: Is this first connection needed?
  map.connect '/events/calendar.ics',                         :controller => 'events', :action => 'calendar'
  map.connect '/events/:country_name/calendar.ics',           :controller => 'events', :action => 'calendar'
  map.connect '/events/:country_name/:us_state/calendar.ics', :controller => 'events', :action => 'calendar'
  # [/CTH]

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
