class Person < ActiveRecord::Base
  include AccessibleAttributeEncoding

  has_one :jam_entry
  has_one :event_entry
  has_one :organization_entry
  has_one :person_entry
  has_one :user
  
  acts_as_versioned
  self.non_versioned_columns << 'created_at'

  attr_accessible :first_name, :last_name

  before_save :sanitize_attributes!

  validates_presence_of :last_name


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
