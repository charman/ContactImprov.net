require 'test_helper'


class Admin::HomeControllerTest < ActionController::TestCase

  #  Test 'exception_test' action

  def test_should_raise_exception
    login_as :admin
    assert_raise Exception do
      get :exception_test
    end
  end
  

  #  Test 'index' action

  def test_should_allow_admin_access_to_index
    get_page_as_admin_with_no_errors(:index)
  end

  def test_should_deny_access_to_non_admin_user
    login_as :quentin
    get :index
    assert_redirected_to '/denied'
    assert_select "[class=errorExplanation]", false
  end

  def test_should_deny_access_to_not_logged_in_user
    get :index
    assert_redirected_to '/denied'
    assert_select "[class=errorExplanation]", false
  end

end
