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

  def format_entry_location(e)
    s = e.location.city_state_country
    s += ', USA' if e.location.is_in_usa?
    s
  end

end
