class EventsController < ApplicationController

  include EntryFormWithOptionalModels

  before_filter :login_required, :only => [:create, :delete, :edit, :new]
  cache_sweeper :event_entry_sweeper
  

  def index
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
      @entries = EventEntry.find_by_year_month(year, month)
      @entries_by_year_month = { year => { month => @entries } }
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
      @entries = EventEntry.find_future
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
