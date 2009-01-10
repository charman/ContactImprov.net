class Url < ActiveRecord::Base
  include SanitizeAccessibleAttributes

  has_one :company_entry
  has_one :jam_entry
  has_one :event_entry
  has_one :person_entry
  has_one :studio_entry

  acts_as_versioned
  self.non_versioned_columns << 'created_at'

  attr_accessible :address

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

  def before_save
    self.address = self.address_with_protocol
    sanitize_attributes
  end

  def completely_blank?
    self.address.blank?
  end

  def version_condition_met?
    for_entity_id_changed? || address_changed?
  end

end
