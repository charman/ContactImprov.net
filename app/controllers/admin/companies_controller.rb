class Admin::CompaniesController < ApplicationController

  include EntryAdminActions

  #  Protect all actions behind an admin login
  before_filter :admin_required

  def entry_class
    CompanyEntry
  end

  def entry_display_name
    'companies'
  end

end
