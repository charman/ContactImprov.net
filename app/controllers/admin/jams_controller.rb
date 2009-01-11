class Admin::JamsController < ApplicationController

  include EntryAdminActions

  #  Protect all actions behind an admin login
  before_filter :admin_required

  def entry_class
    JamEntry
  end

  def entry_display_name
    'jams'
  end

end
