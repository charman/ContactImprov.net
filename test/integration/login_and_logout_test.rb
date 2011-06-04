require 'test_helper'

class LoginAndLogoutTest < ActionDispatch::IntegrationTest
  fixtures :all

  #  Login behavior

  test "on login redirect to original page" do
    get '/login', {}, { 'HTTP_REFERER' => '/events' }
    assert_response :success
    assert_equal '/events', flash[:login_referer_page]

    post_via_redirect '/sessions/create', :email => users(:quentin).email, :password => 'test'
    assert_equal '/events', path
  end

  test "redirect to original page if already logged in" do
    post_via_redirect '/sessions/create', :email => users(:quentin).email, :password => 'test'
    assert_equal '/', path

    get_via_redirect '/login', {}, { 'HTTP_REFERER' => '/events' }
    assert_equal '/events', path
  end

  test "redirect to home if already logged in and no referer" do
    post_via_redirect '/sessions/create', :email => users(:quentin).email, :password => 'test'
    assert_equal '/', path

    get_via_redirect '/login'
    assert_equal '/', path
  end


  #  Logout behavior

  test "on logout redirect to original page" do
    post_via_redirect '/sessions/create', :email => users(:quentin).email, :password => 'test'
    assert_equal '/', path

    get_via_redirect '/logout', {}, { 'HTTP_REFERER' => '/events' }
    assert_equal '/events', path
  end

  test "redirect to original page if already logged out" do
    get_via_redirect '/logout', {}, { 'HTTP_REFERER' => '/events' }
    assert_equal '/events', path
  end

  test "redirect to home if already logged out and no referer" do
    get_via_redirect '/logout'
    assert_equal '/', path
  end

end
