class HomeController < ApplicationController

  def index
    @events = EventEntry.find(:all)
  end

end
