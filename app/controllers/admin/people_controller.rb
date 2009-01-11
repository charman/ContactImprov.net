class Admin::PeopleController < ApplicationController

  include EntryAdminActions

  #  Protect all actions behind an admin login
  before_filter :admin_required

  def entry_class
    PersonEntry
  end

  def entry_display_name
    'people'
  end

end
