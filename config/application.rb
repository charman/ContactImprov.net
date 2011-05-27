require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module ContactImprovNet
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += %W(#{config.root}/lib)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'UTC'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    
    
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

    config.middleware.use ExceptionNotifier,
      :email_prefix => "[CI.net - RailsError] ",
      :sender_address =>  %{"CI.net" <app.error@contactimprov.net>},
      :exception_recipients => %w{charman@acm.org}
  end
end


#  TODO: Where should the code below be moved to as part of the Rails 3 upgrade?  The initializers directory?
ActionController::Base.cache_store = :mem_cache_store
