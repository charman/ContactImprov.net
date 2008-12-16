module AuthenticatedSystem
  protected
    # Returns true or false if the user is logged in.
    # Preloads @current_user with the user model if they're logged in.
    def logged_in?
      current_user != :false
    end

    # Accesses the current user from the session.  Set it to :false if login fails
    # so that future calls do not hit the database.
    def current_user
      @current_user ||= (login_from_session || login_from_cookie || :false)
    end

    # Store the given user id in the session.
    def current_user=(new_user)
      session[:user_id] = (new_user.nil? || new_user.is_a?(Symbol)) ? nil : new_user.user_id
      @current_user = new_user || :false
    end

    # Check if the user is authorized
    #
    # Override this method in your controllers if you want to restrict access
    # to only a few actions or if you want to check if the user
    # has the correct rights.
    #
    # Example:
    #
    #  # only allow nonbobs
    #  def authorized?
    #    current_user.login != "bob"
    #  end
    def authorized?
      logged_in?
    end

    # Filter method to enforce a login requirement.
    #
    # To require logins for all actions, use this in your controllers:
    #
    #   before_filter :login_required
    #
    # To require logins for specific actions, use this in your controllers:
    #
    #   before_filter :login_required, :only => [ :edit, :update ]
    #
    # To skip this in a subclassed controller:
    #
    #   skip_before_filter :login_required
    #
    def login_required
      authorized? || access_denied_to_stranger
    end

    def admin_required
      if logged_in?
        if @current_user.admin?
          true
        else
          access_denied_to_user
        end
      else
        access_denied_to_stranger
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
      session[:return_to] = request.request_uri
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

    # Called from #current_user.  First attempt to login by the user id stored in the session.
    def login_from_session
      # [CTH]  We are using the find_by_user_id() function instead of the find_by_id()
      #        function because the name of our ID column is 'user_id', not 'id'.  The
      #        reason the column name is 'user_id' is because of this setting in our 
      #        config/environment.rb file:
      #          config.active_record.primary_key_prefix_type = :table_name_with_underscore
      self.current_user = User.find_by_user_id(session[:user_id]) if session[:user_id]
    end

    # Called from #current_user.  Finally, attempt to login by an expiring token in the cookie.
    def login_from_cookie
      user = cookies[:auth_token] && User.find_by_remember_token(cookies[:auth_token])
      if user && user.remember_token?
        user.remember_me
        cookies[:auth_token] = { :value => user.remember_token, :expires => user.remember_token_expires_at }
        self.current_user = user
      end
    end
end
