cache "map_feed_#{@entry_category}" do

  #  We're querying the database from the view instead of the controller to
  #   take advantage of caching.  There's probably a better way to do this...
  case @entry_category
  when 'events'
    entries = EventEntry.find_geocoded_entries
  when 'jams'
    entries = JamEntry.find_geocoded_entries
  when 'people'
    entries = PersonEntry.find_geocoded_entries
  when 'organizations'
    entries = OrganizationEntry.find_geocoded_entries
  when 'combined' 
    entries = EventEntry.find_geocoded_entries +
      JamEntry.find_geocoded_entries +
      PersonEntry.find_geocoded_entries +
      OrganizationEntry.find_geocoded_entries
  end

  xml.instruct!
  xml.listings do
    entries.each do |entry|
      xml.listing do
        xml.title entry.title
        xml.url preferred_url_for_entry(entry)
        xml.address entry.location.geocodable_part_of_address_array.join('<br />')
        xml.postalAddress do
          xml.streetAddress   entry.location.street_address_line_1     if entry.location.geocodable_street_address?
          xml.addressLocality entry.location.city_name                 if entry.location.geocodable_city?
          xml.addressRegion   entry.location.state_abbreviation_or_region_name
          xml.postalCode      entry.location.postal_code               if !entry.location.postal_code.blank?
          xml.addressCountry  entry.location.country_name.english_name
        end
        xml.latitude  entry.location.lat
        xml.longitude entry.location.lng
        xml.listing_type entry.class.to_s.gsub('Entry', '').downcase
      end
    end
  end

end
