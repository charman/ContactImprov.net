class Email < ActiveRecord::Base
  include SanitizeAccessibleAttributes

  has_one :contact_event

  acts_as_list
  acts_as_versioned
  self.non_versioned_columns << 'created_at'

  attr_accessible :address

  validates_presence_of :address

  def before_save
    sanitize_attributes
  end

  def version_condition_met?
    for_entity_id_changed? || position_changed? || address_changed?
  end


  def completely_blank?
    self.address.blank?
  end

end
