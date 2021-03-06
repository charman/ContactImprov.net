require 'digest/sha1'
class User < ActiveRecord::Base
  belongs_to :person
  belongs_to :own_person_entry, :class_name => 'PersonEntry', :foreign_key => 'own_person_entry_id'
  has_many :jam_entries,          :foreign_key => 'owner_user_id'
  has_many :event_entries,        :foreign_key => 'owner_user_id'
  has_many :organization_entries, :foreign_key => 'owner_user_id'
  has_many :person_entries,       :foreign_key => 'owner_user_id'
  
  validates_presence_of       :email
  validates_email_format_of   :email, :domain_lookup => false
  validates_length_of         :email, :within => 3..100
  validates_uniqueness_of     :email, :case_sensitive => false

  #  Per the Rails docs, these validations will not fail if the association hasn't been assigned.
  validates_associated :person
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :email, :password, :password_confirmation

  acts_as_authentic do |c|
    c.act_like_restful_authentication = true
    c.maintain_sessions = false
  end

  # [CTH]  Even though we specify an initial state for the state machine,
  #        the state is actually nil when we create a Users object using
  #        User.new.  The state is not set to our specified initial value
  #        until we save the User object.  [At least as of acts_as_state_machine
  #        revision 66]
  # 
  #        For more info, see here:
  #          http://rails.aizatto.com/2007/05/24/ruby-on-rails-finite-state-machine-plugin-acts_as_state_machine/

  #  [CTH, 2011/5/27]  The acts_as_state_machine initial state isn't being set properly with rails 3.0.7,
  #                     so we set the initial state here as a hack.
  before_validation 'self.state = "passive" if !self.state'

  include AASM

  aasm :column => 'state' do
    state :passive, :initial => true
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
  end


  def first_name
    if person.nil?
      ''
    else
      person.first_name
    end
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
    
end
