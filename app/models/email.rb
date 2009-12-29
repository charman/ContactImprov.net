class Email < ActiveRecord::Base
  include AccessibleAttributeEncoding

  has_one :jam_entry
  has_one :event_entry
  has_one :organization_entry
  has_one :person_entry

  acts_as_list
  acts_as_versioned
  self.non_versioned_columns << 'created_at'

  attr_accessible :address

  validates_presence_of :address
  validates_email_format_of :address, :domain_lookup => false


  def before_save
    sanitize_attributes!
  end

  def before_validation
    #  Remove leading/trailing whitespace, which causes validates_email_format_of to fail
    self.address.strip!
  end

  def completely_blank?
    self.address.blank?
  end

  def version_condition_met?
    for_entity_id_changed? || position_changed? || address_changed?
  end

end
