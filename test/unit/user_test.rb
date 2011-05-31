require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def test_should_create_user
    assert_difference 'User.count' do
      create_user(:email => 'createuser@contactimprov.org')
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
    u = create_user(:email => 'initialize_activation_code_upon_creation@contactimprov.org')
    assert_nil u.reload.activation_code
  end

  def test_should_create_and_start_in_passive_state
    u = create_user(:email => 'create_and_start_in_passive_state@contactimprov.org')
    assert u.passive?
  end

  def test_should_require_email
    assert_no_difference 'User.count' do
      u = create_user(:email => nil)
      assert u.errors[:email]
    end
  end

  def test_should_require_valid_email
    assert_no_difference 'User.count' do
      u = create_user(:email => 'bad@emailaddress')
      assert u.errors[:email]
    end
  end

  def test_should_require_password
    assert_no_difference 'User.count' do
      u = create_user(:password => nil)
      assert u.errors[:password]
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference 'User.count' do
      u = create_user(:password_confirmation => nil)
      assert u.errors[:password_confirmation]
    end
  end

  def test_should_require_email
    assert_no_difference 'User.count' do
      u = create_user(:email => nil)
      assert u.errors[:email]
    end
  end

  def test_should_reset_password
    assert_equal users(:quentin), User.authenticate('quentin@contactimprov.org', 'test')
    users(:quentin).password = 'new password' #update_attributes(:password => 'new password', :password_confirmation => 'new password')
    users(:quentin).password_confirmation = 'new password'
    users(:quentin).save!
    assert_equal users(:quentin), User.authenticate('quentin@contactimprov.org', 'new password')
  end

  def test_should_authenticate_user
    assert_equal users(:quentin), User.authenticate('quentin@contactimprov.org', 'test')
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
    User.create({ :email => 'quire@example.com', :password => 'quired', :password_confirmation => 'quired' }.merge(options))
  end

end
