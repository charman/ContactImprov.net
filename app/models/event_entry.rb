class EventEntry < ActiveRecord::Base
  include AccessibleAttributeEncoding

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


  def self.distinct_months(year)
    EventEntry.find_by_sql("SELECT DISTINCT DATE_FORMAT(start_date, '%Y') " + 
      "AS year, DATE_FORMAT(start_date, '%m') AS month FROM ci_event_entries " + 
      "WHERE DATE_FORMAT(start_date, '%Y') = '#{year}' ORDER BY year, month;").collect { |e| e.month }
  end

  def self.distinct_nonpast_months(year)
    EventEntry.find_by_sql("SELECT DISTINCT DATE_FORMAT(start_date, '%Y') AS year, " + 
      "DATE_FORMAT(start_date, '%m') AS month FROM ci_event_entries " + 
      "WHERE DATE_FORMAT(start_date, '%Y') = '#{year}' " + 
      "AND start_date >= '#{Date.today.strftime('%Y-%m-01')}' " +
      "ORDER BY year, month;").collect { |e| e.month }
  end

  def self.distinct_years
    EventEntry.find_by_sql("SELECT DISTINCT DATE_FORMAT(start_date, '%Y') " + 
      "AS year FROM ci_event_entries ORDER BY year;").collect { |e| e.year }
  end

  def self.distinct_nonpast_years
    EventEntry.find_by_sql("SELECT DISTINCT DATE_FORMAT(start_date, '%Y') AS year " + 
      "FROM ci_event_entries WHERE start_date > '#{Date.today.strftime('%Y')}-01-01' " +
      "ORDER BY year;").collect { |e| e.year }
  end

  def self.find_by_year(year, by_start_date_only = false)
    first_of_year = "'#{year}-01-01'"
    last_of_year  = "'#{year}-12-31'"
    @entries = EventEntry.find(:all, :order => 'start_date ASC',
      :conditions => "(start_date >= #{first_of_year} AND start_date <= #{last_of_year}) " +
                     (by_start_date_only ? '' : "OR (end_date >= #{first_of_year} AND end_date <= #{last_of_year})")
    )
  end
  
  def self.find_by_start_date_year(year)
    self.find_by_year(year, true)
  end
  
  def self.find_by_year_month(year, month, by_start_date_only = false)
    first_of_month = "'#{year}-#{month}-01'"
    last_of_month  = "'#{year}-#{month}-31'"
    EventEntry.find(:all, :order => 'start_date ASC', 
      :conditions => "(start_date >= #{first_of_month} AND start_date <= #{last_of_month}) " +
                     (by_start_date_only ? '' : "OR (end_date >= #{first_of_month} AND end_date <= #{last_of_month}) ")
                     #  Line below commented out because all current events that last longer
                     #   than a month are actually misclassified jams
                     # "(start_date < #{first_of_month} AND end_date > #{last_of_month})" 
    )
  end

  def self.find_by_start_date_year_month(year, month)
    self.find_by_year_month(year, month, true)
  end

  def self.find_future_geocoded_entries
    self.find(:all,
      :from => "ci_event_entries, ci_locations",
      :conditions => "end_date > CURRENT_DATE() " +
                     "AND ci_event_entries.location_id = ci_locations.location_id " + 
                     "AND geocode_precision IS NOT NULL"
    )
  end

  def self.find_geocoded_entries
    self.find_future_geocoded_entries
  end


  def before_save
    if self.start_date > self.end_date
      self.start_date, self.end_date = self.end_date, self.start_date
    end
    sanitize_attributes!
  end

  def date_range
    #  lemma: start_date <= end_date because of EventEntry.before_save
    if self.start_date.year != self.end_date.year
      "#{self.start_date.strftime('%b %e, %Y')} - #{self.end_date.strftime('%b %e, %Y')}"
    elsif self.start_date.month != self.end_date.month
      "#{self.start_date.strftime('%b %e')} - #{self.end_date.strftime('%b %e, %Y')}"
    elsif self.start_date.day != self.end_date.day
      "#{self.start_date.strftime('%b %e')} - #{self.end_date.strftime('%e, %Y')}"
    else
      self.start_date.strftime('%b %e, %Y')
    end
  end

  def date_range_without_year
    #  lemma: start_date <= end_date because of EventEntry.before_save
    if self.start_date.month != self.end_date.month
      "#{self.start_date.strftime('%b %e')} - #{self.end_date.strftime('%b %e')}"
    elsif self.start_date.day != self.end_date.day
      "#{self.start_date.strftime('%b %e')} - #{self.end_date.strftime('%e')}"
    else
      self.start_date.strftime('%b %e')
    end
  end

  def sortable_title
    title
  end

  def version_condition_met?
    title_changed? || description_changed? || cost_changed? || start_date_changed? || end_date_changed? || ci_notes_changed?
  end

end
