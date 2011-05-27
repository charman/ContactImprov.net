require 'test_helper'

class JamsControllerTest < ActionController::TestCase

  #  Test 'list' action

  def test_should_allow_access_to_list
    get :list
    assert_response :success
    assert_select "[class=errorExplanation]", false
  end


  #  Test 'show' action

  def test_should_allow_access_to_show
    get :show, :id => jam_entries(:complete_jam_entry)
    assert_response :success
    assert_select "[class=errorExplanation]", false
  end

  def test_should_display_error_for_show_with_invalid_id
    get :show, :id => 666
    assert_response :success
    assert_select "[class=errorExplanation]"
    assert_match /Listing not found/, @response.body
  end

end
