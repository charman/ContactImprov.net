class MapController < ApplicationController

  def all
    @marker_info = Hash.new
    @entry_category = 'all'

    add_marker_info_for_entry_class(@marker_info, EventEntry)
    add_marker_info_for_entry_class(@marker_info, JamEntry)
    add_marker_info_for_entry_class(@marker_info, OrganizationEntry)
    add_marker_info_for_entry_class(@marker_info, PersonEntry)
    
    respond_to do |format|
      format.html { render :action => 'index' }
      format.json { render :layout => false, :json => @marker_info }
    end
  end

  def events
    @marker_info = Hash.new
    @entry_category = 'events'

    add_marker_info_for_entry_class(@marker_info, EventEntry)
    
    respond_to do |format|
      format.html { render :action => 'index' }
      format.json { render :layout => false, :json => @marker_info }
    end
  end

  def index
    @marker_info = Hash.new
    @entry_category = 'all'

    add_marker_info_for_entry_class(@marker_info, EventEntry)
    add_marker_info_for_entry_class(@marker_info, JamEntry)
    add_marker_info_for_entry_class(@marker_info, OrganizationEntry)
    add_marker_info_for_entry_class(@marker_info, PersonEntry)
    
    respond_to do |format|
      format.html  # index.rhtml
      format.json { render :layout => false, :json => @marker_info }
    end
  end

  def jams
    @marker_info = Hash.new
    @entry_category = 'jams'

    add_marker_info_for_entry_class(@marker_info, JamEntry)
    
    respond_to do |format|
      format.html { render :action => 'index' }
      format.json { render :layout => false, :json => @marker_info }
    end
  end

  def people
    @marker_info = Hash.new
    @entry_category = 'people'

    add_marker_info_for_entry_class(@marker_info, PersonEntry)
    
    respond_to do |format|
      format.html { render :action => 'index' }
      format.json { render :layout => false, :json => @marker_info }
    end
  end

  def organizations
    @marker_info = Hash.new
    @entry_category = 'organizations'

    add_marker_info_for_entry_class(@marker_info, OrganizationEntry)
    
    respond_to do |format|
      format.html { render :action => 'index' }
      format.json { render :layout => false, :json => @marker_info }
    end
  end


protected

  def add_marker_info_for_entry_class(marker_info, entry_class)
    entries = entry_class.find_geocoded_entries

    entries.each do |entry|
      coordinate_string = "#{entry.location.lat}|#{entry.location.lng}"
      marker_info[coordinate_string] ||= Array.new
      marker_info[coordinate_string] << marker_info_for_entry(entry)
    end
  end

  def escape_quotes(s)
    s.gsub(/\'/, '\\\'')
  end

  def marker_info_for_entry(entry)
    marker_info = Hash.new
    marker_info['entry_class'] = entry.class.to_s.sub(/Entry/,'')
    marker_info['mouseover_text'] = escape_quotes(HTMLEntities.new.decode(entry.title))
    marker_info['infowindow_html'] = escape_quotes(infowindow_for_entry(entry))
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
      "<div style=\"color: #444; margin-left: 0.5em;\">#{event.location.city_state_country}</div>" +
      (event.url ? "<div style=\"font-size: 0.9em; margin-left: 0.5em;\"><a href=\"#{event.url.address}\">#{event.url.address}</a></div>" : '')
  end

  def infowindow_for_jam(jam)
    "<div style=\"font-size: 1.1em; font-weight: bold;\">" + 
      "<a href=\"/jams/show/#{jam.id}\">#{jam.title}</a></div>" +
      "<div style=\"color: #444; margin-left: 0.5em;\">#{jam.location.city_state_country}</div>" +
      (jam.url ? "<div style=\"font-size: 0.9em; margin-left: 0.5em;\"><a href=\"#{jam.url.address}\">#{jam.url.address}</a></div>" : '')
  end

  def infowindow_for_organization(organization)
    "<div style=\"font-size: 1.1em; font-weight: bold;\">" + 
      "<a href=\"/organizations/show/#{organization.id}\">#{organization.title}</a></div>" +
      "<div style=\"color: #444; margin-left: 0.5em;\">#{organization.location.city_state_country}</div>" +
      (organization.url ? "<div style=\"font-size: 0.9em; margin-left: 0.5em;\"><a href=\"#{organization.url.address}\">#{organization.url.address}</a></div>" : '')
  end

  def infowindow_for_person(person)
    "<div style=\"font-size: 1.1em; font-weight: bold;\">" + 
      "<a href=\"/people/show/#{person.id}\">#{person.title}</a></div>" +
      "<div style=\"color: #444; margin-left: 0.5em;\">#{person.location.city_state_country}</div>" +
      (person.url ? "<div style=\"font-size: 0.9em; margin-left: 0.5em;\"><a href=\"#{person.url.address}\">#{person.url.address}</a></div>" : '')
  end

end
