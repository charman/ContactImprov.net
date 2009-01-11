class Admin::StudiosController < ApplicationController

  include EntryAdminActions

  #  Protect all actions behind an admin login
  before_filter :admin_required

  def entry_class
    StudioEntry
  end

  def entry_display_name
    'studios'
  end

end
