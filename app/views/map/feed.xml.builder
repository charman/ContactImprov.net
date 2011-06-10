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
        xml.description entry.description
        xml.url preferred_url_for_entry(entry)
        xml.address entry.location.geocodable_part_of_address
        xml.latitude  entry.location.lat
        xml.longitude entry.location.lng
        xml.listing_type entry.class.to_s
      end
    end
  end

end
