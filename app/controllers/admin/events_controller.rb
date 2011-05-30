class Admin::EventsController < ApplicationController

  layout "admin"

  include EntryAdminActions

  #  Protect all actions behind an admin login
  before_filter :admin_required

  def entry_class
    EventEntry
  end

  def entry_display_name
    'events'
  end

end
