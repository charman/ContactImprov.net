class Admin::GeocodingController < ApplicationController

  def index
    @ungeocoded_locations       = Location.find(:all, :conditions => 'geocode_precision is NULL')
    @total_ungeocoded_locations = @ungeocoded_locations.size
  end

end
