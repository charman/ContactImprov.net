class JamEntry < ActiveRecord::Base
  include SanitizeAccessibleAttributes

  belongs_to :email
  belongs_to :location
  belongs_to :owner_user, :class_name => 'User', :foreign_key => 'owner_user_id'
  belongs_to :person
  belongs_to :phone_number
  belongs_to :url

  acts_as_versioned
  self.non_versioned_columns << 'created_at'

  attr_accessible :title, :description, :schedule, :cost

  validates_presence_of :title, :description, :schedule, :cost


  def before_save
    sanitize_attributes
  end

  def version_condition_met?
    title_changed? || description_changed? || schedule_changed? || cost_changed? || ci_notes_changed?
  end

end