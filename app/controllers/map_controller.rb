class MapController < ApplicationController

  def index
    @marker_info = Hash.new

    add_marker_info_for_entry_class(@marker_info, EventEntry)
    add_marker_info_for_entry_class(@marker_info, JamEntry)
    add_marker_info_for_entry_class(@marker_info, OrganizationEntry)
    add_marker_info_for_entry_class(@marker_info, PersonEntry)
  end


protected

  def add_marker_info_for_entry_class(marker_info, entry_class)
    entries = entry_class.find_geocoded_entries

    entries.each do |entry|
      marker_info[[entry.location.lat, entry.location.lng]] ||= Array.new
      marker_info[[entry.location.lat, entry.location.lng]] << marker_info_for_entry(entry)
    end
  end

  def marker_info_for_entry(entry)
    marker_info = Hash.new
    marker_info['entry_class'] = entry.class.to_s.sub(/Entry/,'')
    marker_info['mouseover_text'] = HTMLEntities.new.decode(entry.title).gsub(/\"/, '\"')
    marker_info['infowindow_html'] = infowindow_for_entry(entry).gsub(/\"/, '\"')
    marker_info
  end

  def infowindow_for_entry(entry)
    case entry.class.to_s
    when /Event/
      infowindow_for_event(entry)
    when /Jam/
      infowindow_for_jam(entry)
    when /Organization/
      infowindow_for_organization(entry)
    when /Person/
      infowindow_for_person(entry)
    end
  end

  def infowindow_for_event(event)
    "<div style=\"font-size: 1.1em; font-weight: bold;\">" + 
      "<a href=\"/events/show/#{event.id}\">#{event.title}</a></div>" +
      "<div>#{event.date_range}</div> " +
      (event.url ? "<div style=\"font-size: 0.9em;\"><a href=\"#{event.url.address}\">#{event.url.address}</a></div>" : '')
  end

  def infowindow_for_jam(jam)
    "<div style=\"font-size: 1.1em; font-weight: bold;\">" + 
      "<a href=\"/jams/show/#{jam.id}\">#{jam.title}</a></div>" +
      (jam.url ? "<div style=\"font-size: 0.9em;\"><a href=\"#{jam.url.address}\">#{jam.url.address}</a></div>" : '')
  end

  def infowindow_for_organization(organization)
    "<div style=\"font-size: 1.1em; font-weight: bold;\">" + 
      "<a href=\"/organizations/show/#{organization.id}\">#{organization.title}</a></div>" +
      (organization.url ? "<div style=\"font-size: 0.9em;\"><a href=\"#{organization.url.address}\">#{organization.url.address}</a></div>" : '')
  end

  def infowindow_for_person(person)
    "<div style=\"font-size: 1.1em; font-weight: bold;\">" + 
      "<a href=\"/people/show/#{person.id}\">#{person.title}</a></div>" +
      (person.url ? "<div style=\"font-size: 0.9em;\"><a href=\"#{person.url.address}\">#{person.url.address}</a></div>" : '')
  end

end
