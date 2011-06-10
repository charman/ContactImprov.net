xml.instruct!
xml.listings do
  @entries.each do |entry|
    xml.listing do
      xml.title entry.title
      xml.description entry.description
      xml.url preferred_url_for_entry(entry)
      xml.latitude  entry.location.lat
      xml.longitude entry.location.lng
    end
  end
end
