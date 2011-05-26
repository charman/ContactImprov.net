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
        UserMailer.activation(@user).deliver
        redirect_to :action => 'index'
      end
    end
  end

  def auto_complete_for_user_by_person
    users = User.find(:all, 
      :conditions => [ "LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ?", 
        '%' + params[:term] + '%',
        '%' + params[:term] + '%'],
      :limit => 20,
      :joins => 'INNER JOIN ci_people ON ci_users.person_id = ci_people.person_id', 
      :order => 'last_name ASC')

    results = users.collect do |user|
      { 
        'value' => h("#{user.person.last_name}, #{user.person.first_name}"),
        'user_id' => user.id
      }
    end
    render :json => results.to_json
  end

  def create
    @user = User.new(params[:user])
    @user.person = Person.new(params[:user][:person])

    if @user.valid?
      @user.save!
      @user.register!
      UserMailer.signup_notification(@user).deliver
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

    @total_geocodable_locations = Location.count :conditions => "geocode_precision IS NOT NULL"
    @total_locations = Location.count

    if request.post? && params[:user] && params[:user][:id]
      redirect_to "/admin/users/show/#{params[:user][:id]}"
    end
  end

  def list
    @users = User.find(:all)
    @total_users = @users.size
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
        UserMailer.password_reset_by_admin(@user, params[:user][:password]).deliver
        redirect_to :action => 'show', :id => params[:id]
      end
    end
  end

  def show
    @user = User.find(params[:id])
    @jam_entries          = JamEntry.find(:all, :conditions => ["owner_user_id = ?", params[:id]])
    @event_entries        = EventEntry.find(:all, :conditions => ["owner_user_id = ?", params[:id]])
    @person_entries       = PersonEntry.find(:all, :conditions => ["owner_user_id = ?", params[:id]])
    @organization_entries = OrganizationEntry.find(:all, :conditions => ["owner_user_id = ?", params[:id]])
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
