class UserAccountRequest < ActiveRecord::Base
  include AccessibleAttributeEncoding

  belongs_to :person
  belongs_to :email
  belongs_to :location

  attr_accessible :something_about_contact_improv, :existing_entries

  before_save :sanitize_attributes!

  validates_presence_of :something_about_contact_improv 

  acts_as_state_machine :initial => :new
  state :new
  state :accepted
  state :rejected
  state :contacted

  event :accept do
    transitions :from => [:new, :contacted], :to => :accepted
  end

  event :reject do
    transitions :from => [:new, :contacted], :to => :rejected
  end

  event :contact do
    transitions :from => :new, :to => :contacted
  end


  def create_user_account_and_deliver_signup_email
    user = User.new
    user.email = self.email.address
    user.person = self.person
    user.randomize_password
    user.save!
    user.register!
    UserMailer.signup_notification(user).deliver
    user
  end
  
end
