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
      a << "<span itemprop=\"name\"#{e.person.first_name} #{e.person.last_name}</span>" 
    end
    if (e.phone_number && !e.phone_number.number.blank?)
      a << "<span itemprop=\"telephone\">#{e.phone_number.number}</span>"
    end
    if (e.email && !e.email.address.blank?)
      #  TODO: Is there a safe way to use microdata for an unobfuscated email address?
#      a << "<span itemprop=\"email\">#{obfuscate_email_with_javascript(e.email.address)}</span>" 
      a << obfuscate_email_with_javascript(e.email.address)
    end
    if (e.url && !e.url.address.blank?)
      a << "<a href=\"#{e.url.address}\" itemprop=\"url\">#{e.url.address}</a>"
    end
    '<span itemscope itemtype="http://schema.org/ContactPoint">' + a.join(", ") + '</span>'
  end

  def format_entry_location(e)
    e.location.city_state_country
  end

  def postal_address_microdata_for_location(l, itemprop_name)
    fa = Array.new

    if !l.street_address_line_1.blank?
      if !l.street_address_line_2.blank?
        fa << "<span itemprop=\"streetAddress\">#{l.street_address_line_1}, #{l.street_address_line_2}</span>"
      else
        fa << "<span itemprop=\"streetAddress\">#{l.street_address_line_1}</span>"
      end
    end
    if !l.city_name.blank?
      fa << "<span itemprop=\"addressLocality\">#{l.city_name}</span>"
    end
    if l.is_in_usa?
      fa << "<span itemprop=\"addressRegion\">#{l.us_state.abbreviation} </span> <span itemprop=\"postalCode\">#{l.postal_code}</span> USA"
    else
      if !l.region_name.blank?
        fa << "<span itemprop=\"addressRegion\">#{l.region_name}</span> <span itemprop=\"postalCode\">#{l.postal_code}</span>"
      else
        fa << "<span itemprop=\"postalCode\">#{l.postal_code.strip}</span>" if !l.postal_code.blank?
      end
      fa << l.country_name.english_name
    end
    "<span itemprop=\"#{itemprop_name}\" itemscope itemtype=\"http://schema.org/PostalAddress\">" + fa.join(', ') + 
      "<meta itemprop=\"country\" content=\"#{l.country_name.iso_3166_1_a2_code}\" />" +
      '</span>'
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
