class Admin::GeocodingController < ApplicationController

  layout "admin"

  #  Protect all actions behind an admin login
  before_filter :admin_required

  def index
    @ungeocoded_locations       = Location.find(:all, :conditions => 'geocode_precision is NULL')
    @total_ungeocoded_locations = @ungeocoded_locations.size
  end

end
