class SessionsController < ApplicationController

  rescue_from(ActionController::InvalidAuthenticityToken) { |e| redirect_to :action => 'nocookiesforyou' }

  ssl_allowed :new, :create, :destroy


  def create
    #  Check if an account with the given email address exists and is waiting to be activated
    if !params[:email].empty?
      params[:email] = params[:email].strip   # Remove leading/trailing whitespace
      user = User.find_by_email(params[:email])
      #  TODO: Add error handling if user.state is 'suspended', 'deleted', or 'passive'
      if user && user.state == 'pending'
        #  Resend activation email
        user.make_activation_code
        UserMailer.signup_notification(user).deliver
        
        flash[:notice] = "<h2>You need to activate your account</h2>" +
                          "<p>We have resent an email to <i>#{params[:email]}</i> " + 
                          "with instructions for activating your account. " +
                          "If you don't receive the email shortly, please check your spam filters.</p>"
        redirect_to :action => 'new'
        return
      end
    end
    
    #  User.authenticate() will fail if the user's state is not 'active'
    self.current_user = User.authenticate(params[:email], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default('/')
      flash[:notice] = "Logged in successfully"
    else
      if params[:email].empty?
        flash[:notice] = "<h2>Empty email address</h2>" +
                          "<p>You must provide an email address to log on</p>"
      elsif params[:password].empty?
        flash[:notice] = "<h2>Empty password</h2>" +
                          "<p>You must provide a password to log on</p>"
      else
        #   Check if there is a (non-active) account associated with the email address
        u = User.find_by_email(params[:email])      #  lemma: params[:email] is non-empty
        #  TODO: Send email to web@cq.com when a passive/suspended/deleted user tries to log on
        if u && u.passive?
          flash[:notice] = '<h2>This account is not set up yet</h2>' + 
                            '<p>If you would like to activate your account, please send email to ' +
                            '<a href="mailto:charman@acm.org?subject=User wants to reactivate ' + 
                            'suspended ContactImprov.net account">charman@acm.org</a>.</p>'
        elsif u && u.suspended?
          flash[:notice] = '<h2>This account has been suspended</h2>' + 
                            '<p>If you would like to reactivate your account, please send email to ' +
                            '<a href="mailto:charman@acm.org?subject=User wants to reactivate ' + 
                            'suspended ContactImprov.net account">charman@acm.org</a>.</p>'
        elsif u && u.deleted?
          flash[:notice] = '<h2>This account has been deleted</h2>' + 
                            '<p>If you would like to reactivate your account, please send email to ' +
                            '<a href="mailto:charman@acm.org?subject=User wants to reactivate ' + 
                            'deleted ContactImprov.net account">charman@acm.org</a>.</p>'
        else
          flash[:notice] = "<h2>Invalid email address or password</h2>\n" + 
                            "<p>We are having trouble logging you in to your acccout. " +
                             "Please confirm that the email address (<i>#{params[:email]}</i>) and password " +
                             "you provided are correct. </p>\n" +
                            "<p>If you have forgotten your password, please go to the " +
                             #  [CTH]  Trying to use the link_to function here produces the error message:
                             #            undefined method `link_to' for #<SessionsController:0x1805220>
                             #          so we hard code the password reset link here - which is potentially 
                             #          fragile.  There is probably a better way to do this...
                             '<a href="/user/request_password_reset">password reset page</a>.</p>' +
                             '<p>If you are still having trouble logging on, please send email to ' +
                             '<a href="mailto:charman@acm.org?subject=Unable to log on to ' + 
                             'my ContactImprov.net account">charman@acm.org</a>.</p>'
        end
      end
      #  Save user's email address so they won't need to retype it in the email field
      flash[:email] = params[:email]
      redirect_to :action => 'new'
    end
  end

  #  The '/logout' action is an alias for '/session/destroy
  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_to new_session_path
    ## redirect_back_or_default('/')
  end

  #  The 'new' action POST's data to the 'create' action
  #  The '/login' action is an alias for '/session/new
  def new
    #  Users who are logged in should not be shown the logon page, per feedback from confused users
    redirect_to '/' if logged_in?
  end

  def nocookiesforyou
  end

end
