class Admin::MotivationController < ApplicationController

  #  Protect all actions behind an admin login
  before_filter :admin_required


  def index
    @reasons = UserAccountRequest.find(:all, :conditions => "state = 'accepted'").collect do
      |r| r.something_about_contact_improv
    end
  end

end
