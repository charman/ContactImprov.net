class Email < ActiveRecord::Base
#  belongs_to :for_entity, :class_name => 'Entity', :foreign_key => 'for_entity_id'
#  has_one :contacts_application
#  has_one :entity, :as => :resource
#  has_one :user_account_request

  acts_as_list
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

  def version_condition_met?
    for_entity_id_changed? || position_changed? || address_changed?
  end

end
