require 'test_helper'

class Admin::HomeControllerTest < ActionController::TestCase

  #  Test 'exception_test' action

  def test_should_raise_exception
    login_as :admin
    assert_raise Exception do
      get :exception_test
    end
    # TODO:  I'd really like this test to verify that ExceptionNotifier is working properly,
    #        but haven't figured out how to do so yet.
  end
  

  #  Test 'index' action

  def test_should_allow_admin_access_to_index
    get_page_as_admin_with_no_errors(:index)
  end

end
