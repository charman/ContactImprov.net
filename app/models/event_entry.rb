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

  attr_accessible :title, :description, :cost, :start_date, :end_date

  validates_presence_of :title, :description, :start_date, :end_date


  def self.find_by_year(year)
    first_of_year = "'#{year}-01-01'"
    last_of_year  = "'#{year}-12-31'"
    @entries = EventEntry.find(:all, :order => 'start_date ASC',
      :conditions => "(start_date >= #{first_of_year} AND start_date <= #{last_of_year}) OR " +
                     "(end_date >= #{first_of_year} AND end_date <= #{last_of_year})"
    )
  end
  
  def self.find_by_year_month(year, month)
    first_of_month = "'#{year}-#{month}-01'"
    last_of_month  = "'#{year}-#{month}-31'"
    EventEntry.find(:all, :order => 'start_date ASC', 
      :conditions => "(start_date >= #{first_of_month} AND start_date <= #{last_of_month}) OR " +
                     "(end_date >= #{first_of_month} AND end_date <= #{last_of_month}) "
                     #  Line below commented out because all current events that last longer
                     #   than a month are actually misclassified jams
                     # "(start_date < #{first_of_month} AND end_date > #{last_of_month})" 
    )
  end


  def before_save
    if self.start_date > self.end_date
      self.start_date, self.end_date = self.end_date, self.start_date
    end
    sanitize_attributes
  end

  def sortable_title
    title
  end

  def version_condition_met?
    title_changed? || description_changed? || cost_changed? || start_date_changed? || end_date_changed? || ci_notes_changed?
  end

end
