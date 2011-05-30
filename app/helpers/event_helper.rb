module EventHelper

  def add_to_google_calendar_button(e)
    #  For information about the parameters to use, see:
    #    http://www.google.com/googlecalendar/event_publisher_guide_detail.html
    '<a href="http://www.google.com/calendar/event?action=TEMPLATE' + 
      '&text=' + url_escape(e.title) + 
      '&dates=' + event_dates_formatted_for_google_calendar(e) + 
      '&details=' + description_formatted_for_google_calendar(e) +  
      '&location=' + url_escape(e.location.full_address_one_line) + 
      '&trp=false' +
      #  Google Calendar doesn't seem to be doing anything with the sprop arguments
      '&sprop=website:' + preferred_url(e) + 
      '&sprop=name:ContactImprov.net" target="_blank">' + 
      '<img src="http://www.google.com/calendar/images/ext/gc_button6.gif" border=0></a>'
  end

  def description_formatted_for_google_calendar(e)
    #  We truncate the description to prevent Google from raising an error about URL length
    s = url_escape(e.description[0,700])
    s += '...%0D%0A%0D%0AFor more info see:' if e.description.size >= 700
    s += '%0D%0A' + preferred_url(e)
    s
  end

  def event_dates_formatted_for_google_calendar(e)
    "#{e.start_date.strftime('%Y%m%d')}/#{e.end_date.strftime('%Y%m%d')}"
  end

  def format_contact_info(e)
    a = Array.new
    if e.respond_to?('person') && e.person
      a << "#{e.person.first_name} #{e.person.last_name}" 
    end
    a << e.phone_number.number if (e.phone_number && !e.phone_number.number.blank?)
    a << obfuscate_email_with_javascript(e.email.address) if (e.email && !e.email.address.blank?)
    a << link_to(e.url.address, e.url.address) if (e.url && !e.url.address.blank?)
    a.join(", ")
  end

  def format_entry_location(e)
    e.location.city_state_country
  end

  #  Return the Event's website if available; otherwise return contactimprov.net URL
  def preferred_url(e)
    if !e.url.blank?
      url_escape(e.url.address)
    else
      "http://contactimprov.net/events/view/#{e.id}"
    end
  end

  #  This function ganked from:  http://railsruby.blogspot.com/2006/07/url-escape-and-url-unescape.html
  def url_escape(string)
    return '' if string.blank?

    string.gsub(/([^ a-zA-Z0-9_.-]+)/n) do
      '%' + $1.unpack('H2' * $1.size).join('%').upcase
    end.tr(' ', '+')
  end

end
