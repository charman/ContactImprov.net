ContactImprovNet::Application.configure do

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Enable threaded mode
  # config.threadsafe!

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # [CTH]
  log_pipe = IO.popen("/usr/local/apache2/bin/rotatelogs #{::Rails.root.to_s}/log/production_log.%Y%m%d 86400", 'a')
  config.logger = Logger.new(log_pipe)

  config.action_mailer.delivery_method = :sendmail
  config.active_support.deprecation = :log

end
