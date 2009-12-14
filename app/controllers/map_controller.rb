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
    marker_info['class'] = entry.class.to_s
    marker_info['mouseover_text'] = entry.title
    marker_info['infowindow_html'] = infowindow_for_entry(entry)
    marker_info
  end

  def infowindow_for_entry(entry)
    case entry.class.to_s
    when "EventEntry"
      infowindow_for_event(entry)
    when "JamEntry"
      infowindow_for_jam(entry)
    when "OrganizationEntry"
      infowindow_for_organization(entry)
    when "PersonEntry"
      infowindow_for_person(entry)
    end
  end

  def infowindow_for_event(event)
    "<div style=\"font-size: 1.1em; font-weight: bold;\">" + 
      "<a href=\"/events/show/#{event.id}\">#{event.title}</a></div>" +
      "<div>#{format_event_date_range(event)}</div> " +
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


  ## TODO: Copied from helpers/event_helper.rb; refactor to avoid code duplication
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

end
