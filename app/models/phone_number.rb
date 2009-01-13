class PhoneNumber < ActiveRecord::Base
  include SanitizeAccessibleAttributes

  has_one :jam_entry
  has_one :event_entry
  has_one :organization_entry
  has_one :person_entry

  acts_as_versioned
  self.non_versioned_columns << 'created_at'

  attr_accessible :number

  validates_presence_of :number


  def before_save
    sanitize_attributes
  end

  def completely_blank?
    self.number.blank?
  end

  def version_condition_met?
    for_entity_id_changed? || number_changed?
  end

end
