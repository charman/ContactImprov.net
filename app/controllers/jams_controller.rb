class JamsController < ApplicationController

  include EntryFormWithOptionalModels

  before_filter :login_required, :only => [:create, :delete, :edit, :new]
  cache_sweeper :jam_entry_sweeper


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
    'Ongoing Jams/Classes'
  end

  def category_name_singular
    'Ongoing Jam/Class'
  end
  
  def category_title
    "#{category_name_plural} &mdash; "
  end
  
  def category_subtitle
    "local classes and jams – <i>&quot;regularly scheduled dancing&quot;</i>"
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
