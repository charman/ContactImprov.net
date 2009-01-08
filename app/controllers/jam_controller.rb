class JamController < ApplicationController

    include EntryFormWithOptionalModels

    auto_complete_with_params_prefix_for :country_name, :english_name
    auto_complete_with_params_prefix_for :us_state, :name

    before_filter :login_required, :only => [:create, :edit, :new]

    skip_before_filter :verify_authenticity_token, 
      :only => ['auto_complete_for_country_name_english_name', 'auto_complete_for_us_state_name']


  protected

    def entry_class
      JamEntry
    end

    def mandatory_models
      ['location']
    end

    def optional_models
      ['email', 'person', 'phone_number', 'url']
    end

    def initialize_entry_and_linked_models_from_params(p)
      @entry.attributes = p[:jam_entry]
      @entry.person.attributes       = p[:jam][:person]
      @entry.email.attributes        = p[:jam][:email]
      @entry.location.attributes     = p[:jam][:location]
      @entry.phone_number.attributes = p[:jam][:phone_number]
      @entry.url.attributes          = p[:jam][:ci_url]
    end

end
