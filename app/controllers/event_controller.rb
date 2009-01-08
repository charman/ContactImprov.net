class EventController < ApplicationController

  include EntryFormWithOptionalModels

  auto_complete_with_params_prefix_for :country_name, :english_name
  auto_complete_with_params_prefix_for :us_state, :name

  before_filter :login_required, :only => [:create, :edit, :new]

  skip_before_filter :verify_authenticity_token, 
    :only => ['auto_complete_for_country_name_english_name', 'auto_complete_for_us_state_name']


protected

  def entry_class
    EventEntry
  end
  
  def mandatory_models
    ['location']
  end
  
  def optional_models
    ['email', 'person', 'phone_number', 'url']
  end

  def initialize_entry_and_linked_models_from_params(p)
    @entry.attributes = p[:event_entry]
    @entry.person.attributes       = p[:event][:person]
    @entry.email.attributes        = p[:event][:email]
    @entry.location.attributes     = p[:event][:location]
    @entry.phone_number.attributes = p[:event][:phone_number]
    @entry.url.attributes          = p[:event][:ci_url]
  end

end
