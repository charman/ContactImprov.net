class Url < ActiveRecord::Base
  include AccessibleAttributeEncoding

  has_one :jam_entry
  has_one :event_entry
  has_one :organization_entry
  has_one :person_entry

  acts_as_versioned
  self.non_versioned_columns << 'created_at'

  attr_accessible :address

  before_save :sanitize_attributes!, :set_address_to_address_with_protocol!

  validates_presence_of :address


  def address_with_protocol
    if self.address =~ /:\/\// 
      self.address
    else
      "http://#{self.address}"  #  Default protocol is http (instead of https, etc)
    end
  end
  
  def address_without_protocol
    if self.address =~ /:\/\/(.*)/ 
      $1
    else
      self.address
    end
  end

  def completely_blank?
    self.address.blank?
  end

  def set_address_to_address_with_protocol!
    self.address = self.address_with_protocol
  end

  def version_condition_met?
    for_entity_id_changed? || address_changed?
  end

end
