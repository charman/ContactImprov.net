require 'test_helper'

class UserMailerTest < ActiveSupport::TestCase

  fixtures :users

  def setup
  end


  def test_activation
    email = UserMailer.activation(users(:quentin)).deliver
    assert !ActionMailer::Base.deliveries.empty?
  end
  
  def test_password_reset
    email = UserMailer.password_reset(users(:quentin)).deliver
    assert !ActionMailer::Base.deliveries.empty?
  end
  
  def test_password_reset_by_admin
    email = UserMailer.password_reset_by_admin(users(:quentin), 'newpassword').deliver
    assert !ActionMailer::Base.deliveries.empty?
  end
  
  def test_signup_notification
    email = UserMailer.signup_notification(users(:quentin)).deliver
    assert !ActionMailer::Base.deliveries.empty?
  end

end
