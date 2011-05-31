class Admin::HomeController < ApplicationController

  layout "admin"

  #  Protect all actions behind an admin login
  before_filter :admin_required, :except => :exception_test

  
  def exception_test
    raise Exception, "This action used for functional testing of exception handling"
  end
  
  def index
    @total_new_account_requests = UserAccountRequest.count :conditions => "state ='new'"
    @total_events        = EventEntry.count
    @total_jams          = JamEntry.count
    @total_people        = PersonEntry.count
    @total_organizations = OrganizationEntry.count
    @total_users         = User.count
    @total_ungeocoded_locations = Location.count(:all, :conditions => 'geocode_precision is NULL')
  end
  
end
