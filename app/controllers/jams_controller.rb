class JamsController < ApplicationController

  include EntryFormWithOptionalModels

  auto_complete_with_params_prefix_for :country_name, :english_name
  auto_complete_with_params_prefix_for :us_state, :name

  before_filter :login_required, :only => [:create, :delete, :edit, :new]

  skip_before_filter :verify_authenticity_token, 
    :only => ['auto_complete_for_country_name_english_name', 'auto_complete_for_us_state_name']


  def index
    index_by_country
  end

  def list
    list_by_country
  end

protected

  def category_name_plural
    'Ongoing Jams/Classes'
  end

  def category_name_singular
    'Ongoing Jam/Class'
  end
  
  def entry_class
    JamEntry
  end

  def entry_display_name
    'Jam'
  end

  def mandatory_models
    ['location']
  end

  def optional_models
    ['email', 'person', 'phone_number', 'url']
  end

end
