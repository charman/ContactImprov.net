class UserController < ApplicationController

  before_filter :login_required, :only => [:change_email, :change_password, :edit, :index]

  ssl_allowed :index, :request_password_reset, :password_reset_requested, 
    :reset_password, :request_account, :account_requested, :edit,
    :change_password, :change_email, :activate

  #  In order for the AJAX auto_complete plugin to work, we need to disable authenticity
  #   checking when using POST requests to the auto_complete_[object]_[method] action that 
  #   is created by auto_complete_for.
  skip_before_filter :verify_authenticity_token, 
    :only => ['auto_complete_for_country_name_english_name', 'auto_complete_for_us_state_name']


  def account_requested
  end

  #  The activation page can be reached from a link that is sent to the user that
  #   looks something like this:
  #     http://hostname/activate/89cfb65813d84a3f4d65b59f5aaaec033a63f3a6
  #   Note that there is a route in config/routes.rb that converts from /activate to 
  #   /user/activate.
  #        
  #  When the page is requested using GET, a page will be sent that contains a form asking the user
  #   to enter (and confirm) a new password.  When the form is submitted, the form data will be
  #   POST'ed back to this action.  If the passwords match, the user will be redirected to a new page;
  #   otherwise, the form will be retrieved using a GET request, and the process repeats.
  def activate
    #  [CTH]  This code originally had ':false' after the question mark, instead of 'nil', 
    #          which was a complete bear to debug, as :false != false
    @user = params[:activation_code].blank? ? nil : User.find_by_activation_code(params[:activation_code])

    if @user && @user.state == 'active'
      # User has already been activated, so redirect on to original page
      # TODO: Do we really want to log the user on with just an activation code?  Now that the
      #        activation code is no longer being deleted on activation, it effectively becomes
      #        second password - but a password that the user cannot change.
      UserSession.create(@user)   # Log the user in
      redirect_back_or_home
      return
    end

    #  We may or may not already have an email address on file for this user.  But if
    #   they provided an email address on the login page, then we use this email 
    #   address instead of the email address on file.
    if @user && !flash[:email].blank?
      @user.email = flash[:email]
    end

    if request.post? && @user
      if params["user"] 
        #  If the user did not provide an email (and they won't, when the email 
        #   field is hidden when they use their activation code), then we will 
        #   use the email address already associated with the account.
        if params["user"]["email"]
          @user.email               = params["user"]["email"]
        end
        @user.password              = params["user"]["password"]
        @user.password_confirmation = params["user"]["password_confirmation"]
      end

      #  Perform validation (on the passwords from form, since nothing else has changed)
      if @user.valid?
        case @user.state
        when 'passive'
          #  We activate 'passive' accounts *iff* the user provides a valid subscriber ID
          #  (So we don't activate a passive account even if the user provides a valid
          #  password - since, technically, no password should have been set yet...)
# CI_TODO: Rewrite
#            if flash[:subscriber_identifier]
#              #  We can't call state transition functions (such as activate!) on an object until 
#              #   the object has been saved to the database.  At this point in the code, @user
#              #   was created by calling init_from_subscriber earlier in this function - so @user
#              #   exists in memory but not the database.
#              @user.save!
#              @user.activate!
#              flash[:notice] = "Signup complete!"
#              self.current_user = @user   # Log the user in 
#            end
          #  TODO: Should we display some sort of error message here if no subscriber id was provided?
        when 'pending'
          @user.activate!
          flash[:notice] = "Signup complete!"
          UserSession.create(@user)   # Log the user in
        when 'active'
          UserSession.create(@user)   # Log the user in
        when 'suspended'
          #  TODO: What should we do here when someone tries to activate a suspended account?
        when 'deleted'
          #  TODO: What should we do here when someone tries to activate a deleted account?
        end
        redirect_to :action => "index"
      end
    end
  end

  def auto_complete_for_country_name_english_name
    country_names = CountryName.find(:all,
      :conditions => [ "LOWER(english_name) LIKE ?", '%' + params[:term] + '%'],
      :limit => 20,
      :order => 'english_name'
    )

    results = country_names.collect do |country_name|
      { 'value' => h(country_name.english_name) }
    end
    render :json => results.to_json
  end

  def auto_complete_for_us_state_name
    us_states = UsState.find(:all,
      :conditions => [ "LOWER(name) LIKE ?", '%' + params[:term] + '%'],
      :limit => 20,
      :order => 'name'
    )

    results = us_states.collect do |us_state|
      { 'value' => h(us_state.name)  }
    end
    render :json => results.to_json
  end

  def change_email
    #  lemma: Because login_required is used as a before_filter for this action, the user is
    #          logged in, and current_user returns a valid User object.
    @user = current_user

    if request.post?
      if @user.valid_password?(params["password"])
        if params["email"] == params["email_confirmation"]
          old_email = @user.email
          @user.email = params["email"]

          if @user.valid?
            @user.save!
            UserSession.create(@user)   # Log the user in
            AdminMailer.user_changed_email(old_email, @user.email, @user).deliver

            flash.now[:notice] = nil
            flash.now[:change_successful] = true
          end
        else
          flash.now[:notice] = "<h2>email addresses do not match</h2>" + 
                                "<p>The two email addresses that you provided " + 
                                "('#{params["email"]}' and '#{params["email_confirmation"]}') do not match.</p>"
        end
      else
        flash.now[:notice] = "<h2>Old password incorrect</h2>" + 
                              "<p>You must provide your old password in order to change your password.</p>"
      end
    end
  end

  def change_password
    #  lemma: Because login_required is used as a before_filter for this action, the user is
    #          logged in, and current_user returns a valid User object.
    @user = current_user

    if request.post?
      if @user.valid_password?(params["old_password"])
        @user.password = params["password"]
        @user.password_confirmation = params["password_confirmation"]

        if @user.valid?
          @user.save!
          UserSession.create(@user)   # Log the user in

          flash.now[:notice] = nil
          flash.now[:change_successful] = true
        end
      else
        flash.now[:notice] = '<h2>Incorrect old password</h2>' + 
                          '<p>You must provide your old password in order to change your password.</p>' +
                          '<p>If you don\'t remember your password, please go to the ' +
                          '<a href="/user/request_password_reset">Password Reset page</a>.</p>'
      end
    end
  end

  def denied
    #  Keep flash[:denied_path]
    flash.keep
  end

  def edit
    @priority_countries = ["United States", "Austria", "Brazil", "Canada", "France", 
      "Germany", "Italy", "Spain", "Switzerland", "United Kingdom"]

    #  lemma: Because login_required is used as a before_filter for this action, the user is
    #          logged in, and current_user returns a valid User object.
    @user = current_user

    if request.put?
      @user.person.attributes = params[:user][:person]

      if @user.valid?
        @user.person.save!
        @user.save!
        redirect_to :action => 'index'
      end
      @error_messages = @user.person.errors.full_messages
    end
  end

  def index
    @user = self.current_user
#      cache_entries_for_countries
  end

  def password_reset_requested
  end

  def request_account
    @user_account_request = UserAccountRequest.new
    @uar_person   = Person.new
    @uar_email    = Email.new

    if request.post?
      @user_account_request.attributes   = params[:user_account_request]
      @uar_person.attributes             = params[:uar_person]
      @uar_email.attributes              = params[:uar_email]

      #  Validate each set of fields, regardless of whether or not the other sets are valid
      person_valid   = @uar_person.valid?
      email_valid    = @uar_email.valid?

      if @user_account_request.valid? && person_valid && email_valid
        user = User.find_by_email(params[:uar_email][:address])
        if user
          process_password_reset_request(user, params[:uar_email][:address])
        else
          @uar_person.save!
          @uar_person.reload                                 #  reload the Person object to retrieve its entity
#            @uar_email.for_entity_id = @uar_person.entity.id   #  email addresses must be linked to an entity
          @uar_email.save!

          @user_account_request.person   = @uar_person
          @user_account_request.email    = @uar_email
          @user_account_request.save!

          AdminMailer.account_request(@user_account_request).deliver

          redirect_to :action => "account_requested"
        end
      end
    end
  end

  #  If a valid email address was submitted, then send a password reset email to the user.
  #   If an invalid email address was submitted, then we currently fail silently.
  def request_password_reset
    if request.post? 
      if params[:email].empty?
        flash.now[:notice] = "<h2>Problem resetting password</h2><p>You must provide an email address</p>"
        return
      elsif params[:email] != params[:email_confirmation]
        flash.now[:notice] = "<h2>Problem resetting password</h2><p>The email addresses you provided do not match</p>"
        return
      end

      @user = User.find_by_email(params[:email])
      if @user
        process_password_reset_request(@user, params[:email])
      else
        flash.now[:notice] = "<h2>Problem resetting password</h2>" + 
                              "<p>We don't seem to have any records of a user with the email address <i>" + params[:email] + "</i></p>"
      end
    end
  end

  def reset_password
    if params.has_key?('password_reset_code')
      @user = User.find_by_password_reset_code(params[:password_reset_code])
    end

    if !@user
      flash.now[:notice] = '<h2>Invalid password reset code</h2>' +
                            '<p></p>'
      return
    end

    if request.post?
      #  TODO: Test that params["user"] exists...
      @user.password = params["user"]["password"]
      @user.password_confirmation = params["user"]["password_confirmation"]

      if @user.valid?
        @user.password_reset_code = nil
        @user.save!
        UserSession.create(@user)   # Log the user in

        flash[:reset_successful] = true
      end
    end
  end


private

  def process_password_reset_request(user, email)
    if user.active?
      user.make_password_reset_code
      UserMailer.password_reset(user).deliver
      flash[:email] = email
      redirect_to :action => 'password_reset_requested'
    elsif user.pending?
      #  Resend activation email
      user.make_activation_code
      UserMailer.signup_notification(user).deliver

      flash.now[:notice] = "<h2>You need to activate your account</h2>" +
                            "<p>We have resent an email to <i>#{email}</i> " + 
                            "with instructions for activating your account. " +
                            "If you don't receive the email shortly, please check your spam filters.</p>"
    elsif user.passive?
      AdminMailer.passive_user_login_attempt(email).deliver
      flash.now[:notice] = "<h2>Your account is not set up yet</h2>" +
                            "<p>An email has been sent to the ContactImprov.net staff letting them " +
                            "know they need to finish setting up your account.</p>"
                            #  TODO: Provide explanation of how to get your account set up...
                            #         And mailto link?
    else
      #  TODO: Handle cases where user's state is not active or pending
    end
  end

end
