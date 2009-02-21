class PeopleController < ApplicationController

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
    @category_title    = category_title
    @category_subtitle = category_subtitle
    list_by_country
  end

protected

  def category_name_plural
    'People'
  end

  def category_name_singular
    'Person'
  end
  
  def category_title
    "#{category_name_plural} &mdash; "
  end
  
  def category_subtitle
    "teaching, performing, or otherwise involved in Contact"
  end

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

end
