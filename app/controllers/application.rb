# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # Be sure to include AuthenticationSystem [sic] in Application Controller instead
  include AuthenticatedSystem

  # Send an email when an unhandled exception occurs
  include ExceptionNotifiable

  include AutoCompleteWithParamsPrefix

  include SslRequirement

  #  Allow SSL to be used on all pages.  Prevents an https -> http -> https redirection
  #   loop when using mod_rewrite in Apache to force an https connection.
  def ssl_allowed?
    true
  end

  # [CTH]  We use :logged_in? as a before_filter in order to check if a user is logged in,
  #        and :login_required to force a user to log in.  This is useful if we want to
  #        display a user's current login status without redirecting them to a login page.
  before_filter :logged_in?


  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => 'www.contactimprov.net'


  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'c8e85940919a6ceaff914a3afcaedd25'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  
  def cache_entries_for_countries(entry_class)
    entry_type = entry_class.to_s.gsub(/(.*)Entry/, '\1').downcase
    @country_names_with_entries ||= Hash.new
    @us_state_names_with_entries ||= Hash.new
    @us_state_abbreviations_with_entries ||= Hash.new
    @entry_ids_for_country ||= Hash.new
    @entry_ids_for_us_state ||= Hash.new
    @entry_ids_for_country[entry_type] ||= Hash.new
    @entry_ids_for_us_state[entry_type] ||= Hash.new
    
    @country_names_with_entries[entry_type] = cache("all_countries_with_#{entry_type}_entries") do 
      find_all_countries_with_entries(entry_type).collect { |c| c.english_name } 
    end
    @country_names_with_entries[entry_type].each do |country_name|
      @entry_ids_for_country[entry_type][country_name] = cache(cache_safe_name("all_#{entry_type}_entries_for_countries", country_name)) do
        find_all_entries_for_country_by_name(entry_class, entry_type, country_name).sort { 
          |a,b| a.sortable_title <=> b.sortable_title 
        }.collect { |e| e.id }
      end
    end

    @us_state_names_with_entries[entry_type] = cache("all_us_states_with_#{entry_type}_entries") do 
      find_all_us_states_with_entries(entry_type).collect { |s| s.name } 
    end
    @us_state_names_with_entries[entry_type].each do |us_state_name|
      @entry_ids_for_us_state[entry_type][us_state_name] = cache(cache_safe_name("all_#{entry_type}_entries_for_us_state", us_state_name)) do
        find_all_entries_for_us_state_by_name(entry_class, entry_type, us_state_name).sort { 
          |a,b| a.sortable_title <=> b.sortable_title 
        }.collect { |e| e.id }
      end
    end
    
    @us_state_abbreviations_with_entries[entry_type] = cache("all_us_state_abbreviations_with_#{entry_type}_entries") do 
      find_all_us_states_with_entries(entry_type).collect { |s| s.abbreviation } 
    end
  end

  def cache_safe_name(prefix, suffix)
    "#{prefix}_#{suffix}".gsub(' ', '_').gsub(/[\(\)\.',]/, "")
  end

  def current_user_can_modify_entry?(entry)
    return false if !@current_user
    return true if @current_user.admin?
    return @current_user == entry.owner_user && entry.owner_user != nil
  end

  def find_all_countries_with_entries(entry_type)
    CountryName.find_by_sql("SELECT DISTINCT ci_country_names.english_name " + 
      "FROM ci_#{entry_type}_entries, ci_locations, ci_country_names " + 
      "WHERE ci_country_names.country_name_id = ci_locations.country_name_id " + 
      "AND ci_#{entry_type}_entries.location_id = ci_locations.location_id " + 
      "ORDER BY ci_country_names.english_name;")
  end

  def find_all_entries_for_country_by_name(entry_class, entry_type, country_name)
    entry_class.find_by_sql("SELECT ci_#{entry_type}_entries.* " + 
      "FROM ci_#{entry_type}_entries, ci_locations, ci_country_names " + 
      "WHERE ci_#{entry_type}_entries.location_id = ci_locations.location_id " + 
      "AND ci_locations.country_name_id = ci_country_names.country_name_id " + 
      "AND ci_country_names.english_name = '#{country_name}';")
  end

  def find_all_entries_for_us_state_by_name(entry_class, entry_type, us_state_name)
    entry_class.find_by_sql("SELECT ci_#{entry_type}_entries.* " + 
      "FROM ci_#{entry_type}_entries, ci_locations, ci_us_states " + 
      "WHERE ci_#{entry_type}_entries.location_id = ci_locations.location_id " + 
      "AND ci_locations.us_state_id = ci_us_states.us_state_id " + 
      "AND ci_us_states.name = '#{us_state_name}';")
  end

  def find_all_us_states_with_entries(entry_type)
    UsState.find_by_sql("SELECT DISTINCT ci_us_states.name, ci_us_states.abbreviation " + 
      "FROM ci_#{entry_type}_entries, ci_locations, ci_us_states " + 
      "WHERE ci_us_states.us_state_id = ci_locations.us_state_id " + 
      "AND ci_#{entry_type}_entries.location_id = ci_locations.location_id " + 
      "ORDER BY ci_us_states.name;")
  end

  def flush_location_cache(display_name, location)
    entry_type = display_name.singularize.downcase
    if location.country_name.is_usa?
      cache_store.delete("controller/all_us_states_with_#{entry_type}_entries")
      cache_store.delete("controller/all_us_state_abbreviations_with_#{entry_type}_entries")
      cache_store.delete(cache_safe_name("controller/all_#{entry_type}_entries_for_us_state", location.us_state.name))
      expire_fragment(:controller => entry_type.pluralize, :action => entry_type, :action_suffix => location.us_state.name)
    else
      cache_store.delete("controller/all_countries_with_#{entry_type}_entries")
      cache_store.delete(cache_safe_name("controller/all_#{entry_type}_entries_for_countries", location.country_name.english_name))
      expire_fragment(:controller => entry_type.pluralize, :action => entry_type, :action_suffix => location.country_name.english_name)
    end
  end

end
