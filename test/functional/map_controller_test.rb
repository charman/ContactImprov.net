require 'test_helper'

class MapControllerTest < ActionController::TestCase

  #  Test 'index' action

  def test_should_allow_access_to_index
    get :index
    assert_response :success
    assert_select "[class=errorExplanation]", false
  end

end
