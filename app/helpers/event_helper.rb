module EventHelper

  def format_contact_info(e)
    a = Array.new
    if e.respond_to?('person') && e.person
      a << "#{e.person.first_name} #{e.person.last_name}" 
    end
    a << e.phone_number.number if (e.phone_number && !e.phone_number.number.blank?)
    a << obfuscate_email_with_javascript(e.email.address) if (e.email && !e.email.address.blank?)
    a << "<a href=\"#{e.url.address}\">#{e.url.address}</a>" if (e.url && !e.url.address.blank?)
    a.join(", ")
  end

  def format_event_date_range(e)
    #  lemma: e.start_date <= e.end_date because of EventEntry.before_save
    if e.start_date.year != e.end_date.year
      "#{e.start_date.strftime('%b %e, %Y')} - #{e.end_date.strftime('%b %e, %Y')}"
    elsif e.start_date.month != e.end_date.month
      "#{e.start_date.strftime('%b %e')} - #{e.end_date.strftime('%b %e, %Y')}"
    elsif e.start_date.day != e.end_date.day
      "#{e.start_date.strftime('%b %e')} - #{e.end_date.strftime('%e, %Y')}"
    else
      e.start_date.strftime('%b %e, %Y')
    end
  end

  def format_event_date_range_without_year(e)
    #  lemma: e.start_date <= e.end_date because of EventEntry.before_save
    if e.start_date.month != e.end_date.month
      "#{e.start_date.strftime('%b %e')} - #{e.end_date.strftime('%b %e')}"
    elsif e.start_date.day != e.end_date.day
      "#{e.start_date.strftime('%b %e')} - #{e.end_date.strftime('%e')}"
    else
      e.start_date.strftime('%b %e')
    end
  end

  def format_entry_location(e)
    if e.location.is_in_usa?
      "#{e.location.city_name}, #{e.location.us_state.abbreviation}, USA"
    else
      if e.location.region_name.blank?
        "#{e.location.city_name}, #{e.location.country_name.english_name}"
      else
        "#{e.location.city_name}, #{e.location.region_name}, #{e.location.country_name.english_name}"
      end
    end
  end

end
