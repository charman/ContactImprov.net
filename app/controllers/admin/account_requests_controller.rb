class Admin::AccountRequestsController < ApplicationController

  #  Protect all actions behind an admin login
  before_filter :admin_required

  def index
    @total_account_requests     = UserAccountRequest.count
    @total_accepted_account_requests = UserAccountRequest.count :conditions => "state ='accepted'"
    @total_new_account_requests      = UserAccountRequest.count :conditions => "state ='new'"
    @total_rejected_account_requests = UserAccountRequest.count :conditions => "state ='rejected'"

  end

  def list_account_requests
    @account_requests          = UserAccountRequest.find(:all)
    @accepted_account_requests = UserAccountRequest.find(:all, :conditions => 'state = "accepted"')
    @new_account_requests      = UserAccountRequest.find(:all, :conditions => 'state = "new"')
    @rejected_account_requests = UserAccountRequest.find(:all, :conditions => 'state = "rejected"')
  end

  def process_account_request
    if request.put?
      account_request = UserAccountRequest.find(params[:account_request_id])
      account_request.attributes = params[:user_account_request]

      #  Because the 'ci_notes' field is not attr_accessible, it won't be
      #   assigned a value when using attributes= for mass assignment
      account_request.ci_notes = params[:user_account_request][:ci_notes]

      if params[:commit] == 'Accept'
        account_request.accept!
        account_request.create_user_account_and_deliver_signup_email
      elsif params[:commit] == 'Reject'
        account_request.reject!
      # else just save the CQ comments without updating the state
      end

      account_request.save!

      redirect_to :action => 'list_account_requests'
    end
  end

  def show_account_request
    @account_request = UserAccountRequest.find(params[:id])
  end

end
