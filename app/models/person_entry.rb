class PersonEntry < ActiveRecord::Base
  include AccessibleAttributeEncoding

  belongs_to :person
  belongs_to :email
  belongs_to :location
  belongs_to :owner_user, :class_name => 'User', :foreign_key => 'owner_user_id'
  belongs_to :phone_number
  belongs_to :url

  acts_as_versioned
  self.non_versioned_columns << 'created_at'

  attr_accessible :description

  validate :limit_non_admins_to_one_person_entry


  def self.find_geocoded_entries
    self.find(:all,
      :from => "ci_person_entries, ci_locations",
      :conditions => "ci_person_entries.location_id = ci_locations.location_id " + 
                     "AND geocode_precision IS NOT NULL"
    )
  end

  def self.total_entries_for_user(user)
    PersonEntry.count :conditions => ["owner_user_id = ?", user.id]
  end


  def after_save
    #  When a non-admin User saves a PersonEntry, their User account is updated
    #   to treat this PersonEntry as an entry for that User account.
    #  With the limit_non_admins_to_one_person_entry functions, this restricts
    #   non-admin Users to one PersonEntry, which is an entry for that User.
    if !self.owner_user.admin?
      self.owner_user.own_person_entry = self
      self.owner_user.save!
    end
  end

  def before_save
    sanitize_attributes!
  end

  def boolean_flag_names
    ['teaches_contact']
  end

  #  TODO: We may eventually want to relax/eliminate this constraint
  def limit_non_admins_to_one_person_entry
    return true if self.owner_user.admin?
    
    if !self.owner_user.own_person_entry.blank? && self != self.owner_user.own_person_entry
      errors.add_to_base("You are already listed in the directory of People")
      return false
    else
      return true
    end
  end

  def sortable_title
    if person.first_name.blank?
      person.last_name
    else
      "#{person.last_name}, #{person.first_name}"
    end
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
