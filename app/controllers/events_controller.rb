class EventsController < ApplicationController

  include EntryFormWithOptionalModels

  auto_complete_with_params_prefix_for :country_name, :english_name
  auto_complete_with_params_prefix_for :us_state, :name

  before_filter :login_required, :only => [:create, :delete, :edit, :new]

  skip_before_filter :verify_authenticity_token, 
    :only => ['auto_complete_for_country_name_english_name', 'auto_complete_for_us_state_name']


  def list
    @entries = EventEntry.find(:all, :order => 'start_date ASC')
  end

protected

  def category_name_plural
    'Special Events'
  end

  def category_name_singular
    'Special Event'
  end

  def category_title
    "#{category_name_plural} &mdash; "
  end
  
  def category_subtitle
    "conferences, festivals, regional jams and workshops"
  end
  
  def entry_class
    EventEntry
  end
  
  def entry_display_name
    'Event'
  end

  def mandatory_models
    ['location']
  end
  
  def optional_models
    ['email', 'person', 'phone_number', 'url']
  end

end
