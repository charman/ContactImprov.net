ContactImprovNet::Application.routes.draw do

  resource :session do
    collection do
      get :no_cookies_for_you
    end
  end

  match '/activate/:activation_code' => 'user#activate', :as => :activate
  match '/denied' => 'user#denied', :as => :denied
  match '/login' => 'sessions#new', :as => :login
  match '/logout' => 'sessions#destroy', :as => :logout
  match '/reset_password/:password_reset_code' => 'user#reset_password', :as => :activate

  match '/' => 'home#index', :as => :index

  namespace 'admin' do
    match '/' => 'home#index'
  end

  match '/events/list/:year/:month' => 'events#list'
  match '/events/list/:year' => 'events#list'
  match '/jams/list/:country_name/:us_state' => 'jams#list'
  match '/jams/list/:country_name' => 'jams#list'
  match '/organizations/list/:country_name/:us_state' => 'organizations#list'
  match '/organizations/list/:country_name' => 'organizations#list'
  match '/people/list/:country_name/:us_state' => 'people#list'
  match '/people/list/:country_name' => 'people#list'

  match '/calendars/feed/:country_name' => 'calendars#feed'
  match '/calendars/feed/:country_name/:us_state' => 'calendars#feed'

  match ':controller(/:action(/:id))', :controller => /admin\/[^\/]+/
  match '/:controller(/:action(/:id))'

end
