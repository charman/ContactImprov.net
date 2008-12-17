class EventController < ApplicationController

  auto_complete_with_params_prefix_for :country_name, :english_name
  auto_complete_with_params_prefix_for :us_state, :name


  def create
  end

  def new
    @contact_event = ContactEvent.new
    @contact_event.email        = Email.new
    @contact_event.location     = Location.new
    @contact_event.phone_number = PhoneNumber.new
    @contact_event.url          = Url.new
  end

end
