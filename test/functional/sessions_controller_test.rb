require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  #  Test 'create' action

  def test_should_not_login_pending_user_with_password
    assert users(:aaron).pending?
    post :create, :email => users(:aaron).email, :password => 'test'
    assert_nil UserSession.find
    assert flash[:notice]
    assert_redirected_to :action => 'new'
  end

  def test_should_resend_activation_email_to_pending_user
    assert users(:aaron).pending?
    post :create, :email => users(:aaron).email, :password => 'test'
    assert_equal(1, @emails.size)
    #  TODO: Test values of the email subject, recipient, and body
  end

  def test_should_redirect_admin_to_admin_page
    post :create, :email => users(:admin).email, :password => 'test'
    assert user_session = UserSession.find
    assert_equal users(:admin), user_session.user
    assert_redirected_to :controller => 'home', :action => 'index'
  end

  def test_should_login_and_redirect
    assert_nil UserSession.find
    post :create, :email => users(:quentin).email, :password => 'test'
    assert user_session = UserSession.find
    assert_equal users(:quentin), user_session.user
    assert_response :redirect
  end

  def test_should_login_and_redirect_with_whitespace_around_email
    post :create, :email => " #{users(:quentin).email} ", :password => 'test'
    assert user_session = UserSession.find
    assert_equal users(:quentin), user_session.user
    assert_response :redirect
  end
  
  def test_should_not_login_with_bad_password_and_redirect
    post :create, :email => users(:quentin).email, :password => 'bad password'
    assert_nil UserSession.find
    assert flash[:notice]
    assert_redirected_to :action => 'new'
  end
  
  def test_should_not_login_with_empty_password_and_redirect
    post :create, :email => users(:quentin).email, :password => ''
    assert_nil UserSession.find
    assert flash[:notice]
    assert_redirected_to :action => 'new'
  end
  
  def test_should_not_login_with_empty_email_and_redirect
    post :create, :email => '', :password => ''
    assert_nil UserSession.find
    assert flash[:notice]
    assert_redirected_to :action => 'new'
  end
  
  def test_should_not_login_suspended_user
    post :create, :email => users(:suspended_user).email, :password => 'test'
    assert_nil UserSession.find
    assert flash[:notice]
    assert_redirected_to :action => 'new'
  end
  
  def test_should_not_login_deleted_user
    post :create, :email => users(:deleted_user).email, :password => 'test'
    assert_nil UserSession.find
    assert flash[:notice]
    assert_redirected_to :action => 'new'
  end

  # def test_should_remember_me
  #   post :create, :email => users(:quentin).email, :password => 'test', :remember_me => "1"
  #   assert_not_nil @response.cookies["auth_token"]
  # end
  # 
  # def test_should_not_remember_me
  #   post :create, :email => users(:quentin).email, :password => 'test', :remember_me => "0"
  #   assert_nil @response.cookies["auth_token"]
  # end
  

  #  Test 'destroy' action

  def test_should_logout
    assert_nil UserSession.find
    login_as :quentin
    assert UserSession.find
    assert_equal users(:quentin), UserSession.find.user
    get :destroy
    assert_nil UserSession.find
    assert_response :redirect
  end

  def test_should_redirect_if_anonymously_trying_to_logout
    assert_nil UserSession.find
    get :destroy
    assert_nil UserSession.find
    assert_response :redirect
  end

  #  Test 'new' action

  # def test_should_login_with_cookie
  #   users(:quentin).remember_me
  #   @request.cookies["auth_token"] = cookie_for(:quentin)
  #   get :new
  #   assert @controller.send(:logged_in?)
  # end
  # 
  # def test_should_fail_expired_cookie_login
  #   users(:quentin).remember_me
  #   users(:quentin).update_attribute :remember_token_expires_at, 5.minutes.ago
  #   @request.cookies["auth_token"] = cookie_for(:quentin)
  #   get :new
  #   assert !@controller.send(:logged_in?)
  # end
  # 
  # def test_should_fail_cookie_login
  #   users(:quentin).remember_me
  #   @request.cookies["auth_token"] = auth_token('invalid_auth_token')
  #   get :new
  #   assert !@controller.send(:logged_in?)
  # end


  # protected
  #   def auth_token(token)
  #     CGI::Cookie.new('name' => 'auth_token', 'value' => token)
  #   end
  #   
  #   def cookie_for(user)
  #     auth_token users(user).remember_token
  #   end
end
