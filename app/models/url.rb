class Url < ActiveRecord::Base
#  belongs_to :for_entity, :class_name => 'Entity', :foreign_key => 'for_entity_id'
#  has_one :contacts_application
#  has_one :entity, :as => :resource

  acts_as_versioned
  self.non_versioned_columns << 'created_at'

  attr_accessible :address

  validates_presence_of :address

  def after_save
    #  Create an entity object for the current object, if it does not already exist
#    if !self.entity
#      e = Entity.new
#      e.resource = self
#      e.save!
#    end  
  end

  def before_save
    self.address = self.address_with_protocol
  end

  def version_condition_met?
    for_entity_id_changed? || address_changed?
  end


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

end
