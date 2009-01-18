class HomeController < ApplicationController

  def index
    require 'RedCloth'
    @events = EventEntry.find(:all, :order => 'start_date ASC')
  end

end
