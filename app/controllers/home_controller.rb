class HomeController < ApplicationController

  def index
    @entries = EventEntry.find(:all, :order => 'start_date ASC')
  end

end
