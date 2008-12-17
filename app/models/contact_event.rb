class ContactEvent < ActiveRecord::Base
  #  has_one :entity, :as => :resource
  belongs_to :email
  belongs_to :location
  belongs_to :phone_number
  belongs_to :url

  acts_as_versioned
  self.non_versioned_columns << 'created_at'

  attr_accessible :title, :subtitle, :description, :start_date, :end_date

  validates_presence_of :title, :description, :start_date, :end_date

  def after_save
    # #  Create an entity object for the current object, if it does not already exist
    # if !self.entity
    #   e = Entity.new
    #   e.resource = self
    #   e.save!
    # end  
  end

  def version_condition_met?
    name_changed?
  end
end