require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  require "rubygems"
  require "ruby-debug"
  Debugger.start
  
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  # include AuthenticatedTestHelper
  fixtures :country_names, :users, :us_states

  def setup
    @emails     = ActionMailer::Base.deliveries
    @emails.clear
  end


  def test_should_create_user
    assert_difference 'User.count' do
      user = create_user(:email => 'create_user@contactimprov.org')
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  def test_should_be_admin
    assert users(:admin).admin?
  end

  def test_should_create_activation_code_when_registering
    assert_nil users(:passive_user).activation_code
    assert users(:passive_user).register!
    users(:passive_user).reload
    assert users(:passive_user).activation_code
    assert users(:passive_user).activation_code.length == 40
  end

  def test_should_activate_user
    assert users(:aaron).pending?
    assert users(:aaron).activate!
    users(:aaron).reload
    assert users(:aaron).active?
  end

  def test_should_not_initialize_activation_code_upon_creation
    user = create_user(:email => 'initialize_activation_code_upon_creation@contactimprov.org')
    assert_nil user.reload.activation_code
  end

  def test_should_create_and_start_in_passive_state
    user = create_user(:email => 'create_and_start_in_passive_state@contactimprov.org')
    assert user.passive?
  end

  def test_should_require_email
    assert_no_difference 'User.count' do
      u = create_user(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_require_valid_email
    assert_no_difference 'User.count' do
      u = create_user(:email => 'bad@emailaddress')
      assert u.errors.on(:email)
    end
  end

  def test_should_require_password
    assert_no_difference 'User.count' do
      u = create_user(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference 'User.count' do
      u = create_user(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference 'User.count' do
      u = create_user(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_reset_password
    users(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:quentin), User.authenticate('quentin@contactimprov.org', 'new password')
  end

  def test_should_not_rehash_password
    users(:quentin).update_attributes(:email => 'quentin2@contactimprov.org')
    assert_equal users(:quentin), User.authenticate('quentin2@contactimprov.org', 'test')
  end

  def test_should_authenticate_user
    assert_equal users(:quentin), User.authenticate('quentin@contactimprov.org', 'test')
  end

  def test_should_set_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
  end

  def test_should_unset_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    users(:quentin).forget_me
    assert_nil users(:quentin).remember_token
  end

  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc
    users(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert users(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc
    users(:quentin).remember_me_until time
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert_equal users(:quentin).remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    users(:quentin).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert users(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_register_passive_user
    assert users(:passive_user).passive?
    users(:passive_user).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    users(:passive_user).register!
    assert users(:passive_user).pending?
  end

  def test_should_suspend_user
    users(:quentin).suspend!
    assert users(:quentin).suspended?
  end

  def test_suspended_user_should_not_authenticate
    users(:quentin).suspend!
    assert_not_equal users(:quentin), User.authenticate('quentin', 'test')
  end

  def test_should_unsuspend_user_to_active_state
    users(:quentin).suspend!
    assert users(:quentin).suspended?
    users(:quentin).unsuspend!
    assert users(:quentin).active?
  end

  def test_should_unsuspend_user_with_nil_activation_code_and_activated_at_to_passive_state
    users(:quentin).suspend!
    User.update_all :activation_code => nil, :activated_at => nil
    assert users(:quentin).suspended?
    users(:quentin).reload.unsuspend!
    assert users(:quentin).passive?
  end

  def test_should_unsuspend_user_with_activation_code_and_nil_activated_at_to_pending_state
    users(:quentin).suspend!
    User.update_all :activation_code => 'foo-bar', :activated_at => nil
    assert users(:quentin).suspended?
    users(:quentin).reload.unsuspend!
    assert users(:quentin).pending?
  end

  def test_should_delete_user
    assert_nil users(:quentin).deleted_at
    users(:quentin).delete!
    assert_not_nil users(:quentin).deleted_at
    assert users(:quentin).deleted?
  end

protected
  def create_user(options = {})
    User.create({ :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
  end
end
