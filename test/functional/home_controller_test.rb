require 'test_helper'

class HomeControllerTest < ActionController::TestCase


  #  Test 'index' action

  test "get index" do
    get :index
    assert_response :success
    assert_select "[class=errorExplanation]", false
  end

end
