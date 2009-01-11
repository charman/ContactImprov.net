class Admin::UsersController < ApplicationController

  #  Protect all actions behind an admin login
  before_filter :admin_required
  
  #  Any actions that act on invidual members of the User class (as opposed to
  #   collections of Users) should use the 'find_user' function as a before_filter.
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge]

  skip_before_filter :verify_authenticity_token, 
    :only => ['auto_complete_for_user_by_person']


  def activate
    @user = User.find(params[:id])

    if request.post? && @user
      @user.attributes = params[:user]
      if @user.valid?
        @user.activate!   #  The activate! function calls save!
        UserMailer.deliver_activation(@user)
        redirect_to :action => 'index'
      end
    end
  end

  def auto_complete_for_user_by_person
    users = User.find(:all, 
      :conditions => [ "LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ?", 
        '%' + params[:user][:by_person] + '%',
        '%' + params[:user][:by_person] + '%'],
      :limit => 20,
      :joins => 'INNER JOIN ci_people ON ci_users.person_id = ci_people.person_id', 
      :order => 'last_name ASC')

    items = users.map { |user| "<li id=\"#{user.id}\">" + ERB::Util.h("#{user.person.last_name}, #{user.person.first_name}") + '</li>' }
    render :inline => "<ul>#{items.uniq.to_s}</ul>"
  end

  def create
    @user = User.new(params[:user])
    @user.person = Person.new(params[:user][:person])

    if @user.valid?
      @user.save!
      @user.register!
      UserMailer.deliver_signup_notification(@user)
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def destroy
    @user.delete!
    redirect_to '/admin/users'
  end

  def edit
    #  TODO: Most of this code is duplicated from /user/edit - refactor to minimize duplication
    @priority_countries = ["United States", "Austria", "Brazil", "Canada", "France", 
      "Germany", "Italy", "Spain", "Switzerland", "United Kingdom"]

    @user = User.find(params[:id])

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
    @total_users            = User.count
    @total_active_users     = User.count :conditions => "state = 'active'"
    @total_pending_users    = User.count :conditions => "state = 'pending'"
    @total_new_account_requests = UserAccountRequest.count :conditions => "state ='new'"

    if request.post? && params[:user] && params[:user][:id]
      redirect_to "/admin/users/show/#{params[:user][:id]}"
    end
  end

  def list
    @users = User.find(:all)
    @total_users = @users.size
  end

  def list_account_requests
    @account_requests          = UserAccountRequest.find(:all)
    @accepted_account_requests = UserAccountRequest.find(:all, :conditions => 'state = "accepted"')
    @new_account_requests      = UserAccountRequest.find(:all, :conditions => 'state = "new"')
    @rejected_account_requests = UserAccountRequest.find(:all, :conditions => 'state = "rejected"')
  end

  def list_active
    @users = User.find(:all, :conditions => "state = 'active'")
    @total_users = @users.size
  end

  def list_pending
    @users = User.find(:all, :conditions => "state = 'pending'")
    @total_users = @users.size
  end

  def map
    @locations = Location.find(:all, :conditions => "geocode_precision IS NOT NULL")
  end

  def new
  end

  def process_account_request
    if request.put?
      account_request = UserAccountRequest.find(params[:account_request_id])
      account_request.attributes = params[:user_account_request]

      #  Because the 'ci_notes' field is not attr_accessible, it won't be
      #   assigned a value when using attributes= for mass assignment
      account_request.ci_notes = params[:user_account_request][:ci_notes]

      if params[:commit] == 'Accept'
        account_request.accept!
        account_request.create_user_account_and_deliver_signup_email
      elsif params[:commit] == 'Reject'
        account_request.reject!
      # else just save the CQ comments without updating the state
      end

      account_request.save!

      redirect_to :action => 'list_account_requests'
    end
  end

  def purge
    @user.destroy
    redirect_to '/admin/users'
  end

  def reset_password
    @user = User.find(params[:id])

    if request.post? && @user
      @user.attributes = params[:user]
      if @user.valid?
        @user.save!
        UserMailer.deliver_password_reset_by_admin(@user, params[:user][:password])
        redirect_to :action => 'show', :id => params[:id]
      end
    end
  end

  def show
    @user = User.find(params[:id])
    @entries = EventEntry.find(:all, :conditions => ["owner_user_id = ?", params[:id]])
  end

  def show_account_request
    @account_request = UserAccountRequest.find(params[:id])
  end

  def suspend
    @user.suspend! 
    redirect_to '/admin/users'
  end

  def unsuspend
    @user.unsuspend! 
    redirect_to '/admin/users'
  end


protected

  def find_user
    @user = User.find(params[:id])
  end

end
