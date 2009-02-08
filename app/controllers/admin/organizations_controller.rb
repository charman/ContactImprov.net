class Admin::OrganizationsController < ApplicationController

  include EntryAdminActions

  #  Protect all actions behind an admin login
  before_filter :admin_required

  def entry_class
    OrganizationEntry
  end

  def entry_display_name
    'organizations'
  end

end
