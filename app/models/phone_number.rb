class PhoneNumber < ActiveRecord::Base
  include SanitizeAccessibleAttributes

  has_one :contact_event

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
