class StudioController < ApplicationController

  include EntryFormWithOptionalModels

  auto_complete_with_params_prefix_for :country_name, :english_name
  auto_complete_with_params_prefix_for :us_state, :name

  before_filter :login_required, :only => [:create, :delete, :edit, :new]

  skip_before_filter :verify_authenticity_token, 
    :only => ['auto_complete_for_country_name_english_name', 'auto_complete_for_us_state_name']


protected

  def entry_class
    StudioEntry
  end

  def entry_display_name
    'Studio'
  end

  def mandatory_models
    ['studio', 'location']
  end

  def optional_models
    ['email', 'phone_number', 'url']
  end

end
