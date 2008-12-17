# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  # You have to specify the :lib option for libraries, where the Gem name (sqlite3-ruby) differs from the file itself (sqlite3)
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Comment line to use default local time.
  config.time_zone = 'UTC'

  # The internationalization framework can be changed to have another default locale (standard is :en) or more load paths.
  # All files from config/locales/*.rb,yml are added automatically.
  # config.i18n.load_path << Dir[File.join(RAILS_ROOT, 'my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_ci_rails_session',
    :secret      => 'bb35e168458d5f671fbfe6567c43baec61075e850b361ae66e3547388979c43d837601d76daab0b48f03760228241355c519e91d57dbeb6e4a11d58b4197b067'
  }

  #  [CTH]
  config.active_record.table_name_prefix = "ci_"
  config.active_record.primary_key_prefix_type = :table_name_with_underscore

  #  [CTH]  When the command 'rake db:test:prepare' was run, the tables it created
  #          in the cq_rails_test database would have the ci_ prefix prepended to
  #          all table names that were in the cq_rails database - so we ended up 
  #          with table names like:
  #            ci_ci_companies, ci_ci_contacts_list_downloads, ci_cq_company_field_display_order
  #         It's possible that this rake task was confused because (at the moment)
  #          some tables have a cq_ prefix instead of a ci_ prefix.
  #         The line below fixes the problem with the duplicate ci_ prefixes.  Unfortunately,
  #          the configuration option is not well documented.  The only references to 
  #          it on the api.rubyonrails.org site are in the changelogs.  Apparently, the object
  #          config.active_record has type ActiveRecord::Base.  The default value for this
  #          option is ':ruby', which apparently causes the schemas to be generated from the
  #          db/schema.rb file (according to the comments in db/schema.rb, the file is 
  #          auto-generated based on the current database tables).  I believe the ':sql' value
  #          causes the cq_rails_test tables to be generated using an SQL dump.
  #
  #         TODO: Once we no longer have any tables with a ci_ prefix, check to see if this
  #                configuration option is still necessary.
  config.active_record.schema_format = :sql

  config.gem "calendar_date_select"
  #  [/CTH]

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # Please note that observers generated using script/generate observer need to have an _observer suffix
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
end


# Include your application configuration below

ActionController::Base.cache_store = :mem_cache_store

#  List of people who should receive email when an unhandled exception occurs
ExceptionNotifier.exception_recipients = %w(charman@acm.org)
ExceptionNotifier.sender_address = %("CQadmin" <app.error@contactimprov.net>)
ExceptionNotifier.email_prefix = "[RailsError] "


# These defaults are used in GeoKit::Mappable.distance_to and in acts_as_mappable
GeoKit::default_units = :miles
GeoKit::default_formula = :sphere

# This is the timeout value in seconds to be used for calls to the geocoder web
# services.  For no timeout at all, comment out the setting.  The timeout unit
# is in seconds. 
GeoKit::Geocoders::timeout = 3

# These settings are used if web service calls must be routed through a proxy.
# These setting can be nil if not needed, otherwise, addr and port must be 
# filled in at a minimum.  If the proxy requires authentication, the username
# and password can be provided as well.
GeoKit::Geocoders::proxy_addr = nil
GeoKit::Geocoders::proxy_port = nil
GeoKit::Geocoders::proxy_user = nil
GeoKit::Geocoders::proxy_pass = nil

# This is your yahoo application key for the Yahoo Geocoder.
# See http://developer.yahoo.com/faq/index.html#appid
# and http://developer.yahoo.com/maps/rest/V1/geocode.html
GeoKit::Geocoders::yahoo = 'REPLACE_WITH_YOUR_YAHOO_KEY'
    
# This is your Google Maps geocoder key. 
# See http://www.google.com/apis/maps/signup.html
# and http://www.google.com/apis/maps/documentation/#Geocoding_Examples
#GeoKit::Geocoders::google = 'ABQIAAAAmYdKm0AsUr2XPtjTCC8gNBT2yXp_ZAY8_ufC3CFXhHIE1NvwkxTaHbyRAvbHi_paAVWJ5_92eHrxYQ'
GeoKit::Geocoders::google = File.open('config/google_maps_api_key.txt') { |f| f.read }    

# This is your username and password for geocoder.us.
# To use the free service, the value can be set to nil or false.  For 
# usage tied to an account, the value should be set to username:password.
# See http://geocoder.us
# and http://geocoder.us/user/signup
GeoKit::Geocoders::geocoder_us = false 

# This is your authorization key for geocoder.ca.
# To use the free service, the value can be set to nil or false.  For 
# usage tied to an account, set the value to the key obtained from
# Geocoder.ca.
# See http://geocoder.ca
# and http://geocoder.ca/?register=1
GeoKit::Geocoders::geocoder_ca = false

# This is the order in which the geocoders are called in a failover scenario
# If you only want to use a single geocoder, put a single symbol in the array.
# Valid symbols are :google, :yahoo, :us, and :ca.
# Be aware that there are Terms of Use restrictions on how you can use the 
# various geocoders.  Make sure you read up on relevant Terms of Use for each
# geocoder you are going to use.
GeoKit::Geocoders::provider_order = [:google]
