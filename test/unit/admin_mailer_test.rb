require 'test_helper'

class AdminMailerTest < ActiveSupport::TestCase

  fixtures :event_entries, :user_account_requests, :users

  def setup
    @admin_email_address = "ci@craigharman.net"
  end


  def test_account_request
    email = AdminMailer.account_request(user_account_requests(:account_request1)).deliver
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal @admin_email_address, email.to.first
    assert_match /Account request for/, email.subject
  end

  def test_entry_modified
    email = AdminMailer.entry_modified(event_entries(:complete_event_entry), 'Event').deliver
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal @admin_email_address, email.to.first
    assert_match /Modified Event/, email.subject
  end

  def test_new_entry_created
    email = AdminMailer.new_entry_created(event_entries(:complete_event_entry), 'Event').deliver
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal @admin_email_address, email.to.first
    assert_match /New Event/, email.subject
  end

  def test_passive_user_login_attempt
    email = AdminMailer.passive_user_login_attempt('craig@contactimprov.net').deliver
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal @admin_email_address, email.to.first
    assert_match /Login attempt from craig@contactimprov\.net/, email.subject
  end

  def test_user_changed_email
    email = AdminMailer.user_changed_email('old@contactimprov.net', 'new@contactimprov.net', users(:quentin)).deliver
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal @admin_email_address, email.to.first
    assert_match /User.*changed their/, email.subject
  end

end
