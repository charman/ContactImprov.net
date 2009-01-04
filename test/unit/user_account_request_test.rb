require 'test_helper'

class UserAccountRequestTest < ActiveSupport::TestCase

  fixtures :emails, :people, :user_account_requests, :users

  def setup
    @emails     = ActionMailer::Base.deliveries
    @emails.clear
  end


  def test_should_create_account_from_request
    assert_nil User.find_by_email(emails(:account_request1))
    user_account_requests(:account_request1).create_user_account_and_deliver_signup_email
    user = User.find_by_email(emails(:account_request1).address)
    assert_not_nil user
    assert_equal 'pending', user.state
    assert_equal 1, @emails.size
    assert_match /A ContactImprov.net account has been created for you/, @emails.first.body
  end

end
