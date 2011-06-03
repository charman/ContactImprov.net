class CalendarsController < ApplicationController

  def feed
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
    cache_entries_for_countries(EventEntry)
  end

end
