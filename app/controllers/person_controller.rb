class PersonController < ApplicationController

  include EntryFormWithOptionalModels

  auto_complete_with_params_prefix_for :country_name, :english_name
  auto_complete_with_params_prefix_for :us_state, :name

  before_filter :login_required, :only => [:create, :edit, :new]

  skip_before_filter :verify_authenticity_token, 
    :only => ['auto_complete_for_country_name_english_name', 'auto_complete_for_us_state_name']


protected

  def entry_class
    PersonEntry
  end

  def entry_display_name
    'Person'
  end

  def mandatory_models
    ['person', 'location']
  end

  def optional_models
    ['email', 'phone_number', 'url']
  end

  def initialize_entry_and_linked_models_from_params(p)
    @entry.attributes = p[:person_entry]
    @entry.person.attributes       = p[:person][:person]
    @entry.email.attributes        = p[:person][:email]
    @entry.location.attributes     = p[:person][:location]
    @entry.phone_number.attributes = p[:person][:phone_number]
    @entry.url.attributes          = p[:person][:ci_url]
  end

end
