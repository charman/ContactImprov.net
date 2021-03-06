class SessionsController < ApplicationController

  rescue_from(ActionController::InvalidAuthenticityToken) { |e| redirect_to :action => 'nocookiesforyou' }


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
    
    @user_session = UserSession.new(
      :email => params[:email], 
      :password => params[:password],
      :remember_me => (params[:remember_me] == "1")
    )
    if @user_session.save
      redirect_to (flash[:login_referer_page] ? flash[:login_referer_page] : '/')
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
    current_user_session.destroy if current_user_session 
    redirect_back_or_home
  end

  #  The 'new' action POST's data to the 'create' action
  #  The '/login' action is an alias for '/session/new
  def new
    if logged_in?
      #  Users who are logged in should not be shown the logon page, per feedback from confused users
      redirect_back_or_home 
    elsif request.referer
      #  If the user tried to access a page was denied, redirect them to the original page they
      #   were denied access to, and not the '/denied' page
      flash[:login_referer_page] = (flash[:denied_path] ? flash[:denied_path] : request.referer)
    end
  end

  def nocookiesforyou
  end

end
