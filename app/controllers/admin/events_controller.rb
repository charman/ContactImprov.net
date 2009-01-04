class Admin::EventsController < ApplicationController

  #  Protect all actions behind an admin login
  before_filter :admin_required

  
  def index
    @total_events = ContactEvent.count
  end

  def list
    @events = ContactEvent.find(:all)
  end

end
