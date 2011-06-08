xml.instruct!
xml.listings do
  @entries.each do |entry|
    xml.listing do
      xml.title entry.title
      xml.url entry.url.address if entry.url
      xml.latitude  entry.location.lat
      xml.longitude entry.location.lng
    end
  end
end
