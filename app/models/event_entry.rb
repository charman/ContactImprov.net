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

  before_save :move_start_date_before_end_date!, :sanitize_attributes!

  validates_presence_of :title, :description, :start_date, :end_date


  def self.distinct_months(year)
    EventEntry.find_by_sql(["SELECT DISTINCT DATE_FORMAT(start_date, '%Y') " + 
      "AS year, DATE_FORMAT(start_date, '%m') AS month FROM ci_event_entries " + 
      "WHERE DATE_FORMAT(start_date, '%Y') = ? ORDER BY year, month;", year]).collect { |e| e.month }
  end

  def self.distinct_nonpast_months(year)
    EventEntry.find_by_sql(["SELECT DISTINCT DATE_FORMAT(start_date, '%Y') AS year, " + 
      "DATE_FORMAT(start_date, '%m') AS month FROM ci_event_entries " + 
      "WHERE DATE_FORMAT(start_date, '%Y') = ? " + 
      "AND start_date >= ? " +
      "ORDER BY year, month;", 
      year, Date.today.strftime('%Y-%m-01')]).collect { |e| e.month }
  end

  def self.distinct_years
    EventEntry.find_by_sql("SELECT DISTINCT DATE_FORMAT(start_date, '%Y') " + 
      "AS year FROM ci_event_entries ORDER BY year;").collect { |e| e.year }
  end

  def self.distinct_nonpast_years
    EventEntry.find_by_sql(["SELECT DISTINCT DATE_FORMAT(start_date, '%Y') AS year " + 
      "FROM ci_event_entries WHERE start_date > ? " +
      "ORDER BY year;", Date.today.strftime('%Y-01-01')]).collect { |e| e.year }
  end

  def self.find_by_year(year, by_start_date_only = false)
    first_of_year = "#{year}-01-01"
    last_of_year  = "#{year}-12-31"
    if by_start_date_only
      @entries = EventEntry.find(:all, :order => 'start_date ASC',
        :conditions => ["start_date >= ? AND start_date <= ?", first_of_year, last_of_year]
      )
    else
      @entries = EventEntry.find(:all, :order => 'start_date ASC',
        :conditions => ["(start_date >= ? AND start_date <= ?) OR (end_date >= ? AND end_date <= ?)", 
          first_of_year, last_of_year, first_of_year, last_of_year]
      )
    end
  end
  
  def self.find_by_start_date_year(year)
    self.find_by_year(year, true)
  end
  
  def self.find_by_year_month(year, month, by_start_date_only = false)
    first_of_month = "#{year}-#{month}-01"
    last_of_month  = "#{year}-#{month}-31"
    if by_start_date_only
      @entries = EventEntry.find(:all, :order => 'start_date ASC',
        :conditions => ["start_date >= ? AND start_date <= ?", first_of_month, last_of_month]
      )
    else
      @entries = EventEntry.find(:all, :order => 'start_date ASC',
        :conditions => ["(start_date >= ? AND start_date <= ?) OR (end_date >= ? AND end_date <= ?)", 
          first_of_month, last_of_month, first_of_month, last_of_month]
      )
    end
  end

  def self.find_by_start_date_year_month(year, month)
    self.find_by_year_month(year, month, true)
  end

  def self.find_future
    self.find(:all, :order => 'start_date ASC', :conditions => 'end_date > CURRENT_DATE()')
  end

  def self.find_future_by_country_name(country_name)
    self.find(:all,
      :from => "ci_event_entries, ci_locations",
      :conditions => ["end_date > CURRENT_DATE() " +
                      "AND ci_event_entries.location_id = ci_locations.location_id " + 
                      "AND country_name_id = ?", country_name.id]
    )
  end

  def self.find_future_by_us_state(us_state)
    self.find(:all,
      :from => "ci_event_entries, ci_locations",
      :conditions => ["end_date > CURRENT_DATE() " +
                      "AND ci_event_entries.location_id = ci_locations.location_id " + 
                      "AND us_state_id = ?", us_state.id]
    )
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

  def move_start_date_before_end_date!
    if self.start_date > self.end_date
      self.start_date, self.end_date = self.end_date, self.start_date
    end
  end

  def to_ical_event
    decoder = HTMLEntities.new
    
    event = Icalendar::Event.new
    event.start   = self.start_date
    event.end     = self.end_date
    event.summary = decoder.decode(self.title)
    if self.location.geocode_precision
      geo = Icalendar::Geo.new(self.location.lat, self.location.lng)
      event.geo = geo
      event.geo_location = geo
    end
    event.location = decoder.decode(self.location.full_address_one_line)
    if self.url && !self.url.address.empty?
      event.url = self.url.address 
    else
      #  TODO: Replace this with a function that generates the correct URL, instead of having it hard-coded
      event.url = "http://www.contactimprov.net/events/show/#{self.id}"
    end

    event
  end

  def sortable_title
    title
  end

  def version_condition_met?
    title_changed? || description_changed? || cost_changed? || start_date_changed? || end_date_changed? || ci_notes_changed?
  end

end
