require 'digest/sha1'
class User < ActiveRecord::Base
  belongs_to :person
#  has_many :entries, :foreign_key => 'owner_user_id'
#  has_one :entity, :as => :resource
  has_one :contact_event
  
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of       :email
  validates_email_format_of   :email, :domain_lookup => false
  validates_length_of         :email, :within => 3..100
  validates_uniqueness_of     :email, :case_sensitive => false
  validates_presence_of       :password,                   :if => :password_required?
  validates_presence_of       :password_confirmation,      :if => :password_required?
  validates_length_of         :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of   :password,                   :if => :password_required?
  
  #  Per the Rails docs, these validations will not fail if the association hasn't been assigned.
  validates_associated :person
  
  before_save :encrypt_password

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :email, :password, :password_confirmation

  # [CTH]  Even though we specify an initial state for the state machine,
  #        the state is actually nil when we create a Users object using
  #        User.new.  The state is not set to our specified initial value
  #        until we save the User object.  [At least as of acts_as_state_machine
  #        revision 66]
  # 
  #        For more info, see here:
  #          http://rails.aizatto.com/2007/05/24/ruby-on-rails-finite-state-machine-plugin-acts_as_state_machine/

  acts_as_state_machine :initial => :passive
  state :passive
  state :pending, :enter => :do_pending
  state :active,  :enter => :do_activate
  state :suspended
  state :deleted, :enter => :do_delete

  #  QUIRKY BEHAVIOR WARNING:  You must save the User object before invoking an action!!
  #
  #  Invoking a transition event before the User object is saved to the database seems to produce
  #   inconsistent results.  Specifically, if I use User.new to create a new user, and then invoke
  #   either the register! or activate! actions before saving the user to the database, then the
  #   user's state is immediately updated.  But if I invoke either the suspend! or delete! action,
  #   then the user's state is *not* updated.  All events work as expected after the User object
  #   has been saved.
  #  Let's assume that the default behavior is that you cannot update a state until the User has
  #   been created.  I can understand why the register! event actually works in this case, because
  #   the register changes the state to pending, which causes the do_pending function to be called -
  #   and do_pending calls make_activation_code, which in turn calls save.  So the register! action
  #   actually calls save before updating the state.  But why does the activate! event actually change
  #   the state in this case?  Both activate! and delete! modify properties of the User object (both
  #   modify deleted_at, while activate! also modifies activated_at and activation_code), and both
  #   have transition functions (do_activate and do_delete, respectively), but only activate! actually
  #   changes the user's state.
  #  Obviously I'm missing something here...

  event :register do
    transitions :from => :passive, :to => :pending, :guard => Proc.new {|u| !(u.crypted_password.blank? && u.password.blank?) }
  end
  
  event :activate do
    transitions :from => [:passive, :pending], :to => :active 
  end
  
  event :suspend do
    transitions :from => [:passive, :pending, :active], :to => :suspended
  end
  
  event :delete do
    transitions :from => [:passive, :pending, :active, :suspended], :to => :deleted
  end

  event :unsuspend do
    transitions :from => :suspended, :to => :active,  :guard => Proc.new {|u| !u.activated_at.blank? }
    transitions :from => :suspended, :to => :pending, :guard => Proc.new {|u| !u.activation_code.blank? }
    transitions :from => :suspended, :to => :passive
  end


  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(email, password)
    u = find_in_state :first, :active, :conditions => ["email = ?", email] # need to get the salt
    if u && u.authenticated?(password) 
      # [CTH]  Save the time that the user logged.
      #
      #        Please note that this function is called from the login_from_basic_auth
      #        function in authenticated_system.rb, but not from the login_from_session
      #        or login_from_cookie functions - so the last login timestamp is not updated
      #        when logging in by cookie or session.  This may not be the desired behavior.
      #        On the other hand, the logged_in? function is called on a regular basis when
      #        users are trying to access restricted pages, and that function tries calling
      #        the login_from_* functions in sequence until one of the functions indicate
      #        that the user is logged in.  Normally the user has to supply a password at some
      #        point in time, and thereafter the user's identity is confirmed using
      #        either the cookie or the session.  Do we really want to update the timestamp in
      #        the login_from_cookie function, which will cause a database update every time
      #        the cookie is checked?  That may not be the desired behavior either.
      #
      #        So, for now, the login timestamp is only updated when the user logs in using a
      #        password.  We may want to revisit this behavior eventually...
      u.update_attribute(:last_login_at, DateTime.now)
      u
    else
      nil
    end
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def first_name
    if person.nil?
      ''
    else
      person.first_name
    end
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  def last_name
    if person.nil?
      ''
    else
      person.last_name
    end
  end

  def make_password_reset_code
    #  TODO: Using the current time is not a good source of randomness...
    self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    save
    self.password_reset_code
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  def set_temporary_password
    self.password              = 'completelykimpossiblyunguessable'
    self.password_confirmation = 'completelykimpossiblyunguessable'
    self.encrypt_password
  end

    # [CTH]  TODO: (?) Re-protect this method?  It was unprotected for account creation
    #        using script/runner
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") if new_record?
      self.crypted_password = encrypt(password)
    end

    def make_activation_code
      self.deleted_at = nil
      #  TODO: Using the current time is not a good source of randomness...
      self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
      save
    end

      
  protected
    def do_delete
      self.deleted_at = Time.now.utc
    end

    def do_activate
      self.activated_at = Time.now.utc
      self.deleted_at = nil
      # [CTH]  Version 3119 of restful_authentication uses an observer to detect a state
      #        transition, and sends the email from the observer function.  We send the
      #        email directly from a state transition callback function.
      # 
      #        This approach is described in comments on this page:
      #          http://harrylove.org/2007/12/17/activation-emails-with-restful-authentication-and-acts_as_state_machine
      #  TODO: Send user email notifying them their account has been activated
      ## UserMailer.deliver_activation(self) #this email could be left out
    end

    def do_pending
      make_activation_code
    end

    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
end
