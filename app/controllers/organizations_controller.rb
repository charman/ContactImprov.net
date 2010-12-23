class OrganizationsController < ApplicationController

  include EntryFormWithOptionalModels

  before_filter :login_required, :only => [:create, :delete, :edit, :new]


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
    'Organizations'
  end

  def category_name_singular
    'Organization'
  end

  def category_title
    "#{category_name_plural} &mdash; "
  end
  
  def category_subtitle
    "regional websites, studios, companies, etc. – <i>&quot;everything else&quot;</i>"
  end

  def entry_class
    OrganizationEntry
  end

  def entry_display_name
    'Organization'
  end

  def mandatory_models
    ['organization', 'location']
  end

  def optional_models
    ['email', 'phone_number', 'url']
  end

end
