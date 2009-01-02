class HomeController < ApplicationController

  def index
    @events = ContactEvent.find(:all)
  end

end
