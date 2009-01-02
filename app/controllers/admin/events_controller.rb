class Admin::EventsController < ApplicationController

  def index
    @total_events = ContactEvent.count
  end

  def list
    @events = ContactEvent.find(:all)
  end

end
