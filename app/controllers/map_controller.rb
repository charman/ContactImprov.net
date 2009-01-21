class MapController < ApplicationController

  def index
    @locations = Location.find(:all, :conditions => "geocode_precision IS NOT NULL")
  end

end
