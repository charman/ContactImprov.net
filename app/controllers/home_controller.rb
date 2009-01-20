class HomeController < ApplicationController

  def index
    require 'RedCloth'
    @entries = EventEntry.find(:all, :order => 'start_date ASC')
  end

end
