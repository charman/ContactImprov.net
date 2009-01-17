class PersonEntry < ActiveRecord::Base
  include SanitizeAccessibleAttributes

  belongs_to :person
  belongs_to :email
  belongs_to :location
  belongs_to :owner_user, :class_name => 'User', :foreign_key => 'owner_user_id'
  belongs_to :phone_number
  belongs_to :url

  acts_as_versioned
  self.non_versioned_columns << 'created_at'

  attr_accessible :description

  def self.total_entries_for_user(user)
    PersonEntry.count :conditions => ["owner_user_id = ?", user.id]
  end

  def before_save
    sanitize_attributes
  end

  def boolean_flag_names
    ['is_owner_user']
  end

  def title
    if person.first_name.blank?
      person.last_name
    else
      "#{person.first_name} #{person.last_name}"
    end
  end

  def version_condition_met?
    ci_notes_changed?
  end

end
