class HomeController < ApplicationController

  def index
    require 'RedCloth'
    @events = EventEntry.find(:all)
  end

end
