class PhoneNumber < ActiveRecord::Base
  belongs_to :for_entity, :class_name => 'Entity', :foreign_key => 'for_entity_id'
  has_one :entity, :as => :resource

  acts_as_versioned
  self.non_versioned_columns << 'created_at'

  attr_accessible :number

  validates_presence_of :number

  def after_save
    #  Create an entity object for the current object, if it does not already exist
#    if !self.entity
#      e = Entity.new
#      e.resource = self
#      e.save!
#    end  
  end

  def version_condition_met?
    for_entity_id_changed? || phone_type_id_changed? || number_changed?
  end

end
