class Company < ActiveRecord::Base
  include SanitizeAccessibleAttributes

  acts_as_versioned
  self.non_versioned_columns << 'created_at'

  attr_accessible :name
  
  validates_presence_of :name, :message => "for Company can't be blank"

  def after_save
    # #  Create an entity object for the current object, if it does not already exist
    # if !self.entity
    #   e = Entity.new
    #   e.resource = self
    #   e.save!
    # end  
  end

  def before_save
    sanitize_attributes
  end

  def version_condition_met?
    name_changed?
  end

end
