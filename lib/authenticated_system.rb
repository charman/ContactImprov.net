module AuthenticatedSystem

  protected
    # Returns true or false if the user is logged in.
    # Preloads @current_user with the user model if they're logged in.
    def logged_in?
      current_user != nil
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    # Filter method to enforce a login requirement.
    def login_required
      logged_in? || access_denied_to_stranger
    end

    def admin_required
      if logged_in? && current_user.admin?
        true
      else
        access_denied_to_user
      end
    end

    # Redirect as appropriate when an access request fails.
    #
    # The default action is to redirect to the login screen.
    #
    # Override this method in your controllers if you want to have special
    # behavior in case the user is not authorized
    # to access the requested action.  For example, a popup window might
    # simply close itself.
    def access_denied_to_stranger
      store_location
      if request.path != '/'    #  Don't tell the user they are not logged if they are accessing the root path
        flash[:notice] = "<h2>You are not logged in</h2>" +
                          "<p>You must login to access the requested page</p>"
      end
      redirect_to new_session_path
    end

    #  User is logged in, but is trying to access a restricted page
    def access_denied_to_user
      flash[:denied_url] = request.url
      redirect_to '/denied'
    end

    # Store the URI of the current request in the session.
    #
    # We can return to this location by calling #redirect_back_or_default.
    def store_location
      session[:return_to] = request.fullpath
    end

    # Redirect to the URI stored by the most recent store_location call or
    # to the passed default.
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    # Inclusion hook to make #current_user and #logged_in?
    # available as ActionView helper methods.
    def self.included(base)
      base.send :helper_method, :current_user, :logged_in?
    end

end
