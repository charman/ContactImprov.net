require 'test_helper'

class Admin::AccountRequestsControllerTest < ActionController::TestCase

  fixtures :locations, :people, :users, :user_account_requests

  def setup
    activate_authlogic
    
    @emails     = ActionMailer::Base.deliveries
    @emails.clear
  end


  #  Test 'process_account_request'
  
  def test_should_process_account_request_by_updating_ci_notes
    login_as :admin
    put :process_request,
      :account_request_id => user_account_requests(:account_request1).id,
      :user_account_request => { :ci_notes => 'updated_notes' }
    assert_redirected_to :action => 'list_new'
    user_account_requests(:account_request1).reload
    assert_match 'updated_notes', user_account_requests(:account_request1).ci_notes
  end

  def test_should_process_account_by_accepting_request
    assert_nil User.find_by_email(emails(:account_request1))

    login_as :admin
    put :process_request,
      :account_request_id => user_account_requests(:account_request1).id,
      :user_account_request => { :ci_notes => 'updated_notes' },
      :commit => 'Accept'
    assert_redirected_to :action => 'list_new'
    user_account_requests(:account_request1).reload
    assert_equal 'updated_notes', user_account_requests(:account_request1).ci_notes
    assert_equal 'accepted', user_account_requests(:account_request1).state

    user = User.find_by_email(emails(:account_request1).address)
    assert_not_nil user
    assert_equal 'pending', user.state
    assert_equal 1, @emails.size
    assert_match /A ContactImprov.net account has been created for you/, @emails.first.body
    assert_match user.activation_code, @emails.first.body
  end


  #  Test 'show_account_request' action

  def test_should_allow_admin_access_to_show_account_request
    login_as :admin
    get :show, :id => user_account_requests(:account_request1)
    assert_response :success
    assert_select "[class=errorExplanation]", false
  end

end
