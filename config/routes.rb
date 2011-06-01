ContactImprovNet::Application.routes.draw do
  resource :session do
    collection do
  get :no_cookies_for_you
  end
  
  
  end

  match '/activate/:activation_code' => 'user#activate', :as => :activate
  match '/denied' => 'home#denied', :as => :denied
  match '/login' => 'sessions#new', :as => :login
  match '/logout' => 'sessions#destroy', :as => :logout
  match '/reset_password/:password_reset_code' => 'user#reset_password', :as => :activate

  match '/' => 'home#index', :as => :index

  namespace 'admin' do
    match '/' => 'home#index'
    match '/account_requests' => 'account_requests#index'
    match '/events' => 'events#index'
    match '/geocoding' => 'geocoding#index'
    match '/jams' => 'jams#index'
    match '/motivation' => 'motivation#index'
    match '/organizations' => 'organizations#index'
    match '/people' => 'people#index'
    match '/users' => 'users#index'
  end

  match '/events' => 'events#index', :as => :events_index
  match '/jams' => 'jams#index', :as => :jams_index
  match '/people' => 'people#index', :as => :people_index
  match '/organizations' => 'organizations#index', :as => :organizations_index

  match '/events/list/:year/:month' => 'events#list'
  match '/events/list/:year' => 'events#list'
  match '/jams/list/:country_name/:us_state' => 'jams#list'
  match '/jams/list/:country_name' => 'jams#list'
  match '/organizations/list/:country_name/:us_state' => 'organizations#list'
  match '/organizations/list/:country_name' => 'organizations#list'
  match '/people/list/:country_name/:us_state' => 'people#list'
  match '/people/list/:country_name' => 'people#list'

  match '/events/calendar.ics' => 'events#calendar'
  match '/events/:country_name/calendar.ics' => 'events#calendar'
  match '/events/:country_name/:us_state/calendar.ics' => 'events#calendar'

  match ':controller(/:action(/:id))', :controller => /admin\/[^\/]+/
  match '/:controller(/:action(/:id))'
end
