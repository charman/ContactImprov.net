class Admin::HomeController < ApplicationController

  #  Protect all actions behind an admin login
  before_filter :admin_required
  
end
