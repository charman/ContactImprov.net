class Admin::AccountRequestsController < ApplicationController

  #  Protect all actions behind an admin login
  before_filter :admin_required

  def index
    @total_account_requests     = UserAccountRequest.count
    @total_accepted_account_requests = UserAccountRequest.count :conditions => "state ='accepted'"
    @total_new_account_requests      = UserAccountRequest.count :conditions => "state ='new'"
    @total_rejected_account_requests = UserAccountRequest.count :conditions => "state ='rejected'"
  end

  def list
    @account_requests          = UserAccountRequest.find(:all)
    @list_scope = 'All'
  end

  def list_accepted
    @account_requests = UserAccountRequest.find(:all, :conditions => 'state = "accepted"')
    @list_scope = 'Accepted'
    render :action => 'list'
  end

  def list_new
    @account_requests      = UserAccountRequest.find(:all, :conditions => 'state = "new"')
    @list_scope = 'New'
    render :action => 'list'
  end
  
  def list_rejected
    @account_requests = UserAccountRequest.find(:all, :conditions => 'state = "rejected"')
    @list_scope = 'Rejected'
    render :action => 'list'
  end

  #  fyi - :process conflicts with some internal Rails or Ruby symbol name
  def process_request
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

      redirect_to :action => 'list_new'
    end
  end

  def show
    @account_request = UserAccountRequest.find(params[:id])
  end

end
