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

  def test_should_sanitize_something_and_existing
    r = UserAccountRequest.new
    r.something_about_contact_improv = '<b>sanitized</b>'
    r.existing_entries = '<b>sanitized</b>'
    r.save!
    r.reload
    assert_equal 'sanitized', r.something_about_contact_improv
    assert_equal 'sanitized', r.existing_entries
  end

end
