class Person < ActiveRecord::Base
#  has_one :contacts_application
#  has_one :entity, :as => :resource
  has_one :user
#  has_one :user_account_request
  
  acts_as_versioned
  self.non_versioned_columns << 'created_at'

  attr_accessible :first_name, :last_name

  validates_presence_of :last_name

  def after_save
    #  Create an entity object for the current object, if it does not already exist
    #  TODO: Refactor the entity creation code into a helper file shared across ActiveRecord classes
#    if !self.entity
#      e = Entity.new
#      e.resource = self
#      e.save!
#    end  
  end

  def last_comma_first
    "#{self.last_name}, #{self.first_name}"
  end

  def version_condition_met?
    first_name_changed? || last_name_changed?
  end

end
