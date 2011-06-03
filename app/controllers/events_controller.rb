class EventsController < ApplicationController

  include EntryFormWithOptionalModels

  before_filter :login_required, :only => [:create, :delete, :edit, :new]


  def calendar
    country_name = CountryName.find_by_underlined_english_name(params[:country_name])
    us_state     = UsState.find_by_underlined_name(params[:us_state])

    if us_state
      events = EventEntry.find_future_by_us_state(us_state)
    elsif country_name
      events = EventEntry.find_future_by_country_name(country_name)
    else
      events = EventEntry.find(:all, :conditions => "end_date > CURRENT_DATE()")
    end

    cal = Icalendar::Calendar.new

    events.each do |event|
      cal.add_event(event.to_ical_event)
    end

    render :text => cal.to_ical
  end

  def index
    @entries = EventEntry.find(:all, :order => 'start_date ASC', :conditions => 'end_date > CURRENT_DATE()')

    @entries_by_year_month = Hash.new
    EventEntry.distinct_nonpast_years.each do |y| 
      @entries_by_year_month[y] = Hash.new
      EventEntry.distinct_nonpast_months(y).each { |m| @entries_by_year_month[y][m] = EventEntry.find_by_start_date_year_month(y, m) }
    end
  end

  def list
    year = params[:year]
    month = params[:month]

    #  If we are listing events for a specific year and month, then we show events whose start date
    #   OR end date is in that month [using EventEntry.find_by_year_month()];
    #  Otherwise, when displaying multiple months, for a given month we only list events whose start
    #   date is in that month [using EventEntry.find_by_start_date_year_month()].  This prevents an
    #   event that spans two months from being listed twice.
    if year and month
      @entries_by_year_month = { year => { month => EventEntry.find_by_year_month(year, month) } }
      @entries = EventEntry.find_by_year_month(year, month)
    elsif year
      @entries_by_year_month = Hash.new
      @entries_by_year_month[year] = Hash.new
      EventEntry.distinct_months(year).each { |m| @entries_by_year_month[year][m] = EventEntry.find_by_start_date_year_month(year, m) }
      @entries = EventEntry.find_by_year(year)
    else
      @entries_by_year_month = Hash.new
      EventEntry.distinct_years.each do |y| 
        @entries_by_year_month[y] = Hash.new
        EventEntry.distinct_months(y).each { |m| @entries_by_year_month[y][m] = EventEntry.find_by_start_date_year_month(y, m) }
      end
      @entries = EventEntry.find(:all, :order => 'start_date ASC', :conditions =>  'end_date > CURRENT_DATE()')
    end
  end

protected

  def category_name_plural
    'Special Events'
  end

  def category_name_singular
    'Special Event'
  end

  def category_title
    "#{category_name_plural} &mdash; "
  end
  
  def category_subtitle
    "conferences, festivals, regional jams and workshops"
  end
  
  def entry_class
    EventEntry
  end
  
  def entry_display_name
    'Event'
  end

  def mandatory_models
    ['location']
  end
  
  def optional_models
    ['email', 'person', 'phone_number', 'url']
  end

end
