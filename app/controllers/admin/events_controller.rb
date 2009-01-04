class Admin::EventsController < ApplicationController

  #  Protect all actions behind an admin login
  before_filter :admin_required

  
  def index
    @total_events = EventEntry.count
  end

  def list
    @events = EventEntry.find(:all)
  end

end
