class Person < ActiveRecord::Base
  include SanitizeAccessibleAttributes

  has_one :contact_event
  has_one :user
  
  acts_as_versioned
  self.non_versioned_columns << 'created_at'

  attr_accessible :first_name, :last_name

  validates_presence_of :last_name

  def before_save
    sanitize_attributes
  end

  def completely_blank?
    self.first_name.blank? && self.last_name.blank?
  end

  def last_comma_first
    "#{self.last_name}, #{self.first_name}"
  end

  def version_condition_met?
    first_name_changed? || last_name_changed?
  end

end
