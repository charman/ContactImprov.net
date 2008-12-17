# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # Be sure to include AuthenticationSystem [sic] in Application Controller instead
  include AuthenticatedSystem

  # Send an email when an unhandled exception occurs
  include ExceptionNotifiable

  include AutoCompleteWithParamsPrefix

  include SslRequirement

  #  Allow SSL to be used on all pages.  Prevents an https -> http -> https redirection
  #   loop when using mod_rewrite in Apache to force an https connection.
  def ssl_allowed?
    true
  end

  # [CTH]  We use :logged_in? as a before_filter in order to check if a user is logged in,
  #        and :login_required to force a user to log in.  This is useful if we want to
  #        display a user's current login status without redirecting them to a login page.
  before_filter :logged_in?


  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => 'www.contactimprov.net'


  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'c8e85940919a6ceaff914a3afcaedd25'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
end
