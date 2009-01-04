class EventEntry < ActiveRecord::Base
  include SanitizeAccessibleAttributes

  belongs_to :email
  belongs_to :location
  belongs_to :owner_user, :class_name => 'User', :foreign_key => 'owner_user_id'
  belongs_to :person
  belongs_to :phone_number
  belongs_to :url

  acts_as_versioned
  self.non_versioned_columns << 'created_at'

  attr_accessible :title, :description, :fee_description, :start_date, :end_date

  validates_presence_of :title, :description, :start_date, :end_date


  def before_save
    if self.start_date > self.end_date
      self.start_date, self.end_date = self.end_date, self.start_date
    end
    sanitize_attributes
  end

  def version_condition_met?
    title_changed? || description_changed? || fee_description_changed? || start_date_changed? || end_date_changed? || ci_notes_changed?
  end

end
