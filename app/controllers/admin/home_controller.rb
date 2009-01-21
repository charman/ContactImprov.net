class Admin::HomeController < ApplicationController

  #  Protect all actions behind an admin login
  before_filter :admin_required
  
  def index
    @total_events        = EventEntry.count
    @total_jams          = JamEntry.count
    @total_people        = PersonEntry.count
    @total_organizations = OrganizationEntry.count
    @total_users         = User.count
  end
  
end
