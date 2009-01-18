class OrganizationEntry < ActiveRecord::Base
  include SanitizeAccessibleAttributes

  belongs_to :organization
  belongs_to :email
  belongs_to :location
  belongs_to :owner_user, :class_name => 'User', :foreign_key => 'owner_user_id'
  belongs_to :phone_number
  belongs_to :url

  acts_as_versioned
  self.non_versioned_columns << 'created_at'

  attr_accessible :description


  def before_save
    sanitize_attributes
  end

  def boolean_flag_names
    ['studio_space', 'teaches_contact']
  end

  def title
    organization.name
  end

  def version_condition_met?
    ci_notes_changed?
  end

end
